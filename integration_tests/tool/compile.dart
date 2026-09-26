import 'dart:io';

import 'package:logging/logging.dart';
import 'package:wasm_tools/src/wasm_tools.dart';

void main(List<String> args) async {
  hierarchicalLoggingEnabled = true;
  final root = Logger.root..level = .ALL;
  root.onRecord.listen(print);

  bool shouldCompile(String demo) {
    return args.isEmpty || args.any((included) => demo.contains(included));
  }

  final src = Directory('lib/src');
  final output = Directory('build');
  if (!await output.exists()) {
    await output.create();
  }

  await for (final input in src.list()) {
    if (input is! Directory) continue;

    final segments = input.uri.pathSegments;
    final dirname = segments[segments.length - 2];
    if (!shouldCompile(dirname)) continue;

    final logger = Logger(dirname);
    await runCli(logger, [
      'compile',
      input.uri.resolve('main.dart').toFilePath(),
      '-o',
      output.uri.resolve('$dirname.wasm').toFilePath(),
    ]);
  }
}
