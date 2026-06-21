// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;
// ignore: import_internal_library
import r'dart:_wasm' as i1;

/// Component that can print stuff.
abstract interface class Print {
  /// Prints a message to stdout.
  void print({required String line});
}

@pragma("wasm:import", r"component._import0")
external i1.WasmVoid _import0(i1.WasmI32 p0, i1.WasmI32 p1);

final class _Imported$Print implements Print {
  const _Imported$Print();
  @override
  void print({required String line}) {
    final tmp0 = i0.AllocatedString.allocateUtf16(line);
    _import0(tmp0.ptr, tmp0.packedLength);
    tmp0.free();
  }
}

const importedInstance0 = _Imported$Print();

abstract interface class Run {
  i0.Result<void, void> run();
}

late Run _unnamedExport1;
void defineInstanceExport({required Run unnamedExport1}) {
  _unnamedExport1 = unnamedExport1;
}

@pragma('wasm:export', r'component_0')
i1.WasmI32 _component_0() {
  final tmp0 = _unnamedExport1.run();
  i1.WasmI32 tmp1;
  switch (tmp0) {
    case i0.OkResult(:final value):
      tmp1 = const i1.WasmI32(0);
    case i0.ErrorResult(:final value):
      tmp1 = const i1.WasmI32(1);
  }
  return tmp1;
}
