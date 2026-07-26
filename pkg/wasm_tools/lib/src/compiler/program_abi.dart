import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

import 'components/linker.dart';
import 'components/type.dart';
import 'components/wit.dart';
import 'dart_linker.dart';

/// Information about all component imports and exports used in the Dart
/// program being compiled.
///
/// We collect this information through build hooks.
final class DartProgramAbi {
  final Map<String, ResolvedInterface> _interfaces = {};

  final Map<String, ImportedInstanceFunctionOrCanon> functionImports = {};
  final Map<String, ExportedInstanceFunction> functionExports = {};

  Iterable<ResolvedInterface> get interfaces => _interfaces.values;

  Iterable<String> get expectedExportedFunctions sync* {
    for (final export in functionExports.values) {
      yield export.exportCoreFunctionName;
      if (export.options.postReturn case final postReturn?) {
        yield postReturn;
      }
    }
  }

  bool get hasAsyncExport {
    return functionExports.values.any((e) => e.options.usesCallback);
  }

  ResolvedInterface lookupOrAddInterface(
    String name,
    ResolvedInterface Function() create,
  ) {
    return _interfaces.putIfAbsent(name, create);
  }

  void includeAsset(Logger logger, EncodedAsset asset) {
    final encoding = asset.encoding;
    final definitions = ResolvedWitDefinitions();
    definitions.readTypes(encoding['type_defs'] as List);
    final interfaces = <ResolvedInterface>[];

    for (final entry
        in (encoding['interfaces'] as List).cast<Map<String, Object?>>()) {
      final fullName = entry['full_name'] as String;
      final instanceType = InstanceTypeBuilder();

      interfaces.add(
        lookupOrAddInterface(fullName, () {
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

            instanceType.exportFunction(
              name,
              FunctionType(async: async, parameters: params, result: result),
            );
          }

          return ResolvedInterface(fullName, instanceType.build());
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

    final canons = (encoding['canons'] as List).cast<Map<String, Object?>>();
    for (final canon in canons) {
      final coreName = canon['core_name'] as String;
      final definition = canon['canon'] as Map<String, Object?>;
      functionImports[coreName] = ImportedCanonPrimitive(coreName, (linker) {
        final MapEntry(key: type, :value as Map<String, Object?>) =
            definition.entries.single;

        switch (type) {
          case 'StreamNew':
            final type = linker.builder.types.addValueType(
              definitions.types[value['stream_type'] as int],
            );
            return linker.builder.linker.addCanonPrimitive(
              (f) => StreamNew(f, type),
            );
          case 'StreamWrite':
            final type = linker.builder.types.addValueType(
              definitions.types[value['stream_type'] as int],
            );
            final options = FunctionOptions.fromJson(
              value['options'] as Map<String, Object?>,
            );
            return linker.builder.linker.addCanonPrimitive((f) {
              final write = StreamWrite(f, type);
              linker.applyOptions(options, write);
              return write;
            });
          case 'StreamDropWritable':
            final type = linker.builder.types.addValueType(
              definitions.types[value['stream_type'] as int],
            );
            return linker.builder.linker.addCanonPrimitive(
              (f) => StreamDropWritable(f, type),
            );
          default:
            throw UnsupportedError('Unsupported canon primitive $type');
        }
      });
    }

    final exports = (encoding['exports'] as List).cast<Map<String, Object?>>();
    for (final rawExport in exports) {
      final interface = interfaces[rawExport['interface_id'] as int];
      final functionName = rawExport['function_name'] as String;
      final coreName = rawExport['core_export_name'] as String;
      final options = FunctionOptions.fromJson(
        rawExport['options'] as Map<String, Object?>,
      );

      final functionType = interface.type.functionExports
          .singleWhere((e) => e.name == functionName)
          .function;

      final export = ExportedInstanceFunction(
        coreName,
        functionName,
        functionType,
        options,
      );
      functionExports[coreName] = export;
      interface.exports.add(export);

      if (options.returnImport case final returnImport?) {
        functionImports[returnImport] = ImportedCanonPrimitive(returnImport, (
          linker,
        ) {
          final taskReturn = linker.builder.linker.addCanonPrimitive((idx) {
            final originalResultType = functionType.result;
            ValueTypeReference? result;
            if (originalResultType != null) {
              result = linker.builder.types.addValueType(originalResultType);
            }

            return TaskReturn(idx, result);
          });
          linker.applyOptions(options, taskReturn);

          return taskReturn;
        });
      }
    }
  }
}

final class FunctionOptions {
  final bool usesMemory;
  final bool usesStrings;
  final bool needsRealloc;
  final bool usesCallback;
  final String? postReturn;
  final String? returnImport;
  final bool async;

  FunctionOptions({
    required this.usesMemory,
    required this.usesStrings,
    this.needsRealloc = false,
    this.usesCallback = false,
    this.postReturn,
    this.returnImport,
    this.async = false,
  });

  factory FunctionOptions.fromJson(Map<String, Object?> json) {
    return FunctionOptions(
      usesMemory: json['use_memory'] as bool,
      usesStrings: json['uses_strings'] as bool,
      needsRealloc: json['needs_realloc'] as bool? ?? false,
      usesCallback: json['uses_callback'] as bool? ?? false,
      postReturn: json['post_return'] as String?,
      returnImport: json['task_return_import'] as String?,
      async: json['async'] as bool? ?? false,
    );
  }
}

final class ImportedInstanceFunctionOrCanon {
  final String coreImport;

  new(this.coreImport);
}

final class ImportedInstanceFunction extends ImportedInstanceFunctionOrCanon {
  final String interfaceMethod;
  final FunctionOptions options;

  new(this.interfaceMethod, super.coreImport, this.options);
}

final class ImportedCanonPrimitive extends ImportedInstanceFunctionOrCanon {
  CanonPrimitive Function(DartLinker) resolve;

  new(super.coreImport, this.resolve);
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
