import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [_stringLength, _stringRepeat, _lowerUpper]);
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
