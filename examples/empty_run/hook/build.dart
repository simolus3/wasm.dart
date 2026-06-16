import 'package:hooks/hooks.dart';
import 'package:wasm_components/hooks.dart';

void main(List<String> args) => build(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    output.assets.webAssemblyComponents.add(
      const WasmComponentAsset(
        wit: {
          // Generating this can be automated with wasm-tools wit -j <file.wit>
          'packages': [
            {
              'name': 'wasi:cli@0.2.12',
              'interfaces': {'run': 0},
            },
          ],
          'types': [
            {
              'name': null,
              'kind': {
                'result': {'ok': null, 'err': null},
              },
            },
          ],
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
            {
              'name': 'exit',
              'functions': {
                'exit': {
                  'name': 'exit',
                  'kind': 'freestanding',
                  'params': <Object?>[
                    {'name': 'status', 'type': 0},
                  ],
                },
              },
              'package': 0,
            },
          ],
        },
        // These bits need to be defined manually currently, we need a binding
        // generator for those.
        imports: [
          ImportedComponentFunction(
            importName: 'myExitImport',
            interfaceIndex: 1,
            functionName: 'exit',
          ),
        ],
        exports: [
          ExportedInstance(
            name: 'wasi:cli/run@0.2.12',
            interfaceIndex: 0,
            functions: {'run': ExportedInstanceFunction(exportName: 'runCli')},
          ),
        ],
      ),
    );
  }
});
