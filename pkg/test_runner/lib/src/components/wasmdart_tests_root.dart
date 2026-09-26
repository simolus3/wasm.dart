// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'wasmdart_tests.dart' as i1;

// ignore: import_internal_library
import r'dart:_wasm' as i2;

import r'package:meta/meta.dart' as i3;

@pragma("wasm:import", r"component._import0")
external i2.WasmVoid _import0(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import1")
external i2.WasmVoid _import1(i2.WasmF64 p0);
@pragma("wasm:import", r"component._import2")
external i2.WasmVoid _import2(i2.WasmI64 p0);
@pragma("wasm:import", r"component._import3")
external i2.WasmVoid _import3(i2.WasmI32 p0);

final class _Imported$0 implements i1.ResultCollector {
  const _Imported$0();
  @override
  void recordString({required String e}) {
    final tmp0 = i0.AllocatedString.allocateUtf16(e);
    _import0(tmp0.ptr, tmp0.packedLength);
    tmp0.free();
  }

  @override
  void recordDouble({required double e}) {
    _import1(i2.WasmF64.fromDouble(e));
  }

  @override
  void recordInt({required int e}) {
    _import2(i2.WasmI64.fromInt(e));
  }

  @override
  void recordBool({required bool e}) {
    _import3(i2.WasmI32.fromBool(e));
  }
}

late i1.TestedModule _unnamedExport1;

final class RootImports {
  const RootImports._();

  i1.ResultCollector get testsResultCollector => const _Imported$0();
}

@i3.RecordUse()
void rootComponent(i1.TestedModule Function(RootImports) defineComponent) {
  final res = defineComponent(const RootImports._());
  _unnamedExport1 = res;
}

@pragma('wasm:export', r'component_0')
i2.WasmI32 _component_0() {
  final tmp0 = _unnamedExport1.countTests();
  return i2.WasmI32.fromInt(tmp0);
}

@pragma('wasm:export', r'component_1')
i2.WasmVoid _component_1(i2.WasmI32 p0) {
  _unnamedExport1.invokeTest(number: p0.toIntUnsigned());
  return i2.WasmVoid();
}
