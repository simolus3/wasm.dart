import 'dart:convert';
import 'dart:isolate';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'native.dart';

final class GenerateDartOptions {
  final List<WitInputFile> files;
  final List<GenerationRun> runs;

  GenerateDartOptions({required this.files, required this.runs});

  Map<String, Object?> toJson() {
    return {
      'files': [for (final file in files) file.toJson()],
      'runs': [for (final run in runs) run.toJson()],
    };
  }
}

final class GenerationRun {
  /// The main world for which to generate code.
  final String? main;

  GenerationRun(this.main);

  Map<String, Object?> toJson() {
    return {'main': main};
  }
}

final class WitInputFile {
  final String path;
  final bool isMain;
  final bool isDirectory;

  WitInputFile(this.path, {this.isMain = false, this.isDirectory = false});

  Map<String, Object?> toJson() {
    return {'path': path, 'is_main': isMain, 'is_directory': isDirectory};
  }
}

sealed class GeneratedFile {
  final String contents;

  GeneratedFile(this.contents);

  factory GeneratedFile.fromJson(Map<String, Object?> json) {
    final contents = json['contents'] as String;
    final kind = json['kind'];

    if (kind == 'AbiJson') {
      return AbiJsonFile(contents);
    } else {
      final package = (kind as Map<String, Object?>)['Dart'] as String;
      return GeneratedDartFile(package, contents);
    }
  }
}

final class AbiJsonFile extends GeneratedFile {
  AbiJsonFile(super.contents);
}

final class GeneratedDartFile extends GeneratedFile {
  final String name;
  GeneratedDartFile(this.name, super.contents);
}

final class WitGenerateException implements Exception {
  final String message;

  WitGenerateException(this.message);

  @override
  String toString() {
    return message;
  }
}

Future<List<GeneratedFile>> witBindgen(GenerateDartOptions options) {
  return Isolate.run(() {
    return _witBindgenSync(options);
  });
}

List<GeneratedFile> _witBindgenSync(GenerateDartOptions options) {
  return using((alloc) {
    final result = alloc<RawExportResult>();
    final encoded = JsonUtf8Encoder().convert(options) as Uint8List;

    wit_bindgen_dart_gen(encoded.length, encoded.address, result);
    final resultRef = result.ref;
    final content = json.decode(
      _readString(resultRef.start, resultRef.length),
    ) as Map<String, Object?>;

    if (content['Ok'] case final generated?) {
      return [
        for (final entry in (generated as List).cast<Map<String, Object?>>())
          GeneratedFile.fromJson(entry),
      ];
    }

    throw WitGenerateException(content['Err'] as String);
  });
}

String _readString(Pointer<Uint8> data, int length) {
  return utf8.decode(data.asTypedList(length));
}
