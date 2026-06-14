import 'package:hooks/hooks.dart';
import 'package:wasm_components/hooks.dart';

void main(List<String> args) => build(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    output.assets.webAssemblyComponents.add(
      const WasmComponentAsset(
        wit: {
          // Generating this can be automated with wasm-tools wit -j
          'packages': [
            {
              'name': 'wasi:cli@0.3.0',
              'interfaces': {'run': 0},
            },
          ],
          'types': [],
          'interfaces': [
            {
              'name': 'run',
              'functions': {
                'run': {
                  'name': 'run',
                  'kind': 'freestanding',
                  'params': <Object?>[],
                  'result': 0,
                },
              },
              'package': 0,
            },
          ],
        },
        // These bits need to be defined manually currently, we need a binding
        // generator for those.
        imports: [],
        exports: [
          ExportedInstance(
            name: 'wasi:cli/run@0.3.0',
            functions: {'run': ExportedInstanceFunction(exportName: 'runCli')},
          ),
        ],
      ),
    );
  }
});
