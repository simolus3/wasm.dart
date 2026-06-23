import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [_stringLength, _stringRepeat]);
}

void _stringLength(BaseResultCollector collector) {
  collector.recordInt(e: 'Hello world'.length);
}

void _stringRepeat(BaseResultCollector collector) {
  collector.recordString(e: 'e' * 10);
}
