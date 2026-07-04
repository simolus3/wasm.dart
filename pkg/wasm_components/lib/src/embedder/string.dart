// ignore: import_internal_library
import 'dart:_wasm';

import 'utils.dart';

/// The string implementation used when compiling Dart to WebAssembly
/// components.
sealed class WasmStringImplementation {
  const WasmStringImplementation._();

  int get length;

  int codeUnitAtUnchecked(int offset);

  WasmStringImplementation substring(WasmI32 start, WasmI32 end);
  WasmStringImplementation concat(WasmStringImplementation other) {
    return WasmStringImplementation._concatUtf16(this, other);
  }

  WasmStringImplementation repeat(int amount);

  bool stringEquals(WasmStringImplementation other) {
    final thisLength = length;
    final otherLength = other.length;

    if (thisLength != otherLength) return false;
    return compareTo(other) == const WasmI32(0);
  }

  WasmI32 compareTo(WasmStringImplementation other) {
    var aLength = length;
    var bLength = other.length;
    for (var i = 0; i < aLength && i < bLength; i = i++) {
      var charA = codeUnitAtUnchecked(i);
      var charB = other.codeUnitAtUnchecked(i);

      if (charA != charB) return WasmI32.fromInt(charB - charA);
    }

    // If one string is a prefix of the other, then the shorter string is
    // ordered before the longer string.
    return WasmI32.fromInt(bLength - aLength);
  }

  int indexOfString(WasmStringImplementation substring, int start) {
    // TODO: Explore more efficient string matching algorithms.
    final substringLength = substring.length;
    final limit = length - substringLength;

    for (var i = start; i <= limit; i++) {
      var match = true;
      for (var j = 0; j < substringLength; j++) {
        if (codeUnitAtUnchecked(i + j) != substring.codeUnitAtUnchecked(j)) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }

    return -1;
  }

  int lastIndexOfString(WasmStringImplementation substring, int start) {
    final substringLength = substring.length;
    final limit = length - substringLength;
    if (limit < 0) return -1;
    if (start > limit) start = limit;

    for (var i = start; i >= 0; i--) {
      var match = true;
      for (var j = 0; j < substringLength; j++) {
        if (codeUnitAtUnchecked(i + j) != substring.codeUnitAtUnchecked(j)) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }

    return -1;
  }

  static WasmStringImplementation fromExtern(WasmExternRef? ref) {
    return ref!.internalize().toObject() as WasmStringImplementation;
  }

  static WasmStringImplementation _concatUtf16(
    WasmStringImplementation a,
    WasmStringImplementation b,
  ) {
    final aLength = a.length;
    final bLength = b.length;
    final array = WasmArray<WasmI16>(aLength + bLength);

    for (var i = 0; i < aLength; i++) {
      array.write(i, a.codeUnitAtUnchecked(i));
    }
    for (var i = 0; i < bLength; i++) {
      array.write(aLength + i, b.codeUnitAtUnchecked(i));
    }

    return Utf16String.unsafeWrap(array);
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
  WasmStringImplementation substring(WasmI32 start, WasmI32 end) {
    return Latin1String.fromAsciiBytes(codeUnits, start, end - start);
  }

  @override
  WasmStringImplementation concat(WasmStringImplementation other) {
    if (other is Latin1String) {
      final thisLength = length;
      final otherLength = other.length;
      final array = WasmArray<WasmI8>(thisLength + otherLength);

      array.copyTyped(0, codeUnits, 0, thisLength);
      array.copyTyped(thisLength, other.codeUnits, 0, otherLength);

      return Latin1String.unsafeWrap(array);
    } else {
      return WasmStringImplementation._concatUtf16(this, other);
    }
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
  WasmStringImplementation substring(WasmI32 start, WasmI32 end) {
    return Utf16String.fromCharCodes(codeUnits, start, end - start);
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
