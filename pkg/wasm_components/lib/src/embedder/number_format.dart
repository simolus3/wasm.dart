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
