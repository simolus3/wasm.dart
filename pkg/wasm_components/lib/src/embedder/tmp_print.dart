// ignore: import_internal_library
import 'dart:_wasm';

import 'libc.dart';
import 'string.dart';

void printImpl(WasmStringImplementation string) {
  switch (string) {
    case Latin1String(:final codeUnits):
      final length = codeUnits.length;
      final bufferLength = WasmI32.fromInt(length + 1);
      final ptr = dartMalloc(bufferLength);
      final dartPtr = ptr.toIntUnsigned();

      for (var i = 0; i < length; i++) {
        memory.storeInt8(
          dartPtr + i,
          WasmI32.fromInt(codeUnits.readUnsigned(i)),
        );
      }
      memory.storeInt8(dartPtr + length, const WasmI32(10)); // Add newline
      stdoutWrite(bufferLength, ptr);
      dartFree(ptr, bufferLength);
      stdoutFlush();
    case Utf16String():
      // We would have to encode this
      throw UnimplementedError();
  }
}
