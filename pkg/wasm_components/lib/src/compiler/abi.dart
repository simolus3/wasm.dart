import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

import 'components/component.dart';
import 'components/index_space.dart';
import 'components/linker.dart';
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

      final function = ImportedInstanceFunction(imported, functionName);
      imported.importedFunctions.add(function);
      functionImports[wasmImportName] = function;
    }

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

  ModuleInstanceIndex createImportInstance(ComponentBuilder builder) {
    // Note: Build all imports first, then all aliases, then all lowerings. This
    // means we can use 3 sections in total instead of 3 sections per function
    // import.
    final instances = [
      for (final import in importedInstances)
        builder.importInstance(
          import.instanceName,
          builder.addInstanceType(import.type),
        ),
    ];

    final functionAliases = [
      for (final (i, instance) in importedInstances.indexed)
        for (final function in instance.importedFunctions)
          builder.linker.alias(
            .componentFunction,
            .instanceExport(instances[i], function.function),
          ),
    ];

    final lowered = <ImportedInstanceFunction, CanonLower>{};
    var i = 0;
    for (final instance in importedInstances) {
      for (final function in instance.importedFunctions) {
        lowered[function] = builder.linker.canonLower(functionAliases[i++]);
      }
    }

    final inlineExports = <(String, Sort, Index)>[];
    for (final MapEntry(:key, :value) in functionImports.entries) {
      inlineExports.add((
        key,
        .coreFunction,
        lowered[value]!.createdCoreFunction,
      ));
    }

    return builder.linker.coreInstantiate(.inlineExports(inlineExports));
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
