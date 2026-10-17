// Dart implementations of `Number.prototype.toExponential` and
// `Number.prototype.toPrecision`, based on `d2exp_buffered_n` from
// https://github.com/ulfjack/ryu (Apache-2.0 / Boost Software License 1.0).

// ignore: import_internal_library
import 'dart:_wasm';

import '../charcodes.dart';
import '../constants.dart' as constants;
import '../string.dart';
import '../utils.dart';
import 'ryu.dart';
import 'to_fixed.dart';

const _doubleMantissaBits = 52;
const _doubleExponentBits = 11;
const _doubleBias = 1023;

const _pow10AdditionalBits = 120;
const _additionalBits2 = 120;

/// The maximum amount of `fractionDigits` supported by
/// [formatDoubleToExponential].
///
/// JavaScript supports up to 100, but Dart restricts this to 20.
const maxExponentialFractionDigits = 20;

/// The maximum `precision` supported by [formatDoubleToPrecision].
///
/// JavaScript supports up to 100, but Dart restricts this to 21. Note that
/// the tables used by [_d2exp] only support up to 21 significant digits.
const maxPrecision = 21;

/// Formats [value] like `value.toExponential(fractionDigits)` in JavaScript.
///
/// Note that this differs from Dart's `toStringAsExponential` for negative
/// zero, which JavaScript formats without a sign.
Latin1String formatDoubleToExponential(double value, int? fractionDigits) {
  assert(
    fractionDigits == null ||
        (fractionDigits >= 0 && fractionDigits <= maxExponentialFractionDigits),
  );

  if (value.isNaN) {
    return constants.nan;
  }
  if (value.isInfinite) {
    return value.isNegative ? constants.negativeInfinity : constants.infinity;
  }

  final bits = WasmF64.fromDouble(value).asWasmI64.toInt();
  final sign = bits < 0;
  final ieeeMantissa = bits & ((1 << _doubleMantissaBits) - 1);
  final ieeeExponent =
      (bits >>> _doubleMantissaBits) & ((1 << _doubleExponentBits) - 1);

  if (ieeeExponent == 0 && ieeeMantissa == 0) {
    final count = (fractionDigits ?? 0) + 1;
    return _formatExponential(false, _zeroes(count), count, 0);
  }

  if (fractionDigits == null) {
    // Use as many digits as necessary to uniquely represent the value, which
    // is what the shortest representation computed by Ryū gives us.
    final (mantissa, exponent) = d2d(ieeeMantissa, ieeeExponent);
    final count = decimalLength17(mantissa);
    final digits = WasmArray<WasmI8>(count);
    writeDigits(digits, count, mantissa, count);
    return _formatExponential(sign, digits, count, exponent + count - 1);
  }

  final count = fractionDigits + 1;
  final digits = WasmArray<WasmI8>(count);
  final exponent = _d2expFromBits(ieeeMantissa, ieeeExponent, count, digits);
  return _formatExponential(sign, digits, count, exponent);
}

/// Formats [value] like `value.toPrecision(precision)` in JavaScript.
///
/// Note that this differs from Dart's `toStringAsPrecision` for negative
/// zero, which JavaScript formats without a sign.
Latin1String formatDoubleToPrecision(double value, int precision) {
  assert(precision >= 1 && precision <= maxPrecision);

  if (value.isNaN) {
    return constants.nan;
  }
  if (value.isInfinite) {
    return value.isNegative ? constants.negativeInfinity : constants.infinity;
  }

  final bits = WasmF64.fromDouble(value).asWasmI64.toInt();
  final sign = bits < 0;
  final ieeeMantissa = bits & ((1 << _doubleMantissaBits) - 1);
  final ieeeExponent =
      (bits >>> _doubleMantissaBits) & ((1 << _doubleExponentBits) - 1);

  if (ieeeExponent == 0 && ieeeMantissa == 0) {
    return _formatPrecision(false, _zeroes(precision), precision, 0);
  }

  final digits = WasmArray<WasmI8>(precision);
  final exponent = _d2expFromBits(
    ieeeMantissa,
    ieeeExponent,
    precision,
    digits,
  );
  return _formatPrecision(sign, digits, precision, exponent);
}

