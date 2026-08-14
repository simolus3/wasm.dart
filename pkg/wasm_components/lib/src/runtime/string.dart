// ignore: import_internal_library
import 'dart:_wasm';
import 'dart:typed_data';

import '../embedder/libc.dart';

/// A string stored in linear memory.
final class AllocatedString {
  final WasmI32 ptr;
  final WasmI32 packedLength;

  AllocatedString(this.ptr, this.packedLength);

  void free() {
    dartFree(ptr, (2 * packedLength.toIntSigned()).toWasmI32(), _alignment);
  }

  static AllocatedString allocateUtf16(String dartString) {
    final length = dartString.length;
    final ptr = mallocAligned(_alignment, (2 * length).toWasmI32());
    final dartPtr = ptr.toIntSigned();
    final packedLength = length.toWasmI32();

    for (var i = 0; i < length; i++) {
      memory.storeInt16(
        dartPtr + 2 * i,
        WasmI32.int16FromInt(dartString.codeUnitAt(i)),
        align: 1,
      );
    }

    return AllocatedString(ptr, packedLength);
  }

  static String read(WasmI32 ptr, WasmI32 packedLength) {
    final length = packedLength.toIntUnsigned();
    final dartPtr = ptr.toIntUnsigned();
    final array = Uint16List(length);

    for (var i = 0; i < length; i++) {
      array[i] = memory.loadInt16(dartPtr + 2 * i, align: 1).toIntUnsigned();
    }

    AllocatedString(ptr, packedLength).free();
    return String.fromCharCodes(array);
  }

  static const _alignment = WasmI32(2);
}

/// A `char` value in the WebAssembly component model.
extension type const CharCode(int value) implements int {}
