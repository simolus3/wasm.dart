// A Dart port of `Number.prototype.toFixed`, based on the `to_fixed` module
// of the `ryu-js` Rust crate (https://github.com/boa-dev/ryu-js), which is
// itself based on `d2fixed` from https://github.com/ulfjack/ryu
// (Apache-2.0 / Boost Software License 1.0).

// ignore: import_internal_library
import 'dart:_wasm';

import '../charcodes.dart';
import '../constants.dart' as constants;
import '../string.dart';
import '../utils.dart';
import 'ryu.dart';

const _doubleMantissaBits = 52;
const _doubleExponentBits = 11;
const _doubleBias = 1023;

const _pow10AdditionalBits = 120;
const _additionalBits2 = 120;

/// The maximum amount of [fractionDigits] supported by [formatDoubleToFixed].
const maxFixedFractionDigits = 100;

/// Formats [value] like `value.toFixed(fractionDigits)` in JavaScript.
///
/// Note that this differs from Dart's `toStringAsFixed` for negative zero,
/// which JavaScript formats without a sign.
Latin1String formatDoubleToFixed(double value, int fractionDigits) {
  assert(fractionDigits >= 0 && fractionDigits <= maxFixedFractionDigits);

  if (value.isNaN) {
    return constants.nan;
  }
  if (value.abs() >= 1e21) {
    // This also covers infinite values.
    return formatDouble(value);
  }

  final bits = WasmF64.fromDouble(value).asWasmI64.toInt();
  final sign = bits < 0;
  final ieeeMantissa = bits & ((1 << _doubleMantissaBits) - 1);
  final ieeeExponent =
      (bits >>> _doubleMantissaBits) & ((1 << _doubleExponentBits) - 1);

  // A sign, at most 21 integer digits (plus one for rounding up), a dot and
  // the fraction digits.
  final out = _Output(WasmArray(24 + fractionDigits));

  if (ieeeExponent == 0 && ieeeMantissa == 0) {
    out.append($0);
    if (fractionDigits != 0) {
      out.append($dot);
      out.appendZeroes(fractionDigits);
    }
    return out.finish();
  }

  if (sign) {
    out.append($minus);
  }

  final int e2, m2;
  if (ieeeExponent == 0) {
    e2 = 1 - _doubleBias - _doubleMantissaBits;
    m2 = ieeeMantissa;
  } else {
    e2 = ieeeExponent - _doubleBias - _doubleMantissaBits;
    m2 = (1 << _doubleMantissaBits) | ieeeMantissa;
  }

  // Integral part, printed in blocks of 9 digits.
  var nonzero = false;
  if (e2 >= -_doubleMantissaBits) {
    final idx = e2 < 0 ? 0 : (e2 + 15) ~/ 16;
    final p10bits = 16 * idx + _pow10AdditionalBits;
    // Doubles below 1e21 have all blocks in the table.
    assert(constants.pow10MinBlock.readUnsigned(idx) == 0);
    final offset = constants.pow10Offset.readUnsigned(idx);
    final len = constants.pow10Offset.readUnsigned(idx + 1) - offset;

    for (var i = len - 1; i >= 0; i--) {
      final j = p10bits - e2;
      final digits = mulShiftMod1e9(
        m2 << 8,
        constants.pow10Split,
        offset + i,
        j + 8,
      );
      if (nonzero) {
        out.appendDigits(digits, 9);
      } else if (digits != 0) {
        out.appendDigits(digits, decimalLength9(digits));
        nonzero = true;
      }
    }
  }

  if (!nonzero) {
    out.append($0);
  }
  if (fractionDigits != 0) {
    out.append($dot);
  }
  if (e2 >= 0) {
    out.appendZeroes(fractionDigits);
    return out.finish();
  }

  // Fractional part, also in blocks of 9 digits.
  final idx = -e2 ~/ 16;
  final minBlock = constants.minBlock2.readUnsigned(idx);
  final offset = constants.pow10Offset2.readUnsigned(idx);
  final end = constants.pow10Offset2.readUnsigned(idx + 1);
  final blocks = fractionDigits ~/ 9 + 1;
  var roundUp = false;

  if (blocks <= minBlock) {
    out.appendZeroes(fractionDigits);
  } else {
    out.appendZeroes(9 * minBlock);
    final j = _additionalBits2 + (-e2 - 16 * idx);

    for (var i = minBlock; i < blocks; i++) {
      final p = offset + i - minBlock;
      if (p >= end) {
        // The remaining digits are all zero, so no rounding is necessary.
        out.appendZeroes(fractionDigits - 9 * i);
        break;
      }

      var digits = mulShiftMod1e9(m2 << 8, constants.pow10Split2, p, j + 8);
      if (i < blocks - 1) {
        out.appendDigits(digits, 9);
      } else {
        final maximum = fractionDigits - 9 * i;
        var lastDigit = 0;
        for (var k = 0; k < 9 - maximum; k++) {
          lastDigit = digits % 10;
          digits ~/= 10;
        }
        // JavaScript rounds ties away from zero (the exact value of the
        // double is used, so lastDigit being 5 implies value >= the tie).
        roundUp = lastDigit >= 5;

        if (maximum != 0) {
          out.appendDigits(digits, maximum);
        }
        break;
      }
    }
  }

  if (roundUp) {
    out.roundUp();
  }
  return out.finish();
}

