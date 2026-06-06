// ignore: import_internal_library
import 'dart:_wasm';

extension ExternalizeObject on Object {
  WasmExternRef externalize() => WasmAnyRef.fromObject(this).externalize();
}
