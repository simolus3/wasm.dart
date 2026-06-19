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
            {
              'name': 'dart:components@0.0.1',
              'interfaces': {'print': 1},
            },
          ],
          'types': [
            {
              'name': null,
              'kind': {
                'result': {'ok': null, 'err': null},
              },
            },
            {'name': null, 'kind': 'string'},
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
              'name': 'print',
              'functions': {
                'print': {
                  'name': 'print',
                  'kind': 'freestanding',
                  'params': <Object?>[
                    {'name': 'line', 'type': 1},
                  ],
                },
              },
              'package': 1,
            },
          ],
        },
        // These bits need to be defined manually currently, we need a binding
        // generator for those.
        imports: [
          ImportedComponentFunction(
            importName: r'Print$print',
            interfaceIndex: 1,
            functionName: 'print',
            functionOptions: FunctionOptions(
              useMemory: true,
              stringEncoding: .utf16,
            ),
          ),
        ],
        exports: [
          ExportedInstance(
            name: 'wasi:cli/run@0.2.12',
            interfaceIndex: 0,
            functions: {
              'run': ExportedInstanceFunction(exportName: r'cli$run'),
            },
          ),
        ],
      ),
    );
  }
});
