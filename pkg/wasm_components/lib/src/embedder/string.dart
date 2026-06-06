// ignore: import_internal_library
import 'dart:_wasm';

/// The string implementation used when compiling Dart to WebAssembly
/// components.
sealed class WasmStringImplementation {
  int get length;

  static WasmStringImplementation fromExtern(WasmExternRef? ref) {
    return ref!.internalize() as WasmStringImplementation;
  }
}

final class Latin1String implements WasmStringImplementation {
  final WasmArray<WasmI8> codeUnits;

  const Latin1String.unsafeWrap(this.codeUnits);

  static const empty = Latin1String.unsafeWrap(WasmArray.literal([]));

  factory Latin1String.fromAsciiBytes(
    WasmArray<WasmI8> charCodes,
    WasmI32 start,
    WasmI32 length,
  ) {
    final dartStart = start.toIntUnsigned();
    final dartLength = length.toIntUnsigned();

    if (dartStart == 0 && dartLength == charCodes.length) {
      return Latin1String.unsafeWrap(charCodes.clone());
    }

    final copy = WasmArray<WasmI8>(dartLength);
    copy.copy(0, charCodes, dartStart, dartLength);
    return Latin1String.unsafeWrap(copy);
  }

  @override
  int get length => codeUnits.length;
}

final class Utf16String implements WasmStringImplementation {
  final WasmArray<WasmI16> codeUnits;

  Utf16String.unsafeWrap(this.codeUnits);

  factory Utf16String.fromCharCodes(
    WasmArray<WasmI16> charCodes,
    WasmI32 start,
    WasmI32 length,
  ) {
    final dartStart = start.toIntUnsigned();
    final dartLength = length.toIntUnsigned();

    if (dartStart == 0 && dartLength == charCodes.length) {
      return Utf16String.unsafeWrap(charCodes.clone());
    }

    final copy = WasmArray<WasmI16>(dartLength);
    copy.copy(0, charCodes, dartStart, dartLength);
    return Utf16String.unsafeWrap(copy);
  }

  @override
  int get length => codeUnits.length;
}
