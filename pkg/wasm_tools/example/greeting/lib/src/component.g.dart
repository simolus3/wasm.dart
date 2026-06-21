// ignore_for_file: type=warning
// ignore: import_internal_library
import r'dart:_wasm' as i0;
import r'package:wasm_components/component.dart' as i1;

abstract interface class Greeting {
  String generateGreeting();
}

late Greeting _unnamedExport0;
void defineInstanceExport({required Greeting unnamedExport0}) {
  _unnamedExport0 = unnamedExport0;
}

@pragma('wasm:export', r'component_0')
i0.WasmI32 _component_0() {
  final tmp0 = _unnamedExport0.generateGreeting();
  var tmp1 = i1.mallocAligned(const i0.WasmI32(4), const i0.WasmI32(8));
  final tmp2 = i1.AllocatedString.allocateUtf16(tmp0);
  i1.memory.storeInt32(tmp1.toIntUnsigned(), tmp2.packedLength, offset: 4);
  i1.memory.storeInt32(tmp1.toIntUnsigned(), tmp2.ptr, offset: 0);
  return tmp1;
}

@pragma('wasm:export', r'component_0_postreturn')
i0.WasmVoid _component_0$postreturn(i0.WasmI32 p0) {
  final tmp0 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 0);
  final tmp1 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 4);
  i1.AllocatedString(tmp0, tmp1).free();
  i1.dartFree(p0, const i0.WasmI32(8), const i0.WasmI32(4));
  return i0.WasmVoid();
}
