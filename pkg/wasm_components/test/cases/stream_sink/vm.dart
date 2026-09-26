import 'package:test_runner/test_runner.dart';

void testStreamSinkDeferredDrop(BaseResultCollector collector) {
  collector.recordBool(e: false);
  collector.recordInt(e: 1);
  collector.recordBool(e: true);
}

void testStreamSinkBackpressure(BaseResultCollector collector) {
  collector.recordBool(e: true);
  collector.recordInt(e: 1);
  collector.recordBool(e: false);
  collector.recordInt(e: 2);
  collector.recordBool(e: false);
  collector.recordBool(e: true);
}
