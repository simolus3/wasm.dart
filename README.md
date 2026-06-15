# Dart WebAssembly tools

Tools to compile Dart programs to arbitrary WebAssembly targets (CLI applications, serverless runtimes, component model).
The goal is to get `wasmtime run dart_compiled_app.wasm` to work without further setup.

> [!NOTE]
> These tools are in development and can't handle much more than a hello world program at the moment.

## Approach

As a proof of concept, this currently targets WASI 0.1 as a runtime, linking helpers implemented in Rust (via `wasm32-wasip1`).
As a next step, we'll target arbitrary components and remove the Rust standard library (keeping only a no-std `wasm32-unknown-unknown`
target to implement e.g. math functions in WebAssembly).

Via the experimental `--standalone` mode, Dart can compile to WebAssembly with Dart-specific, documented [host imports](https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart).
The goal of this project is to:

1. Implement these host imports in WebAssembly, and link their definition into a WebAssembly module compiled by `dart2wasm` to remove the host import.
2. Later, track metadata around the compilation to lift `dart2wasm` modules into WebAssembly components.

Wherever reasonable, we want to write the WebAssembly implementation for step 1 in Dart. We do this by annotating methods with `@pragma('wasm:export')` and
then use a post-compilation link step that resolves imports against these definitions of the same module.

## Demo

Go to `pkg/wasm_components`, run `dart bin/transform_to_wasip1.dart`. This compiles
`example/hello_world.dart` to `example/app.wasm`.

Run `wasmtime run -W all-proposals=yes example/app.wasm` to run this app.
Note that no Dart-specific imports are required here!

## Status

This is a [full list of host imports](https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/wasm/standalone/embedder.dart) we need to implement.

__Legend__:

- 🎯: This can reasonably be implemented in Dart/WebAssembly without host imports.
- 📦: This requires a host import (a WASI proposal).
- 🛑: This is fundamentally unavailable and we can only provide stub imports.

| Method                                   | Implemented | Category | Notes                         |
|------------------------------------------|-------------|----------|-------------------------------|
| scheduleOnce                             |             | 📦        |                               |
| scheduleRepeated                         |             | 📦        |                               |
| queueMicrotask                           |             | 🎯        |                               |
| clearSchedule                            |             | 📦        |                               |
| currentTimeMicros                        |             | 📦        |                               |
| stringFromCharCodeArray                  |             | 🎯        |                               |
| stringFromAsciiBytes                     | ✅          | 🎯        |                               |
| stringLength                             |             | 🎯        |                               |
| stringEquals                             |             | 🎯        |                               |
| stringCompare                            |             | 🎯        |                               |
| stringCodeUnitAt                         |             | 🎯        |                               |
| stringIndexOfString                      |             | 🎯        |                               |
| stringLastIndexOfString                  |             | 🎯        |                               |
| stringReplaceAllString                   |             | 🎯        |                               |
| stringReplaceAllRegExp                   |             | 🎯        |                               |
| stringSubstring                          |             | 🎯        |                               |
| stringToLowerCase                        |             | 🎯        |                               |
| stringToUpperCase                        |             | 🎯        |                               |
| stringConcat                             |             | 🎯        |                               |
| stringRepeat                             |             | 🎯        |                               |
| stringReplaceRange                       |             | 🎯        |                               |
| stringToCodeUnits                        |             | 🎯        |                               |
| monotonicClockFrequency                  |             | 📦        |                               |
| monotonicClockTicks                      |             | 📦        |                               |
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
| doubleTryParse                           |             | 🎯        |                               |
| tryParseResultGetDouble                  |             | 🎯        |                               |
| doubleParseInfallible                    |             | 🎯        |                               |
| i64ToString                              | ✅          | 🎯        | Needs optimization for base10 |
| f64ToExponential                         |             | 🎯        |                               |
| f64ToExponentialWithFractionDigits       |             | 🎯        |                               |
| f64ToPrecision                           |             | 🎯        |                               |
| f64ToFixed                               |             | 🎯        |                               |
| f64ToString                              |             | 🎯        | Currently a stub              |
| stringBufferCreate                       | ✅          | 🎯        |                               |
| stringBufferWriteString                  | ✅          | 🎯        |                               |
| stringBufferWriteCharCode                | ✅          | 🎯        |                               |
| stringBufferClear                        | ✅          | 🎯        |                               |
| stringBufferLength                       | ✅          | 🎯        |                               |
| stringBufferToString                     | ✅          | 🎯        |                               |
| regexpCreateOrFailWithString             |             | 🎯        | See [what Kotlin does](https://github.com/JetBrains/kotlin/tree/master/libraries/stdlib/native-wasm/src/kotlin/text/regex)          |
| regexpIsRegexp                           |             | 🎯        |                               |
| regexpEscape                             |             | 🎯        |                               |
| regexpMatch                              |             | 🎯        |                               |
| regexpMatchGetStart                      |             | 🎯        |                               |
| regexpMatchGetEnd                        |             | 🎯        |                               |
| regexpMatchGetGroupCount                 |             | 🎯        |                               |
| regexpMatchGetGroup                      |             | 🎯        |                               |
| regexpMatchGetNamedGroups                |             | 🎯        |                               |
| regexpMatchGetGroupName                  |             | 🎯        |                               |
| regexpMatchGetGroupByName                |             | 🎯        |                               |
| timeZoneNameForClampedSeconds            |             | 📦        |                               |
| timeZoneOffsetInSecondsForClampedSeconds |             | 📦        |                               |
| mathPow                                  |             | 🎯        |                               |
| mathAtan2                                |             | 🎯        |                               |
| mathSin                                  |             | 🎯        |                               |
| mathCos                                  |             | 🎯        |                               |
| mathTan                                  |             | 🎯        |                               |
| mathAcos                                 |             | 🎯        |                               |
| mathAsin                                 |             | 🎯        |                               |
| mathAtan                                 |             | 🎯        |                               |
| mathExp                                  |             | 🎯        |                               |
| mathLog                                  |             | 🎯        |                               |
| randomInt                                |             | 📦        |                               |
| randomIntSecure                          |             | 📦        |                               |
| print                                    |             | 📦        | Currently a stub              |
| jsonEncodeString                         |             | 🎯        | Currently a stub              |
| debugger                                 |             | 🛑        |                               |
| inspect                                  |             | 🛑        |                               |
| dartTimelineStreamEnabled                |             | 🛑        |                               |
| reportTaskEvent                          |             | 🛑        |                               |
