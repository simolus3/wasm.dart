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

    argParser.addMultiOption(
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

    final worlds = results.multiOption('world');

    final generated = await witBindgen(
      GenerateDartOptions(
        files: inputs,
        runs: worlds.isEmpty
            ? [GenerationRun(null)]
            : [for (final world in worlds) GenerationRun(world)],
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

    for (final generatedFile in generated) {
      var contents = generatedFile.contents;
      final file = File.fromUri(
        outputDirectory.uri.resolve(generatedFile.name),
      );

      if (generatedFile.isDartFile) {
        try {
          contents = formatter.format(contents);
        } on FormatterException catch (e, s) {
          logger.warning('Could not format Dart sources', e, s);
        }

        await file.writeAsString(contents);
        logger.fine('Wrote component to ${file.path}.');
      } else {
        await file.writeAsString(
          JsonEncoder.withIndent('  ').convert(jsonDecode(contents)),
        );
        logger.fine('Wrote abi to ${file.path}.');
      }
    }

    logger.info('Wrote outputs');
  }
}
