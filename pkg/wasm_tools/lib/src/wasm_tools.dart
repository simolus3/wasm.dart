import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';

import 'compiler/command.dart';
import 'wit_gen/command.dart';

Future<void> runCli(Logger logger, List<String> args) async {
  final runner =
      CommandRunner<void>(
          'wasm_components',
          'Tools to interop between Dart and WebAssembly components.',
        )
        ..addCommand(GenerateWitInteropCommand(logger))
        ..addCommand(CompileCommand(logger));
  runner.run(args);
}
