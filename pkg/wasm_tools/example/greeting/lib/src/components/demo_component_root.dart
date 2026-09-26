// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'demo_component.dart' as i1;

import r'package:meta/meta.dart' as i2;

// ignore: import_internal_library
import r'dart:_wasm' as i3;

late i1.Greeting _unnamedExport0;

final class RootImports {
  const RootImports._();
}

@i2.RecordUse()
void rootComponent(i1.Greeting Function(RootImports) defineComponent) {
  final res = defineComponent(const RootImports._());
  _unnamedExport0 = res;
}

@pragma('wasm:export', r'component_0')
i3.WasmI32 _component_0() {
  final tmp0 = _unnamedExport0.generateGreeting();
  var tmp1 = i0.mallocAligned(const i3.WasmI32(4), const i3.WasmI32(8));
  final tmp2 = i0.AllocatedString.allocateUtf16(tmp0);
  i0.memory.storeInt32(tmp1.toIntUnsigned(), tmp2.packedLength, offset: 4);
  i0.memory.storeInt32(tmp1.toIntUnsigned(), tmp2.ptr, offset: 0);
  return tmp1;
}

@pragma('wasm:export', r'component_0_postreturn')
i3.WasmVoid _component_0$postreturn(i3.WasmI32 p0) {
  final tmp0 = i0.memory.loadInt32(p0.toIntUnsigned(), offset: 0);
  final tmp1 = i0.memory.loadInt32(p0.toIntUnsigned(), offset: 4);
  i0.AllocatedString(tmp0, tmp1).free();
  i0.dartFree(p0, const i3.WasmI32(8), const i3.WasmI32(4));
  return i3.WasmVoid();
}
