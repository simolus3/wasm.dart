// ignore: import_internal_library
import 'dart:_wasm';

import 'libc.dart' as libc;

/// Writes a struct storing seconds and nanoseconds into the given address.
///
/// This import is replaced with a stub if [DateTime.now] isn't used to avoid
/// the import dependency.
@pragma('wasm:import', 'dart.wasi_now')
external WasmVoid wasiNowPtr(WasmI32 ptr);

int wasiTimestampInMicroseconds() {
  final instantPtr = libc.mallocAligned(const WasmI32(8), const WasmI32(16));
  wasiNowPtr(instantPtr);

  final address = instantPtr.toIntUnsigned();
  final seconds = libc.memory.loadInt64(address).toInt();
  final plusNanos = libc.memory
      .loadInt32(address, align: 1, offset: 8)
      .toIntUnsigned();
  final plusMicros = plusNanos ~/ 1000;
  libc.dartFree(instantPtr, const WasmI32(16), const WasmI32(8));

  return (seconds * 1_000_000) + plusMicros;
}
