// ignore: import_internal_library
import 'dart:_wasm';

import 'libc.dart';
import 'string.dart';

void printImpl(WasmStringImplementation string) {
  switch (string) {
    case Latin1String():
      final codeUnits = string.codeUnits;

      final length = codeUnits.length;
      final bufferLength = WasmI32.fromInt(length);
      final ptr = dartMalloc(bufferLength);
      final dartPtr = ptr.toIntUnsigned();

      for (var i = 0; i < length; i++) {
        memory.storeInt8(
          dartPtr + i,
          WasmI32.fromInt(codeUnits.readUnsigned(i)),
        );
      }
      dartWriteln(bufferLength, ptr);
      dartFree(ptr, bufferLength);
    case Utf16String():
      dartWriteln(const WasmI32(0), const WasmI32(3));

      // We would have to encode this
      throw UnimplementedError();
  }
}
