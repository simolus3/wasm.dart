import 'dart:io';

import 'package:wasm_components/src/compiler/components/component.dart';
import 'package:wasm_components/src/compiler/subprocess.dart';
import 'package:wasm_components/src/compiler/transform.dart';
import 'package:path/path.dart' as p;

void main() async {
  final workspace = await Directory.systemTemp.createTemp('dart-wasm-cm');

  final dart2wasmOut = p.join(workspace.path, 'app.dart2.wasm');

  try {
    print('Building wasi helpers');
    await compileLibc(.standalone);

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

    /*
    We want to generate a component like the following

    (component
      (type $result (result))
      (type $exit-type (func (param "status" $result)))
      (type $main (func (result $result)))

      (type $type-cli-exit-import (instance
        (export "exit" (func (type $exit-type)))
      ))
      (import "wasi:cli/exit@0.2.12" (instance $instance-cli-exit-import (type $type-cli-exit-import)))
      ... repeat for other import

      (core module $libc ...)
      (core instance $libc (instantiate $libc))

      (core module $app
        (func $free (import "libc" "dart_free") ...)
        (func $exit (import "runtime" "exit") (param i32))
        ... compiled dart2wasm code
      )

      (alias export $instance-cli-exit-import "exit" (func $exit))
      (canon lower (func $exit) (core func $exit))
      (core instance $host-imports
        (export "exit" (func $exit))
        ... additional lowered imports as exports here
      )
      (core instance $app (instantiate $app
        (with "libc" (instance $libc))
        (with "runtime" (instance "runtime"))
      ))

      (component $exports
        (import "run" (func (type $main)))
        (export "run" (func 0) (func (type $main)))
      )

      (canon lift (core func $app "invokeMain") (func $run (type $main)))
      (instance $exportedInstance (instantiate $exports
        (with "run" (func $run))
      ))
      (export "wasi:cli/run@0.2.12" (instance $exportedInstance))
    )
    */

    final component = ComponentBuilder();
    component.defineModule(transformer.module);
    component.defineModuleFromBytes(
      await File(
        '../../target/wasm32-unknown-unknown/release/dart_libc_standalone.wasm',
      ).readAsBytes(),
    );

    File('example/app.wasm').writeAsBytes(component.serializeToBytes());
  } finally {
    await workspace.delete(recursive: true);
  }
}
