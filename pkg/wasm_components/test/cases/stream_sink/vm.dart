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

void testStreamSinkPartialWritesAndReaderDrop(BaseResultCollector collector) {
  collector.recordInt(e: 5);
  collector.recordInt(e: 10);
  collector.recordInt(e: 2);
  collector.recordInt(e: 3);
  collector.recordInt(e: 30);
  collector.recordInt(e: 50);
  collector.recordInt(e: 0);
  collector.recordBool(e: false);
  collector.recordInt(e: 1);
  collector.recordInt(e: 0);
  collector.recordBool(e: true);
}