/// Formats `d.ddde±x` (or `de±x` for a single digit).
Latin1String _formatExponential(
  bool sign,
  WasmArray<WasmI8> digits,
  int count,
  int exponent,
) {
  final absExponent = exponent.abs();
  final exponentLength = _decimalLength3(absExponent);
  final start = sign ? 1 : 0;
  final dotLength = count > 1 ? 1 : 0;
  final result = WasmArray<WasmI8>(
    start + count + dotLength + 2 + exponentLength,
  );

  if (sign) result.write(0, $minus);
  result.write(start, digits.readUnsigned(0));
  var index = start + 1;
  if (count > 1) {
    result.write(index++, $dot);
    result.copyTyped(index, digits, 1, count - 1);
    index += count - 1;
  }
  result.write(index++, $e);
  result.write(index++, exponent < 0 ? $minus : $plus);
  writeDigits(result, index + exponentLength, absExponent, exponentLength);
  return Latin1String.unsafeWrap(result);
}

Latin1String _formatPrecision(
  bool sign,
  WasmArray<WasmI8> digits,
  int precision,
  int exponent,
) {
  if (exponent < -6 || exponent >= precision) {
    return _formatExponential(sign, digits, precision, exponent);
  }

  final start = sign ? 1 : 0;
  final WasmArray<WasmI8> result;
  if (exponent >= 0) {
    // ddd.ddd, or ddd if exponent == precision - 1
    final integerDigits = exponent + 1;
    final hasDot = integerDigits < precision;
    result = WasmArray(start + precision + (hasDot ? 1 : 0));
    result.copyTyped(start, digits, 0, integerDigits);
    if (hasDot) {
      result.write(start + integerDigits, $dot);
      result.copyTyped(
        start + integerDigits + 1,
        digits,
        integerDigits,
        precision - integerDigits,
      );
    }
  } else {
    // 0.000ddd
    final leadingZeroes = -exponent - 1;
    result = WasmArray(start + 2 + leadingZeroes + precision);
    result.write(start, $0);
    result.write(start + 1, $dot);
    for (var i = 0; i < leadingZeroes; i++) {
      result.write(start + 2 + i, $0);
    }
    result.copyTyped(start + 2 + leadingZeroes, digits, 0, precision);
  }

  if (sign) result.write(0, $minus);
  return Latin1String.unsafeWrap(result);
}

WasmArray<WasmI8> _zeroes(int count) {
  final digits = WasmArray<WasmI8>(count);
  for (var i = 0; i < count; i++) {
    digits.write(i, $0);
  }
  return digits;
}

int _decimalLength3(int v) {
  assert(v >= 0 && v < 1000);
  return v >= 100
      ? 3
      : v >= 10
      ? 2
      : 1;
}

int _d2expFromBits(
  int ieeeMantissa,
  int ieeeExponent,
  int count,
  WasmArray<WasmI8> out,
) {
  if (ieeeExponent == 0) {
    return _d2exp(
      ieeeMantissa,
      1 - _doubleBias - _doubleMantissaBits,
      count,
      out,
    );
  } else {
    return _d2exp(
      (1 << _doubleMantissaBits) | ieeeMantissa,
      ieeeExponent - _doubleBias - _doubleMantissaBits,
      count,
      out,
    );
  }
}

