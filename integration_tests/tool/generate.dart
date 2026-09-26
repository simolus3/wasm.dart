import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:wasm_tools/src/wit_gen/generate.dart';
import 'package:dart_style/dart_style.dart';

void main() async {
  final src = Directory('lib/src');
  final testcases = await src.list().toList();

  await testcases.whereType<Directory>().map((dir) async {
    try {
      await _generate(dir);
    } catch (e, s) {
      Error.throwWithStackTrace(_CouldNotGenerateException(dir, e), s);
    }
  }).wait;
}

Future<void> _generate(Directory root) async {
  final options = GenerateDartOptions(
    files: [
      WitInputFile(root.uri.resolve('world.wit').toFilePath(), isMain: true),
    ],
    runs: [.new('root')],
  );

  final generated = await witBindgen(options);

  final outputDirectory = Directory.fromUri(root.uri.resolve('generated/'));
  final formatter = DartFormatter(languageVersion: Version(3, 14, 0));

  if (await outputDirectory.exists()) {
    await outputDirectory.delete(recursive: true);
  }
  await outputDirectory.create();

  for (final generatedFile in generated) {
    var contents = generatedFile.contents;

    if (generatedFile.isDartFile) {
      final file = File.fromUri(
        outputDirectory.uri.resolve(generatedFile.name),
      );
      await file.writeAsString(formatter.format(contents));
    } else {
      final file = File.fromUri(outputDirectory.uri.resolve('abi.json'));
      await file.writeAsString(
        JsonEncoder.withIndent('  ').convert(jsonDecode(contents)),
      );
    }
  }
}

final class _CouldNotGenerateException(final Directory root, final Object cause)
    implements Exception {
  @override
  String toString() {
    return 'Could not generate in ${root.path}: $cause';
  }
}
