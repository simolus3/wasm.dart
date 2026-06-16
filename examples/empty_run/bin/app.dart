// ignore: import_internal_library
import 'dart:_wasm';

// ignore: unused_import
import 'package:wasm_components/src/embedder/exports.dart';

void main() {}

@pragma('wasm:import', 'component.myExitImport')
external WasmVoid exit(WasmI32 result);

@pragma('wasm:export', 'runCli')
WasmI32 cliEntrypoint() {
  // As defined in hook/build.dart, this method is declared to have a signature
  // of (func (return (result))) in the component model.
  // According to the canonical ABI, a 0 is interpreted as okay and a 1 is
  // interpreted as an error.
  exit(const WasmI32(1));

  return const WasmI32(0);
}