/// Writes the [count] most significant decimal digits of the non-zero value
/// `m2 * 2^e2` into [out] (as ASCII characters), rounding ties away from zero
/// like JavaScript does.
///
/// Returns the decimal exponent of the first digit.
int _d2exp(int m2, int e2, int count, WasmArray<WasmI8> out) {
  assert(count >= 1 && count <= maxPrecision);
  assert(m2 != 0);

  var index = 0;
  var digits = 0;
  var printedDigits = 0;
  var availableDigits = 0;
  var exponent = 0;

  // Integral part, going through blocks of 9 digits starting with the most
  // significant one.
  if (e2 >= -_doubleMantissaBits) {
    final idx = e2 < 0 ? 0 : (e2 + 15) ~/ 16;
    final p10bits = 16 * idx + _pow10AdditionalBits;
    final minBlock = constants.pow10MinBlock.readUnsigned(idx);
    final offset = constants.pow10Offset.readUnsigned(idx);
    final len = constants.pow10Offset.readUnsigned(idx + 1) - offset + minBlock;
    final j = p10bits - e2;

    for (var i = len - 1; i >= 0; i--) {
      // Blocks below minBlock are not in the table, but we're guaranteed to
      // have found enough digits by then.
      assert(i >= minBlock);
      digits = mulShiftMod1e9(
        m2 << 8,
        constants.pow10Split,
        offset + i - minBlock,
        j + 8,
      );

      if (printedDigits != 0) {
        if (printedDigits + 9 > count) {
          availableDigits = 9;
          break;
        }
        index += 9;
        writeDigits(out, index, digits, 9);
        printedDigits += 9;
      } else if (digits != 0) {
        availableDigits = decimalLength9(digits);
        exponent = i * 9 + availableDigits - 1;
        if (availableDigits > count) {
          break;
        }
        index += availableDigits;
        writeDigits(out, index, digits, availableDigits);
        printedDigits = availableDigits;
        availableDigits = 0;
      }
    }
  }

  // Fractional part, if we still need more digits.
  if (e2 < 0 && availableDigits == 0) {
    final idx = -e2 ~/ 16;
    final minBlock = constants.minBlock2.readUnsigned(idx);
    final offset = constants.pow10Offset2.readUnsigned(idx);
    final end = constants.pow10Offset2.readUnsigned(idx + 1);
    final j = _additionalBits2 + (-e2 - 16 * idx);

    for (var i = minBlock; i < 200; i++) {
      final p = offset + i - minBlock;
      digits = p >= end
          ? 0
          : mulShiftMod1e9(m2 << 8, constants.pow10Split2, p, j + 8);

      if (printedDigits != 0) {
        if (printedDigits + 9 > count) {
          availableDigits = 9;
          break;
        }
        index += 9;
        writeDigits(out, index, digits, 9);
        printedDigits += 9;
      } else if (digits != 0) {
        availableDigits = decimalLength9(digits);
        exponent = -(i + 1) * 9 + availableDigits - 1;
        if (availableDigits > count) {
          break;
        }
        index += availableDigits;
        writeDigits(out, index, digits, availableDigits);
        printedDigits = availableDigits;
        availableDigits = 0;
      }
    }
  }

  // We have a block of availableDigits digits that we need to cut to the
  // remaining amount of digits.
  final maximum = count - printedDigits;
  if (availableDigits == 0) {
    digits = 0;
  }
  var lastDigit = 0;
  for (var k = maximum; k < availableDigits; k++) {
    lastDigit = digits % 10;
    digits ~/= 10;
  }
  writeDigits(out, index + maximum, digits, maximum);

  // The digits are exact, so lastDigit >= 5 implies that the value is at
  // least halfway to the next representable number. JavaScript rounds those
  // ties away from zero.
  if (lastDigit >= 5) {
    var i = count - 1;
    while (i >= 0 && out.readUnsigned(i) == $0 + 9) {
      out.write(i, $0);
      i--;
    }

    if (i < 0) {
      // All digits were 9, so we're at the next power of 10 now.
      out.write(0, $0 + 1);
      exponent++;
    } else {
      out.write(i, out.readUnsigned(i) + 1);
    }
  }

  return exponent;
}
