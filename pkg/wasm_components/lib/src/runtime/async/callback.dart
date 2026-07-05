// ignore: import_internal_library
import 'dart:_wasm';

import 'package:meta/meta.dart';

import 'task.dart';
import 'waitable.dart';

@pragma('wasm:export')
WasmI32 callback(WasmI32 eventCode, WasmI32 p1, WasmI32 p2) {
  final task = taskForCurrentThread();
  dispatchEvent(task, eventCode, p1, p2);
  return task.finishEventLoopIteration().toWasmI32();
}

@internal
enum CallbackCode {
  exit,
  yield,
  wait;

  int packResult([WaitableSet? waitingOn]) {
    // see unpack_callback_result in the canonical abi for details.
    var code = index;
    // Encode the index of a waitable set in the upper 28 bits.
    if (waitingOn != null) {
      code |= (waitingOn.nativeId << 4);
    }

    return code;
  }
}
