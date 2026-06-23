import 'component.g.dart';
import 'testcase.dart';

void defineTests(List<TestCase> cases) {
  defineInstanceExport(unnamedExport1: _ExportTestModule(cases));
}

final class _ImportedCollector implements BaseResultCollector {
  const _ImportedCollector();

  @override
  void recordDouble({required double e}) {
    importedInstance0.recordDouble(e: e);
  }

  @override
  void recordInt({required int e}) {
    importedInstance0.recordInt(e: e);
  }

  @override
  void recordString({required String e}) {
    importedInstance0.recordString(e: e);
  }
}

final class _ExportTestModule implements TestedModule {
  final List<TestCase> cases;

  new(this.cases);

  @override
  int countTests() => cases.length;

  @override
  void invokeTest({required int number}) {
    cases[number](const _ImportedCollector());
  }
}
