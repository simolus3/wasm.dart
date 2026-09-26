import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _doubleToString,
    _doubleParse,
    _stringReplaceRangeAndCodeUnits,
  ]);
}

void _doubleToString(BaseResultCollector collector) {
  collector.recordString(e: 0.0.toString());
  collector.recordString(e: (-0.0).toString());
  collector.recordString(e: 42.5.toString());
  collector.recordString(e: (-0.5).toString());
  collector.recordString(e: 1.05.toString());
  collector.recordString(e: 0.0025.toString());
  collector.recordString(e: double.infinity.toString());
  collector.recordString(e: double.negativeInfinity.toString());
  collector.recordString(e: double.nan.toString());
}

void _doubleParse(BaseResultCollector collector) {
  collector.recordString(e: double.parse('3.1415').toString());
  collector.recordString(e: double.parse('  -42.5  ').toString());
  collector.recordString(e: double.parse('1.5e3').toString());
  collector.recordString(e: double.parse('2.5E-2').toString());
  collector.recordBool(e: double.parse('Infinity').isInfinite);
  collector.recordBool(e: double.parse('-Infinity') == double.negativeInfinity);
  collector.recordBool(e: double.parse('NaN').isNaN);
  collector.recordBool(e: double.tryParse('invalid') == null);
  collector.recordBool(e: double.tryParse('') == null);
}

void _stringReplaceRangeAndCodeUnits(BaseResultCollector collector) {
  collector.recordString(e: 'hello world'.replaceRange(6, 11, 'dart'));
  final units = 'Dart!'.codeUnits;
  collector.recordInt(e: units.length);
  collector.recordInt(e: units[0]);
  collector.recordInt(e: units[4]);
}
