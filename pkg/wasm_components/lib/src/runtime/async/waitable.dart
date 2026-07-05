// ignore: import_internal_library
import 'dart:_wasm';

@pragma('wasm:import', 'component.canon.waitable-set.new')
external WasmI32 _waitableSetNew();
@pragma('wasm:import', 'component.canon.waitable-set.drop')
external WasmI32 _waitableSetDrop(WasmI32 set);

final class WaitableSet {
  final WasmI32 _nativeId = _waitableSetNew();

  int get nativeId => _nativeId.toIntUnsigned();

  void drop() {
    _waitableSetDrop(_nativeId);
  }
}
