import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _ascii,
    _latin1,
    _bmp,
    _astral,
    _surrogatePairs,
    _empty,
    _subRanges,
  ]);
}

void _ascii(BaseResultCollector collector) {
  collector.recordString(e: String.fromCharCodes([104, 101, 108, 108, 111]));
}

void _latin1(BaseResultCollector collector) {
  collector.recordString(e: String.fromCharCodes([0xe9, 0xfc, 0xdf]));
}

void _bmp(BaseResultCollector collector) {
  collector.recordString(e: String.fromCharCodes([0x03a9, 0x4e2d]));
}

void _astral(BaseResultCollector collector) {
  collector.recordString(e: String.fromCharCodes([0x1f600]));
}

void _surrogatePairs(BaseResultCollector collector) {
  // The emoji 😀 is stored as a surrogate pair.
  collector.recordString(e: String.fromCharCodes([0xd83d, 0xde00]));
  collector.recordString(e: 'a${String.fromCharCodes([0xd83d, 0xde00])}b');
}

void _empty(BaseResultCollector collector) {
  collector.recordString(e: String.fromCharCodes(<int>[]));
}

void _subRanges(BaseResultCollector collector) {
  const codes = [0x78, 0x41, 0x1f600, 0x42, 0x79];
  collector.recordString(e: String.fromCharCodes(codes, 1, 4));
  collector.recordString(e: String.fromCharCodes(codes, 3));
  collector.recordString(e: String.fromCharCodes(codes, 2, 2));
}
