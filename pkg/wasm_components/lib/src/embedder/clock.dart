// ignore: import_internal_library
import 'dart:_wasm';

import 'libc.dart' as libc;

/// Returns a pointer to a struct storing seconds (s64) and nanoseconds (u32).
///
/// This import is replaced with a stub if [DateTime.now] isn't used to avoid
/// the import dependency.
@pragma('wasm:import', 'dart.wasi_now')
external WasmI32 wasiNowPtr();

int wasiTimestampInMicroseconds() {
  final ptr = wasiNowPtr();
  final address = ptr.toIntUnsigned();
  final seconds = 0; //memory.loadInt64(address).toInt();
  final plusNanos = libc.memory
      .loadInt32(address, align: 1, offset: 8)
      .toIntUnsigned();
  final plusMicros = plusNanos ~/ 1000;
  libc.dartFree(ptr, const WasmI32(12), const WasmI32(8));

  return (seconds * 1_000_000) + plusMicros;
}
