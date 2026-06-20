import 'dart:convert';
import 'dart:isolate';
import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'native.dart';

final class WitInputFile {
  final String path;
  final String contents;
  final bool isMain;

  WitInputFile(this.path, this.contents, {this.isMain = false});
}

final class WitExportResult {
  /// Unformatted generated Dart code to write to `lib/src/wasm_component.g.dart`.
  final String dartCode;

  /// A JSON encoding of the package's component ABI, to include in a build
  /// hook.
  final String abi;

  WitExportResult(this.dartCode, this.abi);
}

final class WitGenerateException implements Exception {
  final String message;

  WitGenerateException(this.message);

  @override
  String toString() {
    return message;
  }
}

Future<WitExportResult> witBindgen(
  List<WitInputFile> files,
  String? mainWorld,
) {
  return Isolate.run(() {
    return _witBindgenSync(files, mainWorld);
  });
}

WitExportResult _witBindgenSync(List<WitInputFile> files, String? mainWorld) {
  return using((alloc) {
    final options = alloc<GenerateDartOptions>();
    final result = alloc<ExportResult>();
    final rawFiles = alloc<ImportFile>(files.length);

    options.ref
      ..files = rawFiles
      ..fileCount = files.length;
    if (mainWorld != null) {
      final (ptr, length) = alloc.allocateString(mainWorld);
      options.ref
        ..main = ptr
        ..mainLength = length;
    } else {
      options.ref
        ..main = nullptr
        ..mainLength = 0;
    }

    for (final (i, inputFile) in files.indexed) {
      final (pathPtr, pathLength) = alloc.allocateString(inputFile.path);
      final (contentPtr, contentLength) = alloc.allocateString(
        inputFile.contents,
      );

      rawFiles[i]
        ..isMain = inputFile.isMain ? 1 : 0
        ..contents = contentPtr
        ..contentsLength = contentLength
        ..path = pathPtr
        ..pathLength = pathLength;
    }

    wit_bindgen_dart_gen(options, result);
    final resultRef = result.ref;
    final content = _readString(resultRef.output, resultRef.outputLength);

    if (resultRef.isError != 0) {
      wit_bindgen_dart_free(result);
      throw WitGenerateException(content);
    }

    final exports = WitExportResult(
      content,
      _readString(resultRef.abi, resultRef.abiLength),
    );
    wit_bindgen_dart_free(result);
    return exports;
  });
}

extension on Allocator {
  (Pointer<Uint8>, int) allocateString(String str) {
    final encoded = utf8.encode(str);
    final ptr = this<Uint8>(encoded.length);
    ptr.asTypedList(encoded.length).setAll(0, encoded);
    return (ptr, encoded.length);
  }
}

String _readString(Pointer<Uint8> data, int length) {
  return utf8.decode(data.asTypedList(length));
}
