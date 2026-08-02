// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'dart:typed_data' as i1;

abstract interface class Types {}

enum ErrorCode {
  /// Input/output error
  io,

  /// Invalid or incomplete multibyte or wide character
  illegalByteSequence,

  /// Broken pipe
  pipe,
}

abstract interface class Stdout {
  Future<i0.Result<void, ErrorCode>> writeViaStream({
    required Stream<i1.Uint8List> data,
  });
}

abstract interface class Run {
  Future<i0.Result<void, void>> run();
}
