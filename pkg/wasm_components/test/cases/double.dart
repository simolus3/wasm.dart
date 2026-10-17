import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _specialValues,
    _integral,
    _fractional,
    _exponential,
    _extremes,
    _toStringAsFixed,
    _toStringAsExponential,
    _toStringAsPrecision,
  ]);
}

void _record(BaseResultCollector collector, List<double> values) {
  for (final value in values) {
    collector.recordString(e: value.toString());
  }
}

void _specialValues(BaseResultCollector collector) {
  _record(collector, [
    0.0,
    -0.0,
    double.nan,
    double.infinity,
    double.negativeInfinity,
  ]);
}

void _integral(BaseResultCollector collector) {
  _record(collector, [
    1.0,
    -1.0,
    100.0,
    12340000000.0,
    9007199254740993.0,
    1e20,
    -123456789012345680000.0,
  ]);
}

void _fractional(BaseResultCollector collector) {
  _record(collector, [
    0.1,
    0.1 + 0.2,
    1 / 3,
    -2.5,
    123.456,
    0.000001,
    -0.000001234,
  ]);
}

void _exponential(BaseResultCollector collector) {
  _record(collector, [
    1e21,
    -1e21,
    1.5e21,
    1e-7,
    1.5e-7,
    -1.234e-100,
    1e100,
    6.02214076e23,
  ]);
}

void _extremes(BaseResultCollector collector) {
  _record(collector, [
    double.maxFinite,
    -double.maxFinite,
    double.minPositive,
    2.2250738585072014e-308,
    2.225073858507201e-308,
  ]);
}

void _toStringAsFixed(BaseResultCollector collector) {
  for (final value in _formatValues) {
    for (final digits in const [0, 1, 2, 5, 20]) {
      collector.recordString(e: value.toStringAsFixed(digits));
    }
  }
}

const _formatValues = [
  0.0,
  -0.0,
  0.5,
  -2.5,
  1.005,
  9.995,
  99.5,
  123.456,
  1 / 3,
  0.000001234,
  1e-10,
  5e-324,
  9.999999999999999e20,
  1e21,
  -1.5e22,
  double.nan,
  double.infinity,
  double.negativeInfinity,
  1.45,
  0.15,
  8.5e-7,
  6.02214076e23,
  2.2250738585072014e-308,
];

void _toStringAsExponential(BaseResultCollector collector) {
  for (final value in _formatValues) {
    collector.recordString(e: value.toStringAsExponential());
    for (final digits in const [0, 1, 3, 20]) {
      collector.recordString(e: value.toStringAsExponential(digits));
    }
  }
}

void _toStringAsPrecision(BaseResultCollector collector) {
  for (final value in _formatValues) {
    for (final precision in const [1, 2, 7, 21]) {
      collector.recordString(e: value.toStringAsPrecision(precision));
    }
  }
}
