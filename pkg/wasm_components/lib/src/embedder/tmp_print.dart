// ignore: import_internal_library
import 'dart:_wasm';

@pragma('wasm:import', 'libc.memory')
@pragma('wasm:memory-type', MemoryType(limits: Limits(1, 2)))
external Memory get memory;
