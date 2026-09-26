// ignore: import_internal_library
import 'dart:_wasm';

import 'constants.dart';
import 'libc.dart';
import 'string.dart';

Latin1String intToString(int value, int radix) {
  if (radix & (radix - 1) == 0) {
    return _toPow2String(value, radix);
  }

  // TODO: Special-case base10

  final bool isNegative = value < 0;
  if (isNegative) value = -value;
  if (value < 0) {
    // With int limited to 64 bits, the value
    // MIN_INT64 = -0x8000000000000000 overflows at negation:
    // -MIN_INT64 == MIN_INT64, so it requires special handling.
    return _minInt64ToRadixString(value, radix);
  }
  var temp = <int>[];
  do {
    int digit = value % radix;
    value ~/= radix;
    temp.add(digits.readUnsigned(digit));
  } while (value > 0);
  if (isNegative) temp.add(0x2d); // '-'.

  final charCodes = WasmArray<WasmI8>(temp.length);
  for (int i = 0, j = temp.length; j > 0; i++) {
    charCodes.write(i, temp[--j]);
  }
  return Latin1String.unsafeWrap(charCodes);
}

// Implementations copied from https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/vm/lib/integers.dart

Latin1String _toPow2String(int value, int radix) {
  if (value == 0) return $0;
  assert(radix & (radix - 1) == 0);
  var negative = value < 0;
  var bitsPerDigit = radix.bitLength - 1;
  var length = 0;
  if (negative) {
    value = -value;
    length = 1;
    if (value < 0) {
      // With int limited to 64 bits, the value
      // MIN_INT64 = -0x8000000000000000 overflows at negation:
      // -MIN_INT64 == MIN_INT64, so it requires special handling.
      return _minInt64ToRadixString(value, radix);
    }
  }
  // Integer division, rounding up, to find number of _digits.
  length += (value.bitLength + bitsPerDigit - 1) ~/ bitsPerDigit;
  final charCodeArray = WasmArray<WasmI8>(length);
  charCodeArray.write(0, 0x2d); // '-'. Is overwritten if not negative.
  var mask = radix - 1;
  do {
    charCodeArray.write(--length, digits.readUnsigned(value & mask));
    value >>= bitsPerDigit;
  } while (value > 0);
  return Latin1String.unsafeWrap(charCodeArray);
}

Latin1String _minInt64ToRadixString(int value, int radix) {
  var temp = <int>[];
  assert(value < 0);
  do {
    int digit = -(value.remainder(radix));
    value ~/= radix;
    temp.add(digits.readUnsigned(digit));
  } while (value != 0);
  temp.add(0x2d); // '-'.

  final charCodeArray = WasmArray<WasmI8>(temp.length);
  for (int i = 0, j = temp.length; j > 0; i++) {
    charCodeArray.write(i, temp[--j]);
  }
  return Latin1String.unsafeWrap(charCodeArray);
}

final class BoxedDoubleResult {
  final double value;
  const BoxedDoubleResult(this.value);
}

