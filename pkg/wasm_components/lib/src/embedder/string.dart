// ignore: import_internal_library
import 'dart:_wasm';

import 'regex/character.dart';
import 'regex/regex.dart';
import 'utils.dart';

/// The string implementation used when compiling Dart to WebAssembly
/// components.
sealed class WasmStringImplementation extends RegexString {
  const WasmStringImplementation._();

  factory WasmStringImplementation.fromDartCodeUnits(
    List<int> units,
    bool isAscii,
  ) {
    if (isAscii) {
      final array = WasmArray<WasmI8>(units.length);
      for (var i = 0; i < units.length; i++) {
        array.write(i, units[i]);
      }

      return Latin1String.unsafeWrap(array);
    } else {
      final array = WasmArray<WasmI16>(units.length);
      for (var i = 0; i < units.length; i++) {
        array.write(i, units[i]);
      }

      return Utf16String.unsafeWrap(array);
    }
  }

  @override
  int get length;

  @override
  int codeUnitAtUnchecked(int offset);

  @override
  bool get isOneByteString => this is Latin1String;

  void writeIntoCharArray(
    WasmArray<WasmI16> target,
    int targetStart,
    int start,
    int end,
  );

  WasmStringImplementation substring(WasmI32 start, WasmI32 end);
  WasmStringImplementation concat(WasmStringImplementation other) {
    return WasmStringImplementation._concatUtf16(this, other);
  }

  WasmStringImplementation repeat(int amount);

  WasmStringImplementation toUpper() {
    return _transformCase(_CaseMapping(true));
  }

  WasmStringImplementation toLower() {
    return _transformCase(_CaseMapping(false));
  }

  WasmStringImplementation _transformCase(_CaseMapping mapping);

  bool stringEquals(WasmStringImplementation other) {
    if (identical(this, other)) return true;

    final thisLength = length;
    final otherLength = other.length;

    if (thisLength != otherLength) return false;
    return compareTo(other) == const WasmI32(0);
  }

  WasmI32 compareTo(WasmStringImplementation other) {
    var aLength = length;
    var bLength = other.length;
    for (var i = 0; i < aLength && i < bLength; i++) {
      var charA = codeUnitAtUnchecked(i);
      var charB = other.codeUnitAtUnchecked(i);

      if (charA != charB) return WasmI32.fromInt(charA - charB);
    }

    // If one string is a prefix of the other, then the shorter string is
    // ordered before the longer string.
    return WasmI32.fromInt(aLength - bLength);
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

    a.writeIntoCharArray(array, 0, 0, aLength);
    b.writeIntoCharArray(array, aLength, 0, bLength);
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
  void writeIntoCharArray(
    WasmArray<WasmI16> target,
    int targetStart,
    int start,
    int end,
  ) {
    for (var i = start; i < end; i++) {
      target.write(targetStart + i - start, codeUnitAtUnchecked(i));
    }
  }

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

  @override
  WasmStringImplementation _transformCase(_CaseMapping mapping) {
    final length = this.length;
    final copy = WasmArray<WasmI8>(length);
    for (var i = 0; i < length; i++) {
      copy.write(i, mapping.processCharCode(codeUnitAtUnchecked(i)));
    }

    if (!mapping.hadChanges) return this;
    return Latin1String.unsafeWrap(copy);
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
  void writeIntoCharArray(
    WasmArray<WasmI16> target,
    int targetStart,
    int start,
    int end,
  ) {
    target.copyTyped(targetStart, codeUnits, start, end - start);
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
      writeIntoCharArray(array, offset, 0, sourceLength);
      offset += sourceLength;
    }

    return Utf16String.unsafeWrap(array);
  }

  @override
  WasmStringImplementation _transformCase(_CaseMapping mapping) {
    final length = this.length;
    final copy = WasmArray<WasmI16>(length);
    for (var i = 0; i < length; i++) {
      copy.write(i, mapping.processCharCode(codeUnitAtUnchecked(i)));
    }

    if (!mapping.hadChanges) return this;
    return Utf16String.unsafeWrap(copy);
  }
}

final class _CaseMapping {
  var hadChanges = false;
  final bool toUpper;

  new(this.toUpper);

  int processCharCode(int original) {
    if (toUpper) {
      final toUpper = charToUpper(original);
      if (toUpper != original) hadChanges = true;

      return toUpper;
    } else {
      final toLower = charToLower(original);
      if (toLower != original) hadChanges = true;

      return toLower;
    }
  }
}
