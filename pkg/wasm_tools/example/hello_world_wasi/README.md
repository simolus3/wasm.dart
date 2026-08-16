A "hello world" component based on `wasi:cli`, without any Dart-specific imports.

## Usage

From this directory, run `dart run wasm_tools compile bin/app.dart`.

Once you have compiled the app, run `wasmtime bin/app.wasm`.

To inspect types used in the component, run:

```
wasm-tools component wit bin/app.wasm
```
