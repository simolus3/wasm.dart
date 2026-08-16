A simple http server, exposed as a `wasi:http/service` component without any Dart-specific imports.

## Usage

From this directory, run `dart run wasm_tools compile bin/app.dart`.

Once you have compiled the app, run `wasmtime serve bin/app.wasm`.
