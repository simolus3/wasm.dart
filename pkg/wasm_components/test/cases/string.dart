import 'dart:convert';

import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _emptyString,
    _stringLength,
    _stringRepeat,
    _lowerUpper,
    _utf8RoundTrip,
    _stringCompareAndReplace,
    _errorSafeToString,
    _lowerOptionalAndListStrings,
  ]);
}

void _emptyString(BaseResultCollector collector) {
  // Regression test for https://github.com/simolus3/wasm.dart/pull/9
  collector.recordString(e: '');
}

void _stringLength(BaseResultCollector collector) {
  collector.recordInt(e: 'Hello world'.length);
}

void _stringRepeat(BaseResultCollector collector) {
  collector.recordString(e: 'e' * 10);
}

void _lowerUpper(BaseResultCollector collector) {
  collector.recordString(e: 'Hello world'.toLowerCase());
  collector.recordString(e: 'Hello world'.toUpperCase());

  final alreadyLowerCase = 'hello world';
  collector.recordBool(
    e: identical(alreadyLowerCase.toLowerCase(), alreadyLowerCase),
  );

  final alreadyUpperCase = 'HELLO WORLD';
  collector.recordBool(
    e: identical(alreadyUpperCase.toUpperCase(), alreadyUpperCase),
  );
}

void _utf8RoundTrip(BaseResultCollector collector) {
  final encoded = utf8.encode('Hello, Wasm! 👋');
  collector.recordInt(e: encoded.length);
  collector.recordString(e: utf8.decode(encoded));
}

void _stringCompareAndReplace(BaseResultCollector collector) {
  collector
    ..recordBool(e: 'abc'.compareTo('abd') < 0)
    ..recordBool(e: 'abd'.compareTo('abc') > 0)
    ..recordBool(e: 'ab'.compareTo('abc') < 0)
    ..recordBool(e: 'abc'.compareTo('ab') > 0)
    ..recordInt(e: 'abc'.compareTo('abc'))
    ..recordString(e: 'Hello, world!'.replaceRange(7, 12, 'Dart'))
    ..recordString(e: 'Hello Dart'.replaceRange(0, 5, '👋'))
    ..recordString(e: 'a-b-a-c'.replaceAll('a', 'x'))
    ..recordString(e: 'ab'.replaceAll('', '|'))
    ..recordInt(e: 'Hi'.codeUnits.reduce((a, b) => a + b));
}

void _errorSafeToString(BaseResultCollector collector) {
  collector
    ..recordString(e: Error.safeToString(123))
    ..recordString(e: Error.safeToString('string'))
    ..recordString(e: Error.safeToString('"Hello world"'));
}

void _lowerOptionalAndListStrings(BaseResultCollector collector) {
  collector
    ..recordOptionalString(e: null)
    ..recordOptionalString(e: '')
    ..recordOptionalString(e: 'hello 👋')
    ..recordStringList(e: const [])
    ..recordStringList(e: const ['alpha', '', 'beta 👋', 'gamma']);
}