final class _Output {
  final WasmArray<WasmI8> buffer;
  int index = 0;

  _Output(this.buffer);

  void append(int char) {
    buffer.write(index++, char);
  }

  void appendZeroes(int count) {
    for (var i = 0; i < count; i++) {
      buffer.write(index++, $0);
    }
  }

  /// Appends exactly [count] digits of [digits], padding with zeroes.
  void appendDigits(int digits, int count) {
    index += count;
    writeDigits(buffer, index, digits, count);
  }

  /// Increments the decimal number written so far by one unit in its last
  /// place.
  void roundUp() {
    var roundIndex = index;
    // '.' can't be located at index 0
    var dotIndex = 0;
    while (true) {
      if (roundIndex == 0 || buffer.readUnsigned(roundIndex - 1) == $minus) {
        // All digits were 9 (and are zero now), so we need an additional
        // leading 1. We write it over the first 0 and then shift the dot to
        // the right by appending another zero.
        buffer.write(roundIndex, $0 + 1);
        if (dotIndex > 0) {
          buffer.write(dotIndex, $0);
          buffer.write(dotIndex + 1, $dot);
        }
        append($0);
        break;
      }

      roundIndex--;
      final c = buffer.readUnsigned(roundIndex);
      if (c == $dot) {
        dotIndex = roundIndex;
        continue;
      } else if (c == $0 + 9) {
        buffer.write(roundIndex, $0);
        continue;
      }

      buffer.write(roundIndex, c + 1);
      break;
    }
  }

  Latin1String finish() {
    if (index == buffer.length) {
      return Latin1String.unsafeWrap(buffer);
    }

    final copy = WasmArray<WasmI8>(index);
    copy.copyTyped(0, buffer, 0, index);
    return Latin1String.unsafeWrap(copy);
  }
}

int decimalLength9(int v) {
  assert(v >= 0 && v < 1000000000);
  var length = 1;
  var threshold = 10;
  while (length < 9 && v >= threshold) {
    length++;
    threshold *= 10;
  }
  return length;
}

/// Computes `((m * mul) >> j) % 10^9`, where `mul` is the 192-bit entry at
/// [index] in [table].
int mulShiftMod1e9(int m, WasmArray<WasmI64> table, int index, int j) {
  assert(j >= 128 && j <= 180);
  final mul0 = table.read(3 * index);
  final mul1 = table.read(3 * index + 1);
  final mul2 = table.read(3 * index + 2);

  // b0 = m * mul0, b1 = m * mul1, b2 = m * mul2 (as 128-bit products).
  final b0Hi = umulHigh(m, mul0);
  final b1Lo = m * mul1;
  final b1Hi = umulHigh(m, mul1);
  final b2Lo = m * mul2;
  final b2Hi = umulHigh(m, mul2);

  // mid = b1 + (b0 >> 64)
  final midLo = b1Lo + b0Hi;
  final midHi = b1Hi + _carry(midLo, b0Hi);
  // s1 = b2 + (mid >> 64)
  final s1Lo = b2Lo + midHi;
  final s1Hi = b2Hi + _carry(s1Lo, midHi);

  // Compute s1 >> (j - 128), which is the result before taking the modulus.
  final shift = j - 128;
  final int lo, hi;
  if (shift == 0) {
    lo = s1Lo;
    hi = s1Hi;
  } else {
    lo = (s1Lo >>> shift) | (s1Hi << (64 - shift));
    hi = s1Hi >>> shift;
  }

  // Reduce the 128-bit value (hi, lo) modulo 10^9 in 32-bit steps. Since the
  // remainder is less than 2^30, none of these steps can overflow.
  const p = 1000000000;
  const mask = 0xFFFFFFFF;
  var r = (hi >>> 32) % p;
  r = ((r << 32) + (hi & mask)) % p;
  r = ((r << 32) + (lo >>> 32)) % p;
  return ((r << 32) + (lo & mask)) % p;
}

/// Returns 1 if computing the unsigned 64-bit `sum = a + addend` overflowed.
int _carry(int sum, int addend) {
  const signBit = -0x8000000000000000;
  return (sum ^ signBit) < (addend ^ signBit) ? 1 : 0;
}
