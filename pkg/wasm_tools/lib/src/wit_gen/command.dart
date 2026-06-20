import 'dart:async';
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
      defaultsTo: 'lib/src/component.g.dart',
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
        logger.fine('Reading $input');
        inputs.add(
          WitInputFile(input, await File(input).readAsString(), isMain: true),
        );
      case FileSystemEntityType.directory:
        throw 'TODO: Input directory';
      default:
        throw ToolFailure('Input file $input does not exist');
    }

    var WitExportResult(:dartCode, :abi) = await witBindgen(
      inputs,
      results.option('world'),
    );

    try {
      final formatter = DartFormatter(
        // TODO: Read config from project?
        languageVersion: DartFormatter.latestLanguageVersion,
      );

      dartCode = formatter.format(dartCode);
    } on FormatterException catch (e, s) {
      logger.warning('Could not format Dart sources', e, s);
    }

    final outputFile = File(results.option('output')!);
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsString(dartCode);

    logger.info('Wrote outputs to ${outputFile.path}');
  }
}
