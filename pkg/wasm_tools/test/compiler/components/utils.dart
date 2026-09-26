import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:wasm_tools/src/compiler/components/component.dart';

Future<String> componentToWat(ComponentBuilder builder) async {
  final bytes = builder.serializeToBytes();

  await validateComponent(.value(bytes));

  final (exitCode, stdout, stderr) = await _runWasmTool([
    'print',
  ], .value(bytes));
  if (exitCode != 0) {
    throw ArgumentError('Could not print to WAT: $stderr');
  }

  return stdout;
}

Future<void> validateComponent(Stream<Uint8List> component) async {
  final (exitCode, _, stderr) = await _runWasmTool([
    'validate',
    '--features',
    'all',
  ], component);
  if (exitCode != 0) {
    throw ArgumentError('wasm-tools validate failed: $stderr');
  }
}

Future<(int, String, String)> _runWasmTool(
  List<String> args,
  Stream<Uint8List> stdin,
) async {
  final toWat = await Process.start('wasm-tools', args);
  final stdoutFuture = utf8.decodeStream(toWat.stdout);
  final stderrFuture = utf8.decodeStream(toWat.stderr);

  stdin.cast<List<int>>().pipe(toWat.stdin);
  return await (toWat.exitCode, stdoutFuture, stderrFuture).wait;
}
