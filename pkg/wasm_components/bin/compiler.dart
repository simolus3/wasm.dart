import 'dart:io';

import 'package:logging/logging.dart';
import 'package:wasm_components/src/compiler/compiler.dart';

void main() async {
  hierarchicalLoggingEnabled = true;
  final logger = Logger('compiler')..level = .ALL;
  logger.onRecord.listen(print);

  final compiler = ComponentCompiler(
    CompilerOptions(File('bin/hello_world_custom.dart'), File('out.wasm')),
    logger,
  );
  await compiler.run();
}
