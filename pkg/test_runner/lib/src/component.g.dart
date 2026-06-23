// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;
// ignore: import_internal_library
import r'dart:_wasm' as i1;

abstract interface class ResultCollector {
  void recordString({required String e});
  void recordDouble({required double e});
  void recordInt({required int e});
}

@pragma("wasm:import", r"component._import0")
external i1.WasmVoid _import0(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import1")
external i1.WasmVoid _import1(i1.WasmF64 p0);
@pragma("wasm:import", r"component._import2")
external i1.WasmVoid _import2(i1.WasmI64 p0);

final class _Imported$ResultCollector implements ResultCollector {
  const _Imported$ResultCollector();
  @override
  void recordString({required String e}) {
    final tmp0 = i0.AllocatedString.allocateUtf16(e);
    _import0(tmp0.ptr, tmp0.packedLength);
    tmp0.free();
  }

  @override
  void recordDouble({required double e}) {
    _import1(i1.WasmF64.fromDouble(e));
  }

  @override
  void recordInt({required int e}) {
    _import2(i1.WasmI64.fromInt(e));
  }
}

const importedInstance0 = _Imported$ResultCollector();

abstract interface class TestedModule {
  int countTests();
  void invokeTest({required int number});
}

late TestedModule _unnamedExport1;
void defineInstanceExport({required TestedModule unnamedExport1}) {
  _unnamedExport1 = unnamedExport1;
}

@pragma('wasm:export', r'component_0')
i1.WasmI32 _component_0() {
  final tmp0 = _unnamedExport1.countTests();
  return i1.WasmI32.fromInt(tmp0);
}

@pragma('wasm:export', r'component_1')
i1.WasmVoid _component_1(i1.WasmI32 p0) {
  _unnamedExport1.invokeTest(number: p0.toIntUnsigned());
  return i1.WasmVoid();
}
