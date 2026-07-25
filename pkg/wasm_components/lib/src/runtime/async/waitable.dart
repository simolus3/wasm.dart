// ignore: import_internal_library
import 'dart:_wasm';

@pragma('wasm:import', 'component.canon.waitable-set.new')
external WasmI32 _waitableSetNew();
@pragma('wasm:import', 'component.canon.waitable-set.drop')
external WasmI32 _waitableSetDrop(WasmI32 set);
@pragma('wasm:import', 'component.canon.waitable.join')
external WasmVoid _waitableJoin(WasmI32 waitable, WasmI32 set);

final class WaitableSet {
  final WasmI32 _nativeId = _waitableSetNew();

  int get nativeId => _nativeId.toIntUnsigned();

  void drop() {
    _waitableSetDrop(_nativeId);
  }

  void addWaitable(WasmI32 index) {
    _waitableJoin(index, _nativeId);
  }
}

/// A component model [event code](https://github.com/WebAssembly/component-model/blob/main/design/mvp/CanonicalABI.md#waitable-state).
enum EventCode {
  none,
  subtask,
  streamRead,
  streamWrite,
  futureRead,
  futureWrite,
  taskCancelled,
}

const blockedCode = 0xffff_ffff;
