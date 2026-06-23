import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [_stringLength]);
}

void _stringLength(BaseResultCollector collector) {
  collector.recordInt(e: 'Hello world'.length);
}