double? parseDoubleFromWasmString(WasmStringImplementation str) {
  final len = str.length;
  var start = 0;
  var end = len;
  while (start < end && _isWhitespace(str.codeUnitAtUnchecked(start))) {
    start++;
  }
  while (end > start && _isWhitespace(str.codeUnitAtUnchecked(end - 1))) {
    end--;
  }
  if (start >= end) return null;

  var i = start;
  var negative = false;
  final first = str.codeUnitAtUnchecked(i);
  if (first == 0x2d) {
    // '-'
    negative = true;
    i++;
  } else if (first == 0x2b) {
    // '+'
    i++;
  }
  if (i >= end) return null;

  // Check exact Dart Infinity / NaN literals.
  if (_matchesAscii(str, i, end, 'Infinity')) {
    return negative ? double.negativeInfinity : double.infinity;
  }
  if (!negative && first != 0x2b && _matchesAscii(str, i, end, 'NaN')) {
    return double.nan;
  }

  // Reject Rust-specific 'inf'/'nan' literals: first char after sign must be
  // '0'..'9' or '.'.
  final firstAfterSign = str.codeUnitAtUnchecked(i);
  if (firstAfterSign != 0x2e &&
      (firstAfterSign < 0x30 || firstAfterSign > 0x39)) {
    return null;
  }

  final sliceLen = end - start;
  for (var k = start; k < end; k++) {
    final c = str.codeUnitAtUnchecked(k);
    if (c >= 0x80) return null;
  }

  final bufPtr = mallocAligned(const WasmI32(1), sliceLen.toWasmI32());
  final bufAddr = bufPtr.toIntUnsigned();
  for (var k = 0; k < sliceLen; k++) {
    memory.storeInt8(
      bufAddr + k,
      WasmI32.fromInt(str.codeUnitAtUnchecked(start + k)),
    );
  }

  final outValPtr = mallocAligned(const WasmI32(8), const WasmI32(8));
  final ok = dartDoubleParse(bufPtr, sliceLen.toWasmI32(), outValPtr);
  dartFree(bufPtr, sliceLen.toWasmI32(), const WasmI32(1));

  if (ok.toIntSigned() == 0) {
    dartFree(outValPtr, const WasmI32(8), const WasmI32(8));
    return null;
  }

  final parsed = memory.loadFloat64(outValPtr.toIntUnsigned()).toDouble();
  dartFree(outValPtr, const WasmI32(8), const WasmI32(8));
  return parsed;
}

bool _isWhitespace(int c) =>
    c == 0x20 || (c >= 0x09 && c <= 0x0d) || c == 0x85 || c == 0xa0;

bool _matchesAscii(
  WasmStringImplementation str,
  int start,
  int end,
  String target,
) {
  if (end - start != target.length) return false;
  for (var j = 0; j < target.length; j++) {
    if (str.codeUnitAtUnchecked(start + j) != target.codeUnitAt(j)) {
      return false;
    }
  }
  return true;
}

WasmStringImplementation doubleToWasmString(double value) {
  if (value.isNaN) {
    return Latin1String.unsafeWrap(
      WasmArray<WasmI8>.literal([0x4e, 0x61, 0x4e]),
    );
  }
  if (value.isInfinite) {
    return value.isNegative
        ? Latin1String.unsafeWrap(
            WasmArray<WasmI8>.literal([
              0x2d,
              0x49,
              0x6e,
              0x66,
              0x69,
              0x6e,
              0x69,
              0x74,
              0x79,
            ]),
          )
        : Latin1String.unsafeWrap(
            WasmArray<WasmI8>.literal([
              0x49,
              0x6e,
              0x66,
              0x69,
              0x6e,
              0x69,
              0x74,
              0x79,
            ]),
          );
  }
  if (value == 0.0) {
    return value.isNegative
        ? Latin1String.unsafeWrap(
            WasmArray<WasmI8>.literal([0x2d, 0x30, 0x2e, 0x30]),
          )
        : Latin1String.unsafeWrap(
            WasmArray<WasmI8>.literal([0x30, 0x2e, 0x30]),
          );
  }

  const maxLen = 64;
  final bufPtr = mallocAligned(const WasmI32(1), const WasmI32(maxLen));
  final written = dartDoubleToString(
    WasmF64.fromDouble(value),
    bufPtr,
    const WasmI32(maxLen),
  ).toIntUnsigned();

  final bytes = WasmArray<WasmI8>(written);
  final bufAddr = bufPtr.toIntUnsigned();
  for (var i = 0; i < written; i++) {
    bytes.write(i, memory.loadUint8(bufAddr + i).toIntUnsigned());
  }
  dartFree(bufPtr, const WasmI32(maxLen), const WasmI32(1));
  return Latin1String.unsafeWrap(bytes);
}
