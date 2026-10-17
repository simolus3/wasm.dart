// A vibe-coded Dart port of the Ryū algorithm, based on the `ryu-js` Rust crate
// (https://github.com/boa-dev/ryu-js), which is itself based on
// https://github.com/ulfjack/ryu (Apache-2.0 / Boost Software License 1.0).
//
// Like `Number.prototype.toString` in JavaScript, this formats doubles with
// the shortest representation that round-trips. In addition, integral values
// not using exponential notation get a `.0` suffix to match `double.toString`
// on other Dart platforms.

// ignore: import_internal_library
import 'dart:_wasm';

import '../constants.dart' as constants;
import '../charcodes.dart';
import '../string.dart';

const _doubleMantissaBits = 52;
const _doubleExponentBits = 11;
const _doubleBias = 1023;
const _doublePow5InvBitCount = 125;
const _doublePow5BitCount = 125;

Latin1String formatDouble(double value) {
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
    return sign ? constants.negativeZeroDouble : constants.zeroDouble;
  }

  final (mantissa, exponent) = d2d(ieeeMantissa, ieeeExponent);
  final length = decimalLength17(mantissa);
  // 10^(kk-1) <= v < 10^kk
  final kk = length + exponent;
  final start = sign ? 1 : 0;

  final WasmArray<WasmI8> result;
  if (0 <= exponent && kk <= 21) {
    // 1234e7 -> 12340000000.0
    result = WasmArray(start + kk + 2);
    writeDigits(result, start + length, mantissa, length);
    for (var i = start + length; i < start + kk; i++) {
      result.write(i, $0);
    }
    result.write(start + kk, $dot);
    result.write(start + kk + 1, $0);
  } else if (0 < kk && kk <= 21) {
    // 1234e-2 -> 12.34
    result = WasmArray(start + length + 1);
    final fractionDigits = length - kk;
    final integral = writeDigits(
      result,
      start + length + 1,
      mantissa,
      fractionDigits,
    );
    result.write(start + kk, $dot);
    writeDigits(result, start + kk, integral, kk);
  } else if (-6 < kk && kk <= 0) {
    // 1234e-6 -> 0.001234
    final offset = 2 - kk;
    result = WasmArray(start + offset + length);
    result.write(start, $0);
    result.write(start + 1, $dot);
    for (var i = start + 2; i < start + offset; i++) {
      result.write(i, $0);
    }
    writeDigits(result, start + offset + length, mantissa, length);
  } else {
    final scientificExponent = kk - 1;
    final absExponent = scientificExponent.abs();
    final exponentLength = absExponent >= 100
        ? 3
        : absExponent >= 10
        ? 2
        : 1;

    if (length == 1) {
      // 1e+30
      result = WasmArray(start + 3 + exponentLength);
      result.write(start, $0 + mantissa);
      result.write(start + 1, $e);
    } else {
      // 1234e30 -> 1.234e+33
      result = WasmArray(start + length + 3 + exponentLength);
      final first = writeDigits(
        result,
        start + length + 1,
        mantissa,
        length - 1,
      );
      result.write(start, $0 + first);
      result.write(start + 1, $dot);
      result.write(start + length + 1, $e);
    }

    final exponentStart = result.length - exponentLength - 1;
    result.write(exponentStart, scientificExponent < 0 ? $minus : $plus);
    writeDigits(result, result.length, absExponent, exponentLength);
  }

  if (sign) {
    result.write(0, $minus);
  }
  return Latin1String.unsafeWrap(result);
}

/// Writes the lowest [count] decimal digits of [value] into [target], ending
/// before [end].
///
/// Returns the remaining value after the digits have been removed.
int writeDigits(WasmArray<WasmI8> target, int end, int value, int count) {
  for (var i = 1; i <= count; i++) {
    final next = value ~/ 10;
    target.write(end - i, $0 + (value - 10 * next));
    value = next;
  }
  return value;
}

int decimalLength17(int v) {
  assert(v >= 0 && v < 100000000000000000);
  var length = 1;
  var threshold = 10;
  while (length < 17 && v >= threshold) {
    length++;
    threshold *= 10;
  }
  return length;
}

int _pow5bits(int e) {
  assert(e >= 0 && e <= 3528);
  return ((e * 1217359) >> 19) + 1;
}

int _log10Pow2(int e) {
  assert(e >= 0 && e <= 1650);
  return (e * 78913) >> 18;
}

int _log10Pow5(int e) {
  assert(e >= 0 && e <= 2620);
  return (e * 732923) >> 20;
}

int _pow5Factor(int value) {
  // 5 * mInv5 = 1 (mod 2^64)
  const mInv5 = 0xCCCCCCCCCCCCCCCD;
  // #{ n | n = 0 (mod 2^64) } = 2^64 / 5
  const nDiv5 = 3689348814741910323;
  var count = 0;
  while (true) {
    assert(value != 0);
    value *= mInv5;
    // Unsigned comparison of value > nDiv5 (with nDiv5 < 2^63).
    if (value < 0 || value > nDiv5) {
      break;
    }
    count++;
  }
  return count;
}

