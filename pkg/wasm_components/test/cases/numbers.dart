import 'dart:convert';

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
  collector.recordString(e: 0.123456789.toString());
  collector.recordString(e: 1500.0.toString());
  collector.recordString(e: 1e20.toString());
  collector.recordString(e: 1e21.toString());
  collector.recordString(e: 1e-7.toString());
  collector.recordString(e: double.infinity.toString());
  collector.recordString(e: double.negativeInfinity.toString());
  collector.recordString(e: double.nan.toString());
}

void _doubleParse(BaseResultCollector collector) {
  collector.recordString(e: double.parse('3.1415').toString());
  collector.recordString(e: double.parse('  -42.5  ').toString());
  collector.recordString(e: double.parse('1.5e3').toString());
  collector.recordString(e: double.parse('2.5E-2').toString());
  collector.recordString(e: double.parse('.5').toString());
  collector.recordString(e: double.parse('2.').toString());
  collector.recordString(e: double.parse('0e500').toString());
  collector.recordBool(e: double.parse('1e1000000000').isInfinite);
  collector.recordBool(e: double.parse('Infinity').isInfinite);
  collector.recordBool(e: double.parse('-Infinity') == double.negativeInfinity);
  collector.recordBool(e: double.parse('NaN').isNaN);
  collector.recordBool(e: double.tryParse('invalid') == null);
  collector.recordBool(e: double.tryParse('inf') == null);
  collector.recordBool(e: double.tryParse('nan') == null);
  collector.recordBool(e: double.tryParse('') == null);
}

void _stringReplaceRangeAndCodeUnits(BaseResultCollector collector) {
  collector.recordString(e: 'hello world'.replaceRange(6, 11, 'dart'));
  collector.recordString(e: 'hello'.replaceRange(0, 0, '>'));
  collector.recordString(e: 'hello'.replaceRange(5, 5, '!'));
  final units = 'Dart!'.codeUnits;
  collector.recordInt(e: units.length);
  collector.recordInt(e: units[0]);
  collector.recordInt(e: units[4]);

  // Exercises both `stringToCodeUnits` and `doubleParseInfallible` in
  // `dart:convert`'s standalone `_StringParser`.
  final decoded = json.decode(
    '{"pi": 3.1415, "exp": 2.5e-2, "big": 1e20}',
  ) as Map<String, Object?>;
  collector.recordString(e: decoded['pi'].toString());
  collector.recordString(e: decoded['exp'].toString());
  collector.recordString(e: decoded['big'].toString());
}
