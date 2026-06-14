// ignore: import_internal_library
import 'dart:_wasm';

void main() {}

@pragma('wasm:export', 'runCli')
WasmI32 cliEntrypoint() {
  return const WasmI32(0);
}
