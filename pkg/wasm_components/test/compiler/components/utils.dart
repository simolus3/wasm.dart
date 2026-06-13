import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:wasm_components/src/compiler/components/component.dart';
import 'package:wasm_components/src/third_party/wasm_builder/wasm_builder.dart';

Future<String> componentToWat(ComponentBuilder builder) async {
  final serializer = Serializer();
  builder.serialize(serializer);

  {
    final (exitCode, _, stderr) = await _runWasmTool(
      'validate',
      serializer.data,
    );
    if (exitCode != 0) {
      throw ArgumentError('wasm-tools validate failed: $stderr');
    }
  }

  final (exitCode, stdout, stderr) = await _runWasmTool(
    'print',
    serializer.data,
  );
  if (exitCode != 0) {
    throw ArgumentError('Could not print to WAT: $stderr');
  }

  return stdout;
}

Future<(int, String, String)> _runWasmTool(
  String subcommand,
  Uint8List stdin,
) async {
  final toWat = await Process.start('wasm-tools', [subcommand]);
  final stdoutFuture = utf8.decodeStream(toWat.stdout);
  final stderrFuture = utf8.decodeStream(toWat.stderr);

  toWat.stdin.add(stdin);
  toWat.stdin.close();
  return await (toWat.exitCode, stdoutFuture, stderrFuture).wait;
}
