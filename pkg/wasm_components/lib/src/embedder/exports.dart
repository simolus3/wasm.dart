// Exports functions imported by the Dart SDK in
// https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart.
// After invoking dart2wasm, we merge imports against these definitions.
library;

// ignore: import_internal_library
import 'dart:_wasm';

import '../runtime/async/task.dart';
import 'clock.dart';
import 'constants.dart';
import 'number_format.dart';
import 'stack_trace.dart';
import 'string.dart';
import 'string_buffer.dart';
import 'tmp_print.dart';
import 'utils.dart';

Never _unsupportedAsyncSchedule() {
  throw StateError('Tried to schedule async operation, outside of async task.');
}

@pragma('wasm:export')
WasmExternRef scheduleOnce(
  WasmI64 delay,
  WasmFunction<WasmVoid Function(WasmAnyRef)> callback,
  WasmAnyRef arg,
) {
  _unsupportedAsyncSchedule();
}

@pragma('wasm:export')
WasmExternRef scheduleRepeated(
  WasmI64 interval,
  WasmFunction<WasmVoid Function(WasmAnyRef)> callback,
  WasmAnyRef arg,
) {
  _unsupportedAsyncSchedule();
}

@pragma('wasm:export')
WasmVoid queueMicrotask(
  WasmFunction<WasmVoid Function(WasmAnyRef)> callback,
  WasmAnyRef arg,
) {
  // Ideally, this should not get called as all async work happens in a task
  // zone overriding scheduleMicrotask.
  // However, the Dart SDK uses a null future instance used in some cases:
  // https: //github.com/dart-lang/sdk/blob/f300393bdf6136f4be35d877763ab73c7c715647/sdk/lib/internal/internal.dart#L140-L160
  // To support that, schedule that on the last that ran.
  final task = Task.forCurrentThreadUnchecked();
  if (task != null) {
    task.scheduleRawMicrotask(() {
      callback.call(arg);
    });
    return WasmVoid();
  }

  _unsupportedAsyncSchedule();
}

@pragma('wasm:export')
WasmVoid clearSchedule(WasmExternRef? schedule) {
  _unsupportedAsyncSchedule();
}

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
WasmExternRef stringFromCharCodeArray(
  WasmArray<WasmI16> charCodes,
  WasmI32 start,
  WasmI32 length,
) {
  return WasmAnyRef.fromObject(
    Utf16String.fromCharCodes(charCodes, start, length),
  ).externalize();
}

@pragma('wasm:export')
WasmExternRef i64ToString(WasmI64 value, WasmI32 radix) {
  return intToString(value.toInt(), radix.toIntUnsigned()).externalize();
}

@pragma('wasm:export')
WasmExternRef f64ToString(WasmF64 value) {
  throw UnimplementedError('f64ToString');
}

@pragma('wasm:export')
WasmI32 stringLength(WasmExternRef? string) {
  return WasmStringImplementation.fromExtern(string).length.toWasmI32();
}

@pragma('wasm:export')
WasmI32 stringEquals(WasmExternRef? a, WasmExternRef? b) {
  return WasmI32.fromBool(
    WasmStringImplementation.fromExtern(a)
        .stringEquals(WasmStringImplementation.fromExtern(b)),
  );
}

@pragma('wasm:export')
WasmI32 stringCompare(WasmExternRef? a, WasmExternRef? b) {
  return WasmStringImplementation.fromExtern(a)
      .compareTo(WasmStringImplementation.fromExtern(b));
}

@pragma('wasm:export')
WasmI32 stringCodeUnitAt(WasmExternRef? string, WasmI32 index) {
  final wasmString = WasmStringImplementation.fromExtern(string);
  return WasmI32.fromInt(wasmString.codeUnitAtUnchecked(index.toIntUnsigned()));
}

@pragma('wasm:export')
WasmExternRef? stringSubstring(
  WasmExternRef? string,
  WasmI32 start,
  WasmI32 end,
) {
  return WasmStringImplementation.fromExtern(string)
      .substring(start, end)
      .externalize();
}

@pragma('wasm:export')
WasmI32 stringIndexOfString(WasmExternRef? a, WasmExternRef? b, WasmI32 start) {
  return WasmI32.fromInt(
    WasmStringImplementation.fromExtern(a).indexOfString(
      WasmStringImplementation.fromExtern(b),
      start.toIntSigned(),
    ),
  );
}

@pragma('wasm:export')
WasmI32 stringLastIndexOfString(
  WasmExternRef? a,
  WasmExternRef? b,
  WasmI32 start,
) {
  return WasmI32.fromInt(
    WasmStringImplementation.fromExtern(a).lastIndexOfString(
      WasmStringImplementation.fromExtern(b),
      start.toIntSigned(),
    ),
  );
}

@pragma('wasm:export')
WasmExternRef? stringToLowerCase(WasmExternRef? string) {
  return WasmStringImplementation.fromExtern(string).toLower().externalize();
}

@pragma('wasm:export')
WasmExternRef? stringToUpperCase(WasmExternRef? string) {
  return WasmStringImplementation.fromExtern(string).toUpper().externalize();
}

@pragma('wasm:export')
WasmExternRef? stringConcat(WasmExternRef? a, WasmExternRef? b) {
  return WasmStringImplementation.fromExtern(a)
      .concat(WasmStringImplementation.fromExtern(b))
      .externalize();
}

@pragma('wasm:export')
WasmExternRef? stringRepeat(WasmExternRef? string, WasmI32 amount) {
  final wasmString = WasmStringImplementation.fromExtern(string);
  return wasmString.repeat(amount.toIntSigned()).externalize();
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

@pragma('wasm:export', 'randomInt')
WasmI64 randomInt() {
  // Note: This function is recognized by the component compiler, which will add
  // a dependency on wasi:random/insecure to replace this function with a
  // get-insecure-random-u64 import.
  throw UnsupportedError('wasi:random/insecure not available');
}

@pragma('wasm:export', 'randomIntSecure')
WasmI64 randomIntSecure() {
  // Note: This function is recognized by the component compiler, which will add
  // a dependency on wasi:random/insecure to replace this function with a
  // get-random-u64 import.
  throw UnsupportedError('wasi:random/random not available');
}

@pragma('wasm:export', 'currentTime')
WasmI64 currentTimeMicros() {
  return WasmI64.fromInt(wasiTimestampInMicroseconds());
}

@pragma("wasm:export", "timeZoneNameForClampedSeconds")
WasmExternRef timeZoneNameForClampedSeconds(WasmI64 secondsSinceEpoch) {
  // We can't get the time zone name without including a tz db in our modules.
  // Instead, we return the (time-independent) id of the time zone.
  return wasiIanaId().externalize();
}

@pragma('wasm:export', 'timeZoneOffsetInSecondsForClampedSeconds')
WasmI32 timeZoneOffsetInSecondsForClampedSeconds(WasmI64 secondsSinceEpoch) {
  return const WasmI32(0);
}

@pragma('wasm:export', 'monotonicClockFrequency')
WasmI32 monotonicClockFrequency() {
  return dartStopwatchTickFrequency.toWasmI32();
}

@pragma('wasm:export', 'monotonicClockTicks')
WasmI64 monotonicClockTicks() {
  return dartMonotonicTicks.toWasmI64();
}
