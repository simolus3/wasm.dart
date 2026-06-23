import 'dart:io';

import 'package:test/test.dart';
import 'package:path/path.dart' as p;
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() async {
  late String testRunnerExecutable;

  setUpAll(() async {
    final cargoBuild = await Process.start('cargo', [
      'build',
      '-p',
      'test_runner',
    ], mode: .inheritStdio);
    final exitCode = await cargoBuild.exitCode;
    if (exitCode != 0) throw 'Unexpected exit code from cargo: $exitCode';

    final exeSuffix = Platform.isWindows ? '.exe' : '';
    testRunnerExecutable = p.normalize(
      '../../target/debug/test_runner$exeSuffix',
    );
  });

  await for (final file in Directory('test/cases').list()) {
    if (file is! File || p.extension(file.path) != '.dart') continue;

    test(p.basenameWithoutExtension(file.path), () async {
      final wasmFile = d.path('test.wasm');
      final result = await Process.run(Platform.executable, [
        'run',
        'wasm_tools',
        'compile',
        file.path,
        '--output',
        wasmFile,
        '--hooks-include-dev-dependencies',
      ]);

      if (result.exitCode != 0) {
        throw 'Could not compile: ${result.stdout} ${result.stderr}';
      }

      final output = await Process.run(testRunnerExecutable, [wasmFile]);
      if (output.exitCode != 0) {
        throw 'Could not run test runner: ${output.exitCode}: ${output.stdout} ${output.stderr}';
      }

      final golden = await File(
        p.setExtension(file.path, '.golden.txt'),
      ).readAsString();
      expect(output.stdout, golden);
    });
  }
}
