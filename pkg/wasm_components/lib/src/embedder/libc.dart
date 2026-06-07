// ignore: import_internal_library
import 'dart:_wasm';

@pragma('wasm:import', 'libc.memory')
@pragma('wasm:memory-type', MemoryType(limits: Limits(17)))
external Memory get memory;

@pragma('wasm:import', 'libc.dart_writeln')
external WasmVoid dartWriteln(WasmI32 length, WasmI32 ptr);

@pragma('wasm:import', 'libc.dart_realloc')
external WasmI32 dartRealloc(
  WasmI32 oldPtr,
  WasmI32 oldLen,
  WasmI32 align,
  WasmI32 newLen,
);

@pragma('wasm:import', 'libc.dart_free')
external WasmVoid dartFree(WasmI32 ptr, WasmI32 sizeInBytes, WasmI32 alignment);
