import '../components/component.dart';
import '../components/index_space.dart';
import '../components/type.dart';
import 'canonical_options.dart';
import 'interface.dart';
import 'linker.dart';

final class ExportedInterface {
  /// The interface implemented by the component.
  final AbiInterface interface;

  /// Map from interface method names to exported functions.
  final Map<String, ExportedFunction> functions;

  new({required this.interface, required this.functions});

  ComponentInstanceIndex instantiate(Linker linker) {
    final inlineExports = <(String, Sort, Index)>[];
    for (final MapEntry(:key, :value) in functions.entries) {
      inlineExports.add((key, .componentFunction, value.lift(linker)));
    }

    return linker.component.instance(inlineExports: inlineExports);
  }
}

final class ExportedFunction {
  /// The core WebAssembly export name of the function.
  final String name;

  /// Options to lift the exported function into a component model function.
  final CanonicalOptions options;
  final AbiFunction function;

  new({required this.name, required this.options, required this.function});

  ComponentFunctionIndex lift(Linker linker) {
    options.requireDefinitions(linker);

    final core = linker.programExport(name);
    final lifted = linker.component.canonLift(
      core,
      linker.component.addType(
        FunctionType(
          async: function.async,
          parameters: [
            for (final (name, type) in function.parameters)
              .new(label: name, type: linker.mapType(type)),
          ],
          result: switch (function.result) {
            null => null,
            final result => linker.mapType(result),
          },
        ),
      ),
    );
    options.applyTo(linker, lifted);
    return lifted.createdFunction;
  }
}
