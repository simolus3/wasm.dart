import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:wasm_tools/hooks.dart';

void main(List<String> args) => link(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    final [entrypoint] =
        ((((input.config.json['extensions'] as _JsonObject)['hooks_runner']
                        as _JsonObject)['record_use']
                    as _JsonObject)['entry_points']
                as List)
            .cast<String>();

    final abi = Uri.parse(entrypoint).resolve('./generated/abi.json');
    if (!await File.fromUri(abi).exists()) return;

    output.dependencies.add(abi);
    output.assets.webAssemblyComponents.add(
      WasmComponentAsset(
        encoded:
            json.decode(File.fromUri(abi).readAsStringSync()) as _JsonObject,
      ),
    );
  }
});

typedef _JsonObject = Map<String, Object?>;
