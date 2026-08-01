A custom component used to print greetings.

## Compiling

To generate the hook and binding code, use

```
dart run wasm_tools witgen -i test.wit
```

To compile the app, run:

```
dart run wasm_tools compile bin/greeting.dart
```

## Running

To run the greeting component with wasmtime, use:

```
wasmtime --invoke 'generate-greeting()' bin/greeting.wasm
```
