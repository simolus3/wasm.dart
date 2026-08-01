import '../components/index_space.dart';
import 'export.dart';
import 'imported_function.dart';
import 'interface.dart';
import 'linker.dart';

final class ProgramAbi {
  /// Interfaces, indexed by their [AbiInterface.fullName].
  final Map<String, AbiInterface> interfaces = {};

  final List<ImportedFunction> imports = [];
  final List<ExportedInterface> exports = [];

  CoreInstanceIndex createImportInstance(Linker linker) {
    final inlineExports = <(String, Sort, Index)>[];
    for (final import in imports) {
      if (!import.existsInProgram) {
        linker.logger.fine(
          'Skipping ${import.importName} import, removed by Dart DCE.',
        );
      }

      final functionIndex = import.resolve(linker);

      inlineExports.add((import.importName, .coreFunction, functionIndex));
    }

    return linker.component.coreInstantiate(.inlineExports(inlineExports));
  }

  Iterable<ExportedFunction> get exportedFunctions =>
      exports.expand((e) => e.functions.values);
}
