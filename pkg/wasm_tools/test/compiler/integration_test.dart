import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:wasm_tools/src/compiler/compiler.dart';

void main() {
  test('can compile and run custom hello world example', () async {
    final logger = Logger('integration_test');
    final currentDir = Directory.current.path;
    final examplesDir = p.join(currentDir, '../../examples/hello_world_custom');

    final appDart = File(p.join(examplesDir, 'bin/app.dart'));
    final appWasm = File(p.join(examplesDir, 'bin/app.wasm'));

    // Compile the app
    final compiler = ComponentCompiler(
      CompilerOptions(appDart, appWasm),
      logger,
    );
    await compiler.run();

    expect(await appWasm.exists(), isTrue);

    // Run the compiled app with Cargo host runner
    final process = await Process.run('cargo', [
      'run',
    ], workingDirectory: examplesDir);

    expect(process.exitCode, equals(0));
    expect(process.stdout, contains('Hello world!'));
    expect(process.stdout, contains('Invocation result: [Result(Ok(None))]'));
  });
}
