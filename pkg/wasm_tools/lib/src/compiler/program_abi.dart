import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

import 'components/type.dart';
import 'components/wit.dart';

/// Information about all component imports and exports used in the Dart
/// program being compiled.
///
/// We collect this information through build hooks.
final class DartProgramAbi {
  final Map<String, ResolvedInterface> _interfaces = {};

  final Map<String, ImportedInstanceFunction> functionImports = {};
  final Map<String, ExportedInstanceFunction> functionExports = {};

  Iterable<ResolvedInterface> get interfaces => _interfaces.values;

  void includeAsset(Logger logger, EncodedAsset asset) {
    final encoding = asset.encoding;
    final definitions = ResolvedWitDefinitions();
    definitions.readTypes(encoding['type_defs'] as List);
    final interfaces = <ResolvedInterface>[];

    for (final entry
        in (encoding['interfaces'] as List).cast<Map<String, Object?>>()) {
      final fullName = entry['full_name'] as String;
      final functions = <(String, FunctionType)>[];

      interfaces.add(
        _interfaces.putIfAbsent(fullName, () {
          for (final function
              in (entry['exported_functions'] as Map<String, Object?>)
                  .entries) {
            final name = function.key;
            final value = function.value as Map<String, Object?>;
            final params = <RecordField>[
              for (final rawParam in value['params'] as List)
                RecordField(
                  label: rawParam['name'] as String,
                  type: definitions.readType(rawParam['type'] as Object),
                ),
            ];
            final result = definitions.readOptionalType(value['result']);
            final async = (value['kind'] as String).contains('async');

            functions.add((
              name,
              FunctionType(async: async, parameters: params, result: result),
            ));
          }

          return ResolvedInterface(fullName, InstanceType(functions));
        }),
      );
    }

    final imports = (encoding['imports'] as List).cast<Map<String, Object?>>();
    for (final rawImport in imports) {
      final interface = interfaces[rawImport['interface_id'] as int];

      final functionName = rawImport['function_name'] as String;
      final coreFunctionName = rawImport['core_name'] as String;
      final options = FunctionOptions.fromJson(
        rawImport['options'] as Map<String, Object?>,
      );
      final instanceFunction = ImportedInstanceFunction(
        functionName,
        coreFunctionName,
        options,
      );
      interface.importedFunctions.add(instanceFunction);
      functionImports[coreFunctionName] = instanceFunction;
    }

    final exports = (encoding['exports'] as List).cast<Map<String, Object?>>();
    for (final rawExport in exports) {
      final interface = interfaces[rawExport['interface_id'] as int];
      final functionName = rawExport['function_name'] as String;
      final coreName = rawExport['core_export_name'] as String;
      final options = FunctionOptions.fromJson(
        rawExport['options'] as Map<String, Object?>,
      );

      final export = ExportedInstanceFunction(
        coreName,
        functionName,
        interface.type.exports.singleWhere((e) => e.$1 == functionName).$2,
        options,
      );
      functionExports[coreName] = export;
      interface.exports.add(export);
    }
  }
}

final class FunctionOptions {
  final bool usesMemory;
  final bool usesStrings;

  FunctionOptions({required this.usesMemory, required this.usesStrings});

  factory FunctionOptions.fromJson(Map<String, Object?> json) {
    return FunctionOptions(
      usesMemory: json['use_memory'] as bool,
      usesStrings: json['uses_strings'] as bool,
    );
  }
}

final class ImportedInstanceFunction {
  final String interfaceMethod;
  final String coreImport;
  final FunctionOptions options;

  ImportedInstanceFunction(this.interfaceMethod, this.coreImport, this.options);
}

final class ExportedInstanceFunction {
  final String exportCoreFunctionName;
  final String name;
  final FunctionType type;
  final FunctionOptions options;

  ExportedInstanceFunction(
    this.exportCoreFunctionName,
    this.name,
    this.type,
    this.options,
  );
}

final class ResolvedInterface {
  final String fullName;
  final InstanceType type;

  final List<ImportedInstanceFunction> importedFunctions = [];
  final List<ExportedInstanceFunction> exports = [];

  ResolvedInterface(this.fullName, this.type);
}
