import 'dart:io';

Stream<File> get compiledIntegrationTestComponents async* {
  const help = 'Run tool/compile.dart in integration_tests/';
  final dir = Directory('../../integration_tests/build');

  if (!await dir.exists()) {
    throw Exception('${dir.path} does not exist. $help');
  }

  var foundFile = false;
  await for (final file in dir.list()) {
    if (file.path.endsWith('.wasm')) {
      foundFile = true;
      yield file as File;
    }
  }

  if (!foundFile) {
    throw Exception('${dir.path} is empty. $help');
  }
}
