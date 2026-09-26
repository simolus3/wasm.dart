# Dart WebAssembly components

Tools to compile Dart programs and packages to [WebAssembly components](https://component-model.bytecodealliance.org/),
allowing them to run as CLI applications, servers and more targets with compatible runtimes.

The goal is to get `wasmtime run dart_compiled_app.wasm` to work without further setup.

> [!NOTE]
> These tools are still in development and not ready for production. Please file issues for problems you run into!

## Approach

Via the experimental `--standalone` mode, Dart can compile to WebAssembly with Dart-specific, documented [host imports](https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart).
The goal of this project is to:

1. Implement these host imports in WebAssembly, and link their definition into compiled Dart apps to remove the host import.
2. Track metadata around the compilation to lift `dart2wasm` modules into WebAssembly components.

Wherever reasonable, we want to write the WebAssembly implementation for step 1 in Dart. We do this by annotating methods with `@pragma('wasm:export')` and
then use a post-compilation link step that resolves imports against these definitions of the same module.

The main packages in this repository are:

1. `wasm_tools`: CLI tools to generate wit bindings from Dart and to compile Dart to components.
2. `wasm_components`: Dart runtime for the component model.

## Demo

Go to `examples/hello_world_custom`, run `dart run wasm_tools compile bin/app.dart`. This compiles
`bin/app.dart` to `bin/app.wasm`.

Run `cargo run` to run this app with Wasmtime.

## Status

This is a [full list of host imports](https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart) we need to implement.

__Legend__:

- 🎯: This can reasonably be implemented in Dart/WebAssembly without host imports.
- 📦: This requires a host import (a WASI proposal).
- 🛑: This is fundamentally unavailable and we can only provide stub imports.

| Method                                   | Implemented | Category | Notes                         |
|------------------------------------------|-------------|----------|-------------------------------|
| scheduleOnce                             | ✅          | 📦        |                               |
| scheduleRepeated                         | ✅          | 📦        |                               |
| queueMicrotask                           | ✅          | 🎯        |                               |
| clearSchedule                            | ✅          | 📦        |                               |
| currentTimeMicros                        | ✅          | 📦        |                               |
| stringFromCharCodeArray                  | ✅          | 🎯        |                               |
| stringFromAsciiBytes                     | ✅          | 🎯        |                               |
| stringLength                             | ✅          | 🎯        |                               |
| stringEquals                             | ✅          | 🎯        |                               |
| stringCompare                            | ✅          | 🎯        |                               |
| stringCodeUnitAt                         | ✅          | 🎯        |                               |
| stringIndexOfString                      | ✅          | 🎯        |                               |
| stringLastIndexOfString                  | ✅          | 🎯        |                               |
| stringReplaceAllString                   | ✅          | 🎯        |                               |
| stringReplaceAllRegExp                   | ✅          | 🎯        |                               |
| stringSubstring                          | ✅          | 🎯        |                               |
| stringToLowerCase                        | ✅          | 🎯        |                               |
| stringToUpperCase                        | ✅          | 🎯        |                               |
| stringConcat                             | ✅          | 🎯        |                               |
| stringRepeat                             | ✅          | 🎯        |                               |
| stringReplaceRange                       | ✅          | 🎯        |                               |
| stringToCodeUnits                        | ✅          | 🎯        |                               |
| monotonicClockFrequency                  | ✅          | 📦        |                               |
| monotonicClockTicks                      | ✅          | 📦        |                               |
| weakRefCreate                            |             | 🛑        |                               |
| weakRefGet                               |             | 🛑        |                               |
| expandoCreate                            |             | 🛑        |                               |
| expandoGet                               |             | 🛑        |                               |
| expandoSet                               |             | 🛑        |                               |
| finalizerCreate                          |             | 🛑        |                               |
| finalizerAttach                          |             | 🛑        |                               |
| finalizerDetach                          |             | 🛑        |                               |
| baseUri                                  |             | 📦        |                               |
| isWindows                                |             | 📦        |                               |
| stackTraceGetCurrent                     | ✅          | 🛑        | Impossible, stub used         |
| stackTraceToString                       | ✅          | 🛑        | Impossible, stub used         |
| doubleTryParse                           | ✅          | 🎯        |                               |
| tryParseResultGetDouble                  | ✅          | 🎯        |                               |
| doubleParseInfallible                    | ✅          | 🎯        |                               |
| i64ToString                              | ✅          | 🎯        | Needs optimization for base10 |
| f64ToExponential                         |             | 🎯        |                               |
| f64ToExponentialWithFractionDigits       |             | 🎯        |                               |
| f64ToPrecision                           |             | 🎯        |                               |
| f64ToFixed                               |             | 🎯        |                               |
| f64ToString                              | ✅          | 🎯        |                               |
| stringBufferCreate                       | ✅          | 🎯        |                               |
| stringBufferWriteString                  | ✅          | 🎯        |                               |
| stringBufferWriteCharCode                | ✅          | 🎯        |                               |
| stringBufferClear                        | ✅          | 🎯        |                               |
| stringBufferLength                       | ✅          | 🎯        |                               |
| stringBufferToString                     | ✅          | 🎯        |                               |
| regexpCreateOrFailWithString             | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpIsRegexp                           | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpEscape                             | ✅          | 🎯        |                               |
| regexpMatch                              | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetStart                      | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetEnd                        | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetGroupCount                 | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetGroup                      | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetNamedGroups                | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetGroupName                  | ✅          | 🎯        | Using `regex` crate in Rust.  |
| regexpMatchGetGroupByName                | ✅          | 🎯        | Using `regex` crate in Rust.  |
| timeZoneNameForClampedSeconds            |             | 📦        | Unimplemented in wasmtime     |
| timeZoneOffsetInSecondsForClampedSeconds |             | 📦        | Unimplemented in wasmtime     |
| mathPow                                  | ✅          | 🎯        | Using `libm` in Rust.         |
| mathAtan2                                | ✅          | 🎯        | Using `libm` in Rust.         |
| mathSin                                  | ✅          | 🎯        | Using `libm` in Rust.         |
| mathCos                                  | ✅          | 🎯        | Using `libm` in Rust.         |
| mathTan                                  | ✅          | 🎯        | Using `libm` in Rust.         |
| mathAcos                                 | ✅          | 🎯        | Using `libm` in Rust.         |
| mathAsin                                 | ✅          | 🎯        | Using `libm` in Rust.         |
| mathAtan                                 | ✅          | 🎯        | Using `libm` in Rust.         |
| mathExp                                  | ✅          | 🎯        | Using `libm` in Rust.         |
| mathLog                                  | ✅          | 🎯        | Using `libm` in Rust.         |
| randomInt                                | ✅          | 📦        |                               |
| randomIntSecure                          | ✅          | 📦        |                               |
| print                                    |             | 📦        | Currently a stub              |
| jsonEncodeString                         |             | 🎯        | Currently a stub              |
| debugger                                 |             | 🛑        |                               |
| inspect                                  |             | 🛑        |                               |
| dartTimelineStreamEnabled                |             | 🛑        |                               |
| reportTaskEvent                          |             | 🛑        |                               |
