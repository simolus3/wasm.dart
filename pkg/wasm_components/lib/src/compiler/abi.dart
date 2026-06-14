import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';

import 'components/type.dart';

/// Information about all component imports and exports used in the Dart
/// program being compiled.
///
/// We collect this information through build hooks.
final class DartProgramAbi {
  final List<ImportedComponentInstance> importedInstances = [];
  final List<ExportedComponentInstance> exportedInstances = [];

  final Map<String, ImportedInstanceFunction> functionImports = {};
  final Map<String, ExportedInstanceFunction> functionExports = {};

  void includeAsset(Logger logger, EncodedAsset asset) {}
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
  final String exportName;
  final FunctionType type;

  ExportedInstanceFunction(this.exportName, this.type);
}
