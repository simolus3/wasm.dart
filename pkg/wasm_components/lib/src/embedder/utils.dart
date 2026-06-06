// ignore: import_internal_library
import 'dart:_wasm';

extension ExternalizeObject on Object {
  WasmExternRef externalize() =>
      ExternalizeNonNullable(WasmAnyRef.fromObject(this)).externalize();
}

// TODO: Investigate why native copy and clone fail with "has packed type i16.
//Use array.get_s or array.get_u instead." errors.

extension I8ArrayUtils on WasmArray<WasmI8> {
  WasmArray<WasmI8> cloneTyped() {
    final result = WasmArray<WasmI8>(length);
    result.copyTyped(0, this, 0, length);
    return result;
  }

  void copyTyped(
    int offset,
    WasmArray<WasmI8> source,
    int sourceOffset,
    int size,
  ) {
    for (var i = 0; i < size; i++) {
      write(offset + i, source.readUnsigned(sourceOffset + i));
    }
  }
}

extension I16ArrayUtils on WasmArray<WasmI16> {
  WasmArray<WasmI16> cloneTyped() {
    final result = WasmArray<WasmI16>(length);
    result.copyTyped(0, this, 0, length);
    return result;
  }

  void copyTyped(
    int offset,
    WasmArray<WasmI16> source,
    int sourceOffset,
    int size,
  ) {
    for (var i = 0; i < size; i++) {
      write(offset + i, source.readUnsigned(sourceOffset + i));
    }
  }
}