bool _multipleOfPowerOf5(int value, int p) => _pow5Factor(value) >= p;

bool _multipleOfPowerOf2(int value, int p) {
  assert(value != 0);
  assert(p < 64);
  return (value & ((1 << p) - 1)) == 0;
}

/// Returns the high 64 bits of the unsigned 128-bit product `a * b`.
int umulHigh(int a, int b) {
  const mask = 0xFFFFFFFF;
  final aLo = a & mask;
  final aHi = a >>> 32;
  final bLo = b & mask;
  final bHi = b >>> 32;

  final loLo = aLo * bLo;
  final hiLo = aHi * bLo;
  final loHi = aLo * bHi;
  final hiHi = aHi * bHi;

  final cross = (loLo >>> 32) + (hiLo & mask) + (loHi & mask);
  return hiHi + (hiLo >>> 32) + (loHi >>> 32) + (cross >>> 32);
}

/// Computes `(m * mul) >> j` (truncated to 64 bits), where `mul` is the
/// 128-bit entry at [index] in [table].
int _mulShift64(int m, WasmArray<WasmI64> table, int index, int j) {
  final mulLo = table.read(2 * index);
  final mulHi = table.read(2 * index + 1);

  // b0 = m * mulLo, b2 = m * mulHi, sum = (b0 >> 64) + b2
  final b0Hi = umulHigh(m, mulLo);
  final b2Lo = m * mulHi;
  final b2Hi = umulHigh(m, mulHi);

  final sumLo = b2Lo + b0Hi;
  // Unsigned comparison to detect carry.
  final carry = (sumLo ^ _signBit) < (b0Hi ^ _signBit) ? 1 : 0;
  final sumHi = b2Hi + carry;

  final shift = j - 64;
  assert(shift > 0 && shift < 64);
  return (sumLo >>> shift) | (sumHi << (64 - shift));
}

const _signBit = -0x8000000000000000;

