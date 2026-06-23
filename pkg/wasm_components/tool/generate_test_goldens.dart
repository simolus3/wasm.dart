import 'dart:io';

import 'package:path/path.dart' as p;

void main() async {
  await for (final file in Directory('test/cases').list()) {
    if (file is! File || p.extension(file.path) != '.dart') continue;

    final golden = p.setExtension(file.path, '.golden.txt');
    final output = await Process.run(Platform.executable, [file.path]);
    if (output.exitCode != 0) {
      throw 'Unexpected result on ${file.path}: ${output.stderr}';
    }

    await File(golden).writeAsString(output.stdout as String);
  }
}
