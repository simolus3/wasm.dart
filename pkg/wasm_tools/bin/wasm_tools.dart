import 'package:logging/logging.dart';
import 'package:wasm_tools/wasm_tools.dart';

void main(List<String> args) async {
  hierarchicalLoggingEnabled = true;
  final logger = Logger('compiler')..level = .ALL;
  logger.onRecord.listen(print);

  await runCli(logger, args);
}
