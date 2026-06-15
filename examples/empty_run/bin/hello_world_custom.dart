// ignore: import_internal_library
import 'dart:_wasm';

// ignore: unused_import
import 'package:wasm_components/src/embedder/exports.dart';

void main() {}

@pragma('wasm:export', 'runCli')
WasmI32 cliEntrypoint() {
  return const WasmI32(1);
}
