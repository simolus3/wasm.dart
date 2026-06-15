import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'compiler.dart';

Future<void> runCli(Logger logger, List<String> args) async {
  final runner = CommandRunner<void>(
    'wasm_components',
    'Tools to interop between Dart and WebAssembly components.',
  )..addCommand(CompileCommand(logger));
  runner.run(args);
}

final class CompileCommand extends Command<void> {
  final Logger _logger;

  CompileCommand(this._logger) {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output file, uses input.wasm by default',
    );
  }

  @override
  String get description => 'Compile a Dart app as a WebAssembly components';

  @override
  String get name => 'compile';

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final file = File(switch (argResults.rest) {
      [final path] => path,
      _ => throw CompilerFailure('Expected a file to compile'),
    });
    final output = File(switch (argResults.option('output')) {
      null => p.setExtension(file.path, '.wasm'),
      final path => path,
    });

    final compiler = ComponentCompiler(CompilerOptions(file, output), _logger);
    await compiler.run();
  }
}
