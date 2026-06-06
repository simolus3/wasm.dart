// Exports functions imported by the Dart SDK in
// https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart.
// After invoking dart2wasm, we merge imports against these definitions.
library;

// ignore: import_internal_library
import 'dart:_wasm';

import 'constants.dart';
import 'number_format.dart';
import 'stack_trace.dart';
import 'string.dart';
import 'string_buffer.dart';
import 'tmp_print.dart';
import 'utils.dart';

@pragma('wasm:export')
WasmExternRef stringFromAsciiBytes(
  WasmArray<WasmI8> charCodes,
  WasmI32 start,
  WasmI32 length,
) {
  return WasmAnyRef.fromObject(
    Latin1String.fromAsciiBytes(charCodes, start, length),
  ).externalize();
}

@pragma('wasm:export')
WasmExternRef i64ToString(WasmI64 value, WasmI32 radix) {
  return intToString(value.toInt(), radix.toIntUnsigned()).externalize();
}

@pragma('wasm:export')
WasmExternRef f64ToString(WasmF64 value) {
  // TODO
  return $0.externalize();
}

@pragma('wasm:export')
WasmI32 stringLength(WasmExternRef? string) {
  return WasmStringImplementation.fromExtern(string).length.toWasmI32();
}

@pragma('wasm:export')
WasmExternRef stringBufferCreate() {
  return WasmStringBuffer().externalize();
}

@pragma('wasm:export')
WasmVoid stringBufferWriteString(WasmExternRef? buffer, WasmExternRef? string) {
  (buffer!.internalize().toObject() as WasmStringBuffer).writeString(
    WasmStringImplementation.fromExtern(string),
  );
  return WasmVoid();
}

@pragma('wasm:export')
WasmVoid stringBufferWriteCharCode(WasmExternRef? buffer, WasmI32 code) {
  (buffer!.internalize().toObject() as WasmStringBuffer).writeCharCode(
    code.toIntUnsigned(),
  );
  return WasmVoid();
}

@pragma('wasm:export')
WasmVoid stringBufferClear(WasmExternRef? buffer) {
  (buffer!.internalize().toObject() as WasmStringBuffer).clear();
  return WasmVoid();
}

@pragma('wasm:export')
WasmI32 stringBufferLength(WasmExternRef? buffer) {
  return (buffer!.internalize().toObject() as WasmStringBuffer).length
      .toWasmI32();
}

@pragma('wasm:export')
WasmExternRef stringBufferToString(WasmExternRef? buffer) {
  return (buffer!.internalize().toObject() as WasmStringBuffer)
      .renderToString()
      .externalize();
}

@pragma('wasm:export')
WasmExternRef stackTraceGetCurrent() {
  // WASI doesn't expose stack traces, so this is unimplemented.
  return const UnsupportedStackTrace().externalize();
}

@pragma('wasm:export')
WasmExternRef stackTraceToString(WasmExternRef? _) {
  return stackTracesAreUnavailableMessage.externalize();
}

@pragma('wasm:export')
WasmExternRef jsonEncodeString(WasmExternRef? line) {
  // TODO: Actually encode as JSON (not sure what exactly this even does).
  return line!;
}

@pragma('wasm:export')
WasmVoid debugger(WasmExternRef? message) {
  return WasmVoid();
}

@pragma('wasm:export', 'print')
WasmVoid wasiPrint(WasmExternRef? string) {
  printImpl(.fromExtern(string));
  return WasmVoid();
}
