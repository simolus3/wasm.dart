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

  new({
    required this.importName,
    required this.lowerOptions,
    required this._resolve,
  });

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
