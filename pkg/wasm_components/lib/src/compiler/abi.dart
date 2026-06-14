import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

import 'components/type.dart';
import 'components/wit.dart';

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

    final exports = (encoding['exports'] as List).cast<Map<String, Object?>>();
    for (final rawExport in exports) {
      final name = rawExport['name'] as String;
      final interface =
          definitions.instances[rawExport['interfaceIndex'] as int].type;
      final exportedFunctions = <ExportedInstanceFunction>[];

      final functions = (rawExport['functions'] as Map<String, Object?>)
          .cast<String, String>();
      for (final MapEntry(:key, :value) in functions.entries) {
        final type = interface.exports.firstWhere((e) => e.$1 == key).$2;
        final export = ExportedInstanceFunction(value, key, type);
        functionExports[value] = export;
        exportedFunctions.add(export);
      }

      final instance = ExportedComponentInstance(name, exportedFunctions);
      exportedInstances.add(instance);
    }
  }
}

final class ImportedComponentInstance {
  final String instanceName;
  final InstanceType type;

  ImportedComponentInstance(this.instanceName, this.type);
}

final class ImportedInstanceFunction {
  final ImportedComponentInstance instance;
  final String function;

  ImportedInstanceFunction(this.instance, this.function);
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

  ExportedInstanceFunction(this.exportCoreFunctionName, this.name, this.type);
}
