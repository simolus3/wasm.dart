import 'dart:convert';

import 'testcase.dart';

void defineTests(List<TestCase> cases) {
  for (final (idx, run) in cases.indexed) {
    _printJson(serializeTestStart(idx));
    try {
      run(const _PrintRunner());
    } finally {
      _printJson(serializeTestEnd(idx));
    }
  }
}

void _printJson(Object obj) {
  print(json.encode(obj));
}

final class _PrintRunner implements BaseResultCollector {
  const _PrintRunner();

  @override
  void recordDouble({required double e}) {
    _printJson(serializeRecordedDouble(e));
  }

  @override
  void recordInt({required int e}) {
    _printJson(serializeRecordedInt(e));
  }

  @override
  void recordString({required String e}) {
    _printJson(serializeRecordedString(e));
  }
}
