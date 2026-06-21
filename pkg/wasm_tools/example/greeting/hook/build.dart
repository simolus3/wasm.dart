import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:wasm_tools/hooks.dart';

void main(List<String> args) => build(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    final abi = input.packageRoot.resolve('hook/wasm_abi.json');

    output.dependencies.add(abi);
    output.assets.webAssemblyComponents.add(
      WasmComponentAsset(
        encoded: json.decode(
          File(abi.toFilePath()).readAsStringSync(),
        ) as Map<String, Object?>,
      ),
    );
  }
});
