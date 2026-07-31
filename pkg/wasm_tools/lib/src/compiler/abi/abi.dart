import 'imported_function.dart';
import 'interface.dart';

final class ProgramAbi {
  /// Interfaces, indexed by their [AbiInterface.fullName].
  final Map<String, AbiInterface> interfaces = {};

  final List<ImportedFunction> imports = [];
}
