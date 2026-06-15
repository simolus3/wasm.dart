The tiniest possible component model, compiled via dart2wasm and a custom component transformer.

## Usage

From this repository, run `dart run wasm_components compile bin/app.dart`.
Note that the compiler currently compiles a helper library written in Rust (which
will eventually be used to allocate linear memory and to implement math builtins).
This requires a nightly Rust toolchain with the `wasm32-unknown-unknown` target to
be installed (see `pkg/wasm_components/lib/src/compiler/subprocess.dart` for the
cargo invocation).

Once you have compiled the app, run `wasmtime -W all-proposals=yes bin/app.wasm`.
If you want to, change `cliEntrypoint` to return `const WasmI32(1)`.
Compile and run again, the exit code should be 1 this time.

To inspect types used in the component, run:

```
wasm-tools component wit bin/app.wasm
```

Note how this matches the types in `build/hook.dart`.
