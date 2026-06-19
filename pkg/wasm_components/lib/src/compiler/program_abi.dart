import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

import 'components/type.dart';
import 'components/wit.dart';
import 'hooks/extension.dart';

/// Information about all component imports and exports used in the Dart
/// program being compiled.
///
/// We collect this information through build hooks.
final class DartProgramAbi {
  final List<ImportedComponentInstance> importedInstances = [];
  final List<ExportedComponentInstance> exportedInstances = [];

  final Map<String, ImportedInstanceFunction> functionImports = {};
  final Map<String, ExportedInstanceFunction> functionExports = {};

  void includeAsset(Logger logger, EncodedAsset asset) {
    final encoding = asset.encoding;
    final definitions = ResolvedWitDefinitions()
      ..readJson(encoding['wit'] as Map<String, Object?>);
    final addedImports = <ResolvedInstance, ImportedComponentInstance>{};

    final imports = (encoding['imports'] as List).cast<Map<String, Object?>>();
    for (final rawImport in imports) {
      final wasmImportName = rawImport['import'] as String;
      final instance =
          definitions.instances[rawImport['interfaceIndex'] as int];
      final functionName = rawImport['functionName'] as String;

      final imported = addedImports.putIfAbsent(instance, () {
        final imported = ImportedComponentInstance(
          instance.fullName,
          instance.type,
        );
        importedInstances.add(imported);
        return imported;
      });

      final function = ImportedInstanceFunction(
        imported,
        functionName,
        _readFunctionOptions(rawImport['options'] as Map<String, Object?>),
      );
      imported.importedFunctions.add(function);
      functionImports[wasmImportName] = function;
    }

    final exports = (encoding['exports'] as List).cast<Map<String, Object?>>();
    for (final rawExport in exports) {
      final name = rawExport['name'] as String;
      final interface =
          definitions.instances[rawExport['interfaceIndex'] as int].type;
      final exportedFunctions = <ExportedInstanceFunction>[];

      final functions = rawExport['functions'] as Map<String, Object?>;
      for (final MapEntry(:key, :value) in functions.entries) {
        final type = interface.exports.firstWhere((e) => e.$1 == key).$2;
        value as Map<String, Object?>;
        final exportName = value['exportName'] as String;
        final options = _readFunctionOptions(
          value['options'] as Map<String, Object?>,
        );

        final export = ExportedInstanceFunction(exportName, key, type, options);
        functionExports[exportName] = export;
        exportedFunctions.add(export);
      }

      final instance = ExportedComponentInstance(name, exportedFunctions);
      exportedInstances.add(instance);
    }
  }

  FunctionOptions _readFunctionOptions(Map<String, Object?> options) {
    return FunctionOptions(
      useMemory: options['useMemory'] as bool,
      stringEncoding: switch (options['stringEncoding'] as String?) {
        null => null,
        'utf8' => .utf8,
        'utf16' => .utf16,
        'latin1OrUtf16' => .latin1OrUtf16,
        _ => throw ArgumentError('Unknown string encoding in $options'),
      },
    );
  }
}

final class ImportedComponentInstance {
  final String instanceName;
  final InstanceType type;

  final List<ImportedInstanceFunction> importedFunctions = [];

  ImportedComponentInstance(this.instanceName, this.type);
}

final class ImportedInstanceFunction {
  final ImportedComponentInstance instance;
  final String function;
  final FunctionOptions options;

  ImportedInstanceFunction(this.instance, this.function, this.options);
}

final class ExportedComponentInstance {
  final String instanceName;
  final List<ExportedInstanceFunction> exports;

  ExportedComponentInstance(this.instanceName, this.exports);
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
