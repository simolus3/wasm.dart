// ignore: import_internal_library
import 'dart:_wasm';

import 'constants.dart';
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

  // Check Infinity / NaN
  if (_matchesAscii(str, i, end, 'Infinity')) {
    return negative ? double.negativeInfinity : double.infinity;
  }
  if (!negative && first != 0x2b && _matchesAscii(str, i, end, 'NaN')) {
    return double.nan;
  }

  var intPart = 0.0;
  var fracPart = 0.0;
  var fracScale = 1.0;
  var hasDigits = false;

  while (i < end) {
    final c = str.codeUnitAtUnchecked(i);
    if (c >= 0x30 && c <= 0x39) {
      hasDigits = true;
      intPart = intPart * 10.0 + (c - 0x30);
      i++;
    } else {
      break;
    }
  }

  if (i < end && str.codeUnitAtUnchecked(i) == 0x2e) {
    // '.'
    i++;
    while (i < end) {
      final c = str.codeUnitAtUnchecked(i);
      if (c >= 0x30 && c <= 0x39) {
        hasDigits = true;
        fracPart = fracPart * 10.0 + (c - 0x30);
        fracScale *= 10.0;
        i++;
      } else {
        break;
      }
    }
  }

  if (!hasDigits) return null;

  var result = intPart + (fracPart / fracScale);

  if (i < end) {
    final c = str.codeUnitAtUnchecked(i);
    if (c == 0x65 || c == 0x45) {
      // 'e' or 'E'
      i++;
      if (i >= end) return null;
      var expNeg = false;
      final expSign = str.codeUnitAtUnchecked(i);
      if (expSign == 0x2d) {
        expNeg = true;
        i++;
      } else if (expSign == 0x2b) {
        i++;
      }
      if (i >= end) return null;
      var expVal = 0;
      var hasExpDigits = false;
      while (i < end) {
        final ec = str.codeUnitAtUnchecked(i);
        if (ec >= 0x30 && ec <= 0x39) {
          hasExpDigits = true;
          expVal = expVal * 10 + (ec - 0x30);
          i++;
        } else {
          return null;
        }
      }
      if (!hasExpDigits) return null;
      var pow10 = 1.0;
      for (var k = 0; k < expVal; k++) {
        pow10 *= 10.0;
      }
      result = expNeg ? (result / pow10) : (result * pow10);
    } else {
      return null;
    }
  }

  return negative ? -result : result;
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
  final neg = value.isNegative;
  final absVal = neg ? -value : value;
  var whole = absVal.truncate();
  var frac = ((absVal - whole) * 1000000).round();
  if (frac >= 1000000) {
    whole += 1;
    frac = 0;
  }
  final minus = Latin1String.unsafeWrap(WasmArray<WasmI8>.literal([0x2d]));
  final wholePart = intToString(whole, 10);
  final wholeStr = neg ? minus.concat(wholePart) : wholePart;
  final dot = Latin1String.unsafeWrap(WasmArray<WasmI8>.literal([0x2e]));
  if (frac == 0) {
    return wholeStr.concat(dot).concat($0);
  }
  var prefix = wholeStr.concat(dot);
  for (var scale = 100000; scale > frac; scale ~/= 10) {
    prefix = prefix.concat($0);
  }
  var fracTemp = frac;
  while (fracTemp > 0 && fracTemp % 10 == 0) {
    fracTemp ~/= 10;
  }
  return prefix.concat(intToString(fracTemp, 10));
}
