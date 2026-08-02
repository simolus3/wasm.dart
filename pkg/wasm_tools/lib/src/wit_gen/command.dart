import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';

import '../failure.dart';
import 'generate.dart';

final class GenerateWitInteropCommand extends Command<void> {
  final Logger logger;

  GenerateWitInteropCommand(this.logger) {
    argParser.addOption(
      'input',
      abbr: 'i',
      help: 'Input file or directory containing WIT definitions.',
      mandatory: true,
    );
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output file for main sources.',
      defaultsTo: 'lib/src/components',
    );

    argParser.addOption(
      'world',
      abbr: 'w',
      help: 'The main world to generate in case multiple worlds are defined.',
    );
  }

  @override
  String get description =>
      'Generate interop code based on Wasm Interface Type (WIT) definitions.';

  @override
  String get name => 'witgen';

  @override
  Future<void> run() async {
    final results = argResults!;
    final input = results.option('input')!;
    final type = await FileSystemEntity.type(input, followLinks: true);
    final inputs = <WitInputFile>[];

    switch (type) {
      case FileSystemEntityType.file:
        inputs.add(WitInputFile(input, isMain: true));
      case FileSystemEntityType.directory:
        inputs.add(WitInputFile(input, isMain: true, isDirectory: true));
      default:
        throw ToolFailure('Input file $input does not exist');
    }

    final generated = await witBindgen(
      GenerateDartOptions(
        files: inputs,
        runs: [GenerationRun(results.option('world'))],
      ),
    );

    final formatter = DartFormatter(
      // TODO: Read config from project?
      languageVersion: DartFormatter.latestLanguageVersion,
    );
    final outputDirectory = Directory(results.option('output')!);

    if (await outputDirectory.exists()) {
      await outputDirectory.delete(recursive: true);
    }
    await outputDirectory.create();

    for (final file in generated) {
      switch (file) {
        case AbiJsonFile(:final contents):
          final hookDirectory = Directory('hook');
          if (!await hookDirectory.exists()) {
            await hookDirectory.create();
          }
          final file = File('hook/wasm_abi.json');
          await file.writeAsString(
            JsonEncoder.withIndent('  ').convert(jsonDecode(contents)),
          );
          logger.fine('Wrote abi to ${file.path}.');
        case GeneratedDartFile(:final name, :var contents):
          try {
            contents = formatter.format(contents);
          } on FormatterException catch (e, s) {
            logger.warning('Could not format Dart sources', e, s);
          }

          final file = File.fromUri(outputDirectory.uri.resolve(name));
          await file.writeAsString(contents);
          logger.fine('Wrote component to ${file.path}.');
      }
    }

    logger.info('Wrote outputs');
  }
}
