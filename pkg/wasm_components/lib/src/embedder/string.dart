// ignore: import_internal_library
import 'dart:_wasm';

import 'utils.dart';

/// The string implementation used when compiling Dart to WebAssembly
/// components.
sealed class WasmStringImplementation {
  const WasmStringImplementation._();

  int get length;

  int codeUnitAtUnchecked(int offset);

  WasmStringImplementation repeat(int amount);

  static WasmStringImplementation fromExtern(WasmExternRef? ref) {
    return ref!.internalize().toObject() as WasmStringImplementation;
  }
}

final class Latin1String extends WasmStringImplementation {
  final WasmArray<WasmI8> codeUnits;

  @pragma('wasm:entry-point')
  const Latin1String.unsafeWrap(this.codeUnits) : super._();

  static const empty = Latin1String.unsafeWrap(WasmArray.literal([]));

  factory Latin1String.fromAsciiBytes(
    WasmArray<WasmI8> charCodes,
    WasmI32 start,
    WasmI32 length,
  ) {
    final dartStart = start.toIntUnsigned();
    final dartLength = length.toIntUnsigned();

    if (dartStart == 0 && dartLength == charCodes.length) {
      return Latin1String.unsafeWrap(charCodes.cloneTyped());
    }

    final copy = WasmArray<WasmI8>(dartLength);
    copy.copyTyped(0, charCodes, dartStart, dartLength);
    return Latin1String.unsafeWrap(copy);
  }

  @override
  int get length => codeUnits.length;

  @override
  int codeUnitAtUnchecked(int offset) {
    return codeUnits.readUnsigned(offset);
  }

  @override
  WasmStringImplementation repeat(int amount) {
    final sourceLength = codeUnits.length;
    final array = WasmArray<WasmI8>(sourceLength * amount);
    var offset = 0;
    for (var copy = 0; copy < amount; copy++) {
      array.copyTyped(offset, codeUnits, 0, sourceLength);
      offset += sourceLength;
    }

    return Latin1String.unsafeWrap(array);
  }
}

final class Utf16String extends WasmStringImplementation {
  final WasmArray<WasmI16> codeUnits;

  Utf16String.unsafeWrap(this.codeUnits) : super._();

  factory Utf16String.fromCharCodes(
    WasmArray<WasmI16> charCodes,
    WasmI32 start,
    WasmI32 length,
  ) {
    final dartStart = start.toIntUnsigned();
    final dartLength = length.toIntUnsigned();

    if (dartStart == 0 && dartLength == charCodes.length) {
      return Utf16String.unsafeWrap(charCodes.cloneTyped());
    }

    final copy = WasmArray<WasmI16>(dartLength);
    copy.copyTyped(0, charCodes, dartStart, dartLength);
    return Utf16String.unsafeWrap(copy);
  }

  @override
  int get length => codeUnits.length;

  @override
  int codeUnitAtUnchecked(int offset) {
    return codeUnits.readUnsigned(offset);
  }

  @override
  WasmStringImplementation repeat(int amount) {
    final sourceLength = codeUnits.length;
    final array = WasmArray<WasmI16>(sourceLength * amount);
    var offset = 0;
    for (var copy = 0; copy < amount; copy++) {
      array.copyTyped(offset, codeUnits, 0, sourceLength);
      offset += sourceLength;
    }

    return Utf16String.unsafeWrap(array);
  }
}
