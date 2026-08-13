// ignore_for_file: type=warning
import r'demo_component.dart' as i0;

// ignore: import_internal_library
import r'dart:_wasm' as i1;

import r'package:wasm_components/wasm_components.dart' as i2;

late i0.Greeting _unnamedExport0;

final class RootImports {
  const RootImports._();
}

void rootComponent(i0.Greeting Function(RootImports) defineComponent) {
  final res = defineComponent(const RootImports._());
  _unnamedExport0 = res;
}

@pragma('wasm:export', r'component_0')
i1.WasmI32 _component_0() {
  final tmp0 = _unnamedExport0.generateGreeting();
  var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
  final tmp2 = i2.AllocatedString.allocateUtf16(tmp0);
  i2.memory.storeInt32(tmp1.toIntUnsigned(), tmp2.packedLength, offset: 4);
  i2.memory.storeInt32(tmp1.toIntUnsigned(), tmp2.ptr, offset: 0);
  return tmp1;
}

@pragma('wasm:export', r'component_0_postreturn')
i1.WasmVoid _component_0$postreturn(i1.WasmI32 p0) {
  final tmp0 = i2.memory.loadInt32(p0.toIntUnsigned(), offset: 0);
  final tmp1 = i2.memory.loadInt32(p0.toIntUnsigned(), offset: 4);
  i2.AllocatedString(tmp0, tmp1).free();
  i2.dartFree(p0, const i1.WasmI32(8), const i1.WasmI32(4));
  return i1.WasmVoid();
}
