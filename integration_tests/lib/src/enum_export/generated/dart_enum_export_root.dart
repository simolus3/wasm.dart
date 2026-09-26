// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'dart_enum_export.dart' as i1;

import r'package:meta/meta.dart' as i2;

// ignore: import_internal_library
import r'dart:_wasm' as i3;

late i1.Calculate _unnamedExport0;

final class RootImports {
  const RootImports._();
}

@i2.RecordUse()
void rootComponent(i1.Calculate Function(RootImports) defineComponent) {
  final res = defineComponent(const RootImports._());
  _unnamedExport0 = res;
}

@pragma('wasm:export', r'component_0')
i3.WasmI32 _component_0(i3.WasmI32 p0, i3.WasmI32 p1, i3.WasmI32 p2) {
  final tmp0 = _unnamedExport0.evalExpression(
    op: i1.CalculateOp.values[p0.toIntUnsigned()],
    x: p1.toIntUnsigned(),
    y: p2.toIntUnsigned(),
  );
  return i3.WasmI32.fromInt(tmp0);
}
