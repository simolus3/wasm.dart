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

@pragma('wasm:import', 'libc.dart_regexpCompile')
external WasmI32 dartRegexpCompile(
  WasmI32 patternPtr,
  WasmI32 patternLen,
  WasmI32 multiLine,
  WasmI32 caseSensitive,
  WasmI32 unicode,
  WasmI32 dotAll,
);

@pragma('wasm:import', 'libc.dart_regexpFree')
external WasmVoid dartRegexpFree(WasmI32 handle);

@pragma('wasm:import', 'libc.dart_regexpIsError')
external WasmI32 dartRegexpIsError(WasmI32 handle);

@pragma('wasm:import', 'libc.dart_regexpGetErrorPtr')
external WasmI32 dartRegexpGetErrorPtr(WasmI32 handle);

@pragma('wasm:import', 'libc.dart_regexpGetErrorLen')
external WasmI32 dartRegexpGetErrorLen(WasmI32 handle);

@pragma('wasm:import', 'libc.dart_regexpGetGroupCount')
external WasmI32 dartRegexpGetGroupCount(WasmI32 handle);

@pragma('wasm:import', 'libc.dart_regexpGetNamedGroupCount')
external WasmI32 dartRegexpGetNamedGroupCount(WasmI32 handle);

@pragma('wasm:import', 'libc.dart_regexpGetNamedGroupInfo')
external WasmI32 dartRegexpGetNamedGroupInfo(
  WasmI32 handle,
  WasmI32 namedIndex,
  WasmI32 outCaptureIndexPtr,
  WasmI32 outNameLenPtr,
);

@pragma('wasm:import', 'libc.dart_regexpMatch')
external WasmI32 dartRegexpMatch(
  WasmI32 handle,
  WasmI32 stringPtr,
  WasmI32 stringLen,
  WasmI32 startUtf16,
  WasmI32 asPrefix,
  WasmI32 outPtr,
);
