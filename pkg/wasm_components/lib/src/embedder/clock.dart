// ignore: import_internal_library
import 'dart:_wasm';

import 'constants.dart';
import 'libc.dart' as libc;
import 'string.dart';

/// Writes a struct storing seconds and nanoseconds into the given address.
///
/// This import is replaced with a stub if [DateTime.now] isn't used to avoid
/// the import dependency.
@pragma('wasm:import', 'dart.wasi_now')
external WasmVoid wasiNowPtr(WasmI32 ptr);

@pragma('wasm:import', 'dart.wasi_iana_id')
external WasmVoid rawIanaId(WasmI32 ptr);

int wasiTimestampInMicroseconds() {
  final instantPtr = libc.mallocAligned(const WasmI32(8), const WasmI32(16));
  wasiNowPtr(instantPtr);

  final address = instantPtr.toIntUnsigned();
  final seconds = libc.memory.loadInt64(address, align: 3).toInt();
  final plusNanos = libc.memory
      .loadInt32(address, align: 2, offset: 8)
      .toIntUnsigned();
  final plusMicros = plusNanos ~/ 1000;
  libc.dartFree(instantPtr, const WasmI32(16), const WasmI32(8));

  return (seconds * 1_000_000) + plusMicros;
}

WasmStringImplementation wasiIanaId() {
  // wasmtime doesn't seem to implement time zones yet :(
  return unknownTimezone;
  // final namePtr = libc.mallocAligned(const WasmI32(4), const WasmI32(12));
  // rawIanaId(namePtr);

  // final addr = namePtr.toIntUnsigned();
  // final hasName = libc.memory.loadUint8(addr);
  // final WasmStringImplementation result;
  // if (hasName.toBool()) {
  //   final ptr = libc.memory.loadInt32(addr, offset: 4);
  //   final length = libc.memory.loadInt32(addr, offset: 8);

  //   final allocated = AllocatedString(ptr, length);
  //   result = allocated.readRaw();
  //   allocated.free();
  // } else {
  //   result = unknownTimezone;
  // }

  // libc.dartFree(namePtr, const WasmI32(12), const WasmI32(4));
  // return result;
}
