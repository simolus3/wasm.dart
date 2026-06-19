// ignore: import_internal_library
import 'dart:_wasm';

import 'package:wasm_components/component.dart';

@pragma('wasm:import', r'component.Print$print')
external WasmVoid _import$Print$print(
  WasmI32 line$ptr,
  WasmI32 line$packedLength,
);

@pragma('wasm:export', r'cli$run')
// ignore: unused_element
WasmI32 _cliRun() {
  final result = _runInstance.run();

  WasmI32 encodedResult;
  switch (result) {
    case OkResult():
      encodedResult = const WasmI32(0);
    case ErrorResult():
      encodedResult = const WasmI32(1);
  }

  return encodedResult;
}

final class Print {
  const Print._();

  void print(String message) {
    final str = AllocatedString.allocateUtf16(message);
    _import$Print$print(str.ptr, str.packedLength);
    str.free();
  }
}

const printImport = Print._();

abstract interface class WasiCliRun {
  Result<Null, Null> run();
}

late WasiCliRun _runInstance;

void defineInstanceExport(WasiCliRun instance) {
  _runInstance = instance;
}