/// Converts a finite, non-zero double (given by its IEEE mantissa and
/// exponent) into the shortest decimal `mantissa * 10^exponent` that rounds
/// back to the same double.
(int, int) d2d(int ieeeMantissa, int ieeeExponent) {
  final int e2, m2;
  if (ieeeExponent == 0) {
    e2 = 1 - _doubleBias - _doubleMantissaBits - 2;
    m2 = ieeeMantissa;
  } else {
    e2 = ieeeExponent - _doubleBias - _doubleMantissaBits - 2;
    m2 = (1 << _doubleMantissaBits) | ieeeMantissa;
  }
  final even = (m2 & 1) == 0;
  final acceptBounds = even;

  // Step 2: Determine the interval of valid decimal representations.
  final mv = 4 * m2;
  // Implicit bool -> int conversion. True is 1, false is 0.
  final mmShift = (ieeeMantissa != 0 || ieeeExponent <= 1) ? 1 : 0;
  // We would compute mp and mm like this:
  // uint64_t mp = 4 * m2 + 2;
  // uint64_t mm = mv - 1 - mmShift;

  // Step 3: Convert to a decimal power base using 128-bit arithmetic.
  int vr, vp, vm;
  final int e10;
  var vmIsTrailingZeros = false;
  var vrIsTrailingZeros = false;
  if (e2 >= 0) {
    final q = _log10Pow2(e2) - (e2 > 3 ? 1 : 0);
    e10 = q;
    final k = _doublePow5InvBitCount + _pow5bits(q) - 1;
    final i = -e2 + q + k;
    const table = constants.doublePow5InvSplit;
    vr = _mulShift64(4 * m2, table, q, i);
    vp = _mulShift64(4 * m2 + 2, table, q, i);
    vm = _mulShift64(4 * m2 - 1 - mmShift, table, q, i);

    if (q <= 21) {
      // This should use q <= 22, but I think 21 is also safe. Smaller values
      // may still be safe, but it's more difficult to reason about them.
      // Only one of mp, mv, and mm can be a multiple of 5, if any.
      final mvMod5 = mv % 5;
      if (mvMod5 == 0) {
        vrIsTrailingZeros = _multipleOfPowerOf5(mv, q);
      } else if (acceptBounds) {
        // Same as min(e2 + (~mm & 1), pow5Factor(mm)) >= q
        // <=> e2 + (~mm & 1) >= q && pow5Factor(mm) >= q
        // <=> true && pow5Factor(mm) >= q, since e2 >= q.
        vmIsTrailingZeros = _multipleOfPowerOf5(mv - 1 - mmShift, q);
      } else {
        // Same as min(e2 + 1, pow5Factor(mp)) >= q.
        if (_multipleOfPowerOf5(mv + 2, q)) vp--;
      }
    }
  } else {
    final q = _log10Pow5(-e2) - (-e2 > 1 ? 1 : 0);
    e10 = q + e2;
    final i = -e2 - q;
    final k = _pow5bits(i) - _doublePow5BitCount;
    final j = q - k;
    const table = constants.doublePow5Split;
    vr = _mulShift64(4 * m2, table, i, j);
    vp = _mulShift64(4 * m2 + 2, table, i, j);
    vm = _mulShift64(4 * m2 - 1 - mmShift, table, i, j);

    if (q <= 1) {
      // {vr,vp,vm} is trailing zeros if {mv,mp,mm} has at least q trailing 0
      // bits. mv = 4 * m2, so it always has at least two trailing 0 bits.
      vrIsTrailingZeros = true;
      if (acceptBounds) {
        // mm = mv - 1 - mmShift, so it has 1 trailing 0 bit iff mmShift == 1.
        vmIsTrailingZeros = mmShift == 1;
      } else {
        // mp = mv + 2, so it always has at least one trailing 0 bit.
        vp--;
      }
    } else if (q < 63) {
      // We want to know if the full product has at least q trailing zeros.
      // We need to compute min(p2(mv), p5(mv) - e2) >= q
      // <=> p2(mv) >= q (because -e2 >= q)
      vrIsTrailingZeros = _multipleOfPowerOf2(mv, q);
    }
  }

  // Step 4: Find the shortest decimal representation in the interval of
  // valid representations.
  var removed = 0;
  var lastRemovedDigit = 0;
  final int output;
  if (vmIsTrailingZeros || vrIsTrailingZeros) {
    // General case, which happens rarely (~0.7%).
    while (true) {
      final vpDiv10 = vp ~/ 10;
      final vmDiv10 = vm ~/ 10;
      if (vpDiv10 <= vmDiv10) {
        break;
      }
      final vmMod10 = vm - 10 * vmDiv10;
      final vrDiv10 = vr ~/ 10;
      final vrMod10 = vr - 10 * vrDiv10;
      vmIsTrailingZeros &= vmMod10 == 0;
      vrIsTrailingZeros &= lastRemovedDigit == 0;
      lastRemovedDigit = vrMod10;
      vr = vrDiv10;
      vp = vpDiv10;
      vm = vmDiv10;
      removed++;
    }
    if (vmIsTrailingZeros) {
      while (true) {
        final vmDiv10 = vm ~/ 10;
        final vmMod10 = vm - 10 * vmDiv10;
        if (vmMod10 != 0) {
          break;
        }
        final vpDiv10 = vp ~/ 10;
        final vrDiv10 = vr ~/ 10;
        final vrMod10 = vr - 10 * vrDiv10;
        vrIsTrailingZeros &= lastRemovedDigit == 0;
        lastRemovedDigit = vrMod10;
        vr = vrDiv10;
        vp = vpDiv10;
        vm = vmDiv10;
        removed++;
      }
    }
    if (vrIsTrailingZeros && lastRemovedDigit == 5 && vr % 2 == 0) {
      // Round even if the exact number is .....50..0.
      lastRemovedDigit = 4;
    }
    // We need to take vr + 1 if vr is outside bounds or we need to round up.
    output =
        vr +
        (((vr == vm && (!acceptBounds || !vmIsTrailingZeros)) ||
                lastRemovedDigit >= 5)
            ? 1
            : 0);
  } else {
    // Specialized for the common case (~99.3%). Percentages below are
    // relative to this.
    var roundUp = false;
    final vpDiv100 = vp ~/ 100;
    final vmDiv100 = vm ~/ 100;
    if (vpDiv100 > vmDiv100) {
      // Optimization: remove two digits at a time (~86.2%).
      final vrDiv100 = vr ~/ 100;
      final vrMod100 = vr - 100 * vrDiv100;
      roundUp = vrMod100 >= 50;
      vr = vrDiv100;
      vp = vpDiv100;
      vm = vmDiv100;
      removed += 2;
    }
    // Loop iterations below (approximately), without optimization above:
    // 0: 0.03%, 1: 13.8%, 2: 70.6%, 3: 14.0%, 4: 1.40%, 5: 0.14%, 6+: 0.02%
    // Loop iterations below (approximately), with optimization above:
    // 0: 70.6%, 1: 27.8%, 2: 1.40%, 3: 0.14%, 4+: 0.02%
    while (true) {
      final vpDiv10 = vp ~/ 10;
      final vmDiv10 = vm ~/ 10;
      if (vpDiv10 <= vmDiv10) {
        break;
      }
      final vrDiv10 = vr ~/ 10;
      final vrMod10 = vr - 10 * vrDiv10;
      roundUp = vrMod10 >= 5;
      vr = vrDiv10;
      vp = vpDiv10;
      vm = vmDiv10;
      removed++;
    }
    // We need to take vr + 1 if vr is outside bounds or we need to round up.
    output = vr + ((vr == vm || roundUp) ? 1 : 0);
  }

  return (output, e10 + removed);
}
