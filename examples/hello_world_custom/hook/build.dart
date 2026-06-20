import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:wasm_tools/hooks.dart';

void main(List<String> args) => build(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    output.dependencies.add(Uri.parse('hook/wasm_abi.json'));

    output.assets.webAssemblyComponents.add(
      WasmComponentAsset(
        encoded:
            json.decode(File('hook/wasm_abi.json').readAsStringSync())
                as Map<String, Object?>,
      ),
    );
  }
});
