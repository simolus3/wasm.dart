import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:wasm_tools/hooks.dart';

void main(List<String> args) => link(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    output.dependencies.add(Uri.parse('hook/wasm_abi.json'));

    final uses = input.recordedUses!;
    final usedWorlds = <String>{};

    for (final MapEntry(key: def, value: calls) in uses.calls.entries) {
      if (calls.isEmpty) continue;

      if (def.name == 'commandComponent' &&
          def.library.uri ==
              'package:wasi/src/components/wasi_cli_command.dart') {
        usedWorlds.add('lib/src/components/wasi_cli_command.json');
      }
      if (def.name == 'serviceComponent' &&
          def.library.uri ==
              'package:wasi/src/components/wasi_http_service.dart') {
        usedWorlds.add('lib/src/components/wasi_http_service.json');
      }
    }

    for (final used in usedWorlds) {
      output.assets.webAssemblyComponents.add(
        WasmComponentAsset(
          encoded: json.decode(
            File(used).readAsStringSync(),
          ) as Map<String, Object?>,
        ),
      );
    }
  }
});
