// ignore: import_internal_library
import 'dart:_wasm';

@pragma('wasm:import', 'libc.memory')
@pragma('wasm:memory-type', MemoryType(limits: Limits(17)))
external Memory get memory;

@pragma('wasm:import', 'libc.dart_realloc')
external WasmI32 dartRealloc(
  WasmI32 oldPtr,
  WasmI32 oldLen,
  WasmI32 align,
  WasmI32 newLen,
);

WasmI32 mallocAligned(WasmI32 align, WasmI32 length) {
  const zero = WasmI32(0);
  return dartRealloc(zero, zero, align, length);
}

@pragma('wasm:import', 'libc.dart_free')
external WasmVoid dartFree(WasmI32 ptr, WasmI32 sizeInBytes, WasmI32 alignment);
