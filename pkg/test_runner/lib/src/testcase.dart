abstract interface class BaseResultCollector {
  void recordString({required String e});
  void recordDouble({required double e});
  void recordInt({required int e});
}

typedef TestCase = void Function(BaseResultCollector collector);

Object serializeTestStart(int number) {
  return {'type': 'start', 'test': number};
}

Object serializeTestEnd(int number) {
  return {'type': 'end', 'test': number};
}

Object serializeRecordedString(String e) {
  return {'type': 'string', 'value': e};
}

Object serializeRecordedDouble(double e) {
  return {'type': 'double', 'value': e};
}

Object serializeRecordedInt(int e) {
  return {'type': 'int', 'value': e};
}
