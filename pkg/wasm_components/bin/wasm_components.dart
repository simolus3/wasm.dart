import 'package:logging/logging.dart';
import 'package:wasm_components/src/compiler/cli.dart';

void main(List<String> args) async {
  hierarchicalLoggingEnabled = true;
  final logger = Logger('compiler')..level = .ALL;
  logger.onRecord.listen(print);

  await runCli(logger, args);
}
