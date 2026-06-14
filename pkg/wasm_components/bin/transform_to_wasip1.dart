import 'dart:io';

import 'package:wasm_components/src/compiler/subprocess.dart';
import 'package:wasm_components/src/compiler/transform.dart';
import 'package:path/path.dart' as p;

void main() async {
  final workspace = await Directory.systemTemp.createTemp('dart-wasi01');

  final dart2wasmOut = p.join(workspace.path, 'app.dart2.wasm');
  final lowered = p.join(workspace.path, 'app.lowered.wasm');

  try {
    print('Building wasi helpers');
    await compileLibc(.wasip1);

    print('Compiling main file');
    var result = await (await Process.start(Platform.executable, [
      'compile',
      'wasm',
      '--standalone',
      '-E',
      '--enable-experimental-wasm-interop',
      '--no-minify',
      '--no-strip-wasm',
      'example/hello_world.dart',
      '--output',
      dart2wasmOut,
    ], mode: .inheritStdio)).exitCode;
    if (result != 0) exit(result);

    final transformer = ModuleTransformer.fromBytes(
      File(dart2wasmOut).readAsBytesSync(),
    );
    transformer.transform({});
    File(lowered).writeAsBytesSync(transformer.serialize());
    //    File('example/lowered.wasm').writeAsBytesSync(transformer.serialize());

    print('Merging with libc');
    result = await (await Process.start('wasm-merge', [
      '--enable-gc',
      '--enable-reference-types',
      '--enable-multivalue',
      '--enable-bulk-memory',
      '--enable-exception-handling',
      '--debuginfo',
      lowered,
      'dart',
      '../../target/wasm32-wasip1/release/dart_libc_wasip1.wasm',
      'libc',
      '-o',
      'example/app.wasm',
    ], mode: .inheritStdio)).exitCode;
  } finally {
    await workspace.delete(recursive: true);
  }

  print('Generated file example/app.wasm');
  print('Run it with wasmtime -W all-proposals=yes example/app.wasm');
}
