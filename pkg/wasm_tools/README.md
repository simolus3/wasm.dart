## wasm_tools

Tools to compile Dart to standalone WebAssembly targets, including the WebAssembly component model.

> [!CAUTION]
> This functionality is highly experimental. It requires Dart 3.13 

## Installation

This package should be installed as a dev-dependency: `dart pub add --dev wasm_tools`

## Setup

To compile a Dart app as a WebAssembly component, we first need a `world.wit` file
defining imports and exports for the component.
Let's use this as a simple example:

```
// test.wit
package demo:component;

world root {
  export greeting;
}

interface greeting {
  generate-greeting: func() -> string;
}
```

First, run `dart run wasm_tools witgen -i test.wit`. This will generate:

- `lib/src/component.g.dart`, a file to bridge between Dart types and the component model.
- `hook/wasm_abi.json`, containing a copy of the WIT file with additional metadata for the compiler.

## Compiling a component

With the bridge and ABI file generated, the WIT world can be implemented in Dart.
Create a `bin/greeting.dart` with these contents:

```dart
// bin/greeting.dart
import 'package:greeting/src/component.g.dart';

void main(List<String> arguments) {
  defineInstanceExport(unnamedExport0: const _Greeting());
}

final class _Greeting implements Greeting {
  const _Greeting();

  @override
  String generateGreeting() {
    return 'Hello from Dart!';
  }
}
```

To inform the compiler about the ABI file, also create a `hook/build.dart` file containing:

```dart
// hook/build.dart
import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:wasm_tools/hooks.dart';

void main(List<String> args) => build(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    final abi = input.packageRoot.resolve('hook/wasm_abi.json');

    output.dependencies.add(abi);
    output.assets.webAssemblyComponents.add(
      WasmComponentAsset(
        encoded:
            json.decode(File(abi.toFilePath()).readAsStringSync())
                as Map<String, Object?>,
      ),
    );
  }
});
```

With everything in place, it's time to compile Dart into a WebAssembly component:

```shell
dart run wasm_tools compile bin/greeting.dart
```

This generates a `bin/greeting.wasm`, a WebAssembly component, which can be run with wasmtime:

```shell
wasmtime -W all-proposals=y --invoke 'generate-greeting()' bin/greeting.wasm
```

> [!NOTE]
> Enabling Garbage Collection, Exceptions and Typed Function References is required to run Dart
> in `wasmtime`. These flags will be enabled by default in `wasmtime` version 0.46.0.
