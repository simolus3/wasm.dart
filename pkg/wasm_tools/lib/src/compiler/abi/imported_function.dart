import '../components/component.dart';
import '../components/index_space.dart';
import 'canonical_options.dart';
import 'interface.dart';
import 'linker.dart';

typedef FunctionDefinition = CoreFunctionIndex Function(
  Linker linker,
  CanonicalOptions options,
);

final class ImportedFunction {
  final String importName;
  final CanonicalOptions lowerOptions;
  final FunctionDefinition _resolve;

  /// Whether this function import exists in the compiled core WebAssembly
  /// module.
  ///
  /// It's possible for functions declared in the program abi to not be used
  /// (e.g. due to dead code elimination in dart2wasm).
  var existsInProgram = false;

  ImportedFunction({
    required this.importName,
    required this.lowerOptions,
    required this._resolve,
  });

  ImportedFunction.exists({
    required this.importName,
    required this.lowerOptions,
    required this._resolve,
  }) {
    existsInProgram = true;
  }

  CoreFunctionIndex resolve(Linker linker) {
    lowerOptions.requireDefinitions(linker);

    return _resolve(linker, lowerOptions);
  }

  static FunctionDefinition importedFromInstance(
    AbiInterface interface,
    String functionName,
  ) {
    return (linker, options) {
      final instace = linker.importInstance(interface);
      final function = linker.component.alias(
        .componentFunction,
        .instanceExport(instace, functionName),
      );
      final coreFunction = linker.component.canonLower(function);
      options.applyTo(linker, coreFunction);
      return coreFunction.createdCoreFunction;
    };
  }
}
