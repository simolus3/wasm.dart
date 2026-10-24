## wasm_tools

Tools to compile Dart to the [WebAssembly component model](https://component-model.bytecodealliance.org/).

> [!WARNING]
> These tools should be considered a proof of concept. They perform very poorly
> due to a lack of GC support in the Component Model.
> A _much_ better way to embed `dart2wasm` into existing applications is to use
> a [custom embedder](https://github.com/simolus3/standalone-embedders).

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

First, run `dart run wasm_tools witgen -i test.wit`. In `lib/src/components` (the directory can be changed with `-o`), this generates:

- `demo_component.dart`, a Dart interface describing `greeting`.
- `demo_component_root.dart`, bindings to bridge between the Dart interface and the low-level component ABI.
- `demo_component_root.json`, additional metadata for the compiler.

## Compiling a component

With the bridge and ABI file generated, the WIT world can be implemented in Dart.
Create a `bin/greeting.dart` with these contents:

```dart
// bin/greeting.dart
import 'package:greeting/src/components/demo_component.dart';
import 'package:greeting/src/components/demo_component_root.dart';

void main() {
  rootComponent((_) => _Greeting());
}

final class const _Greeting() implements Greeting {
  @override
  String generateGreeting() {
    return 'Hello from Dart!';
  }
}
```

To inform the compiler about the ABI file, also create a `hook/link.dart` file containing:

```dart
// hook/link.dart
import 'dart:convert';
import 'dart:io';

import 'package:hooks/hooks.dart';
import 'package:wasm_tools/hooks.dart';

void main(List<String> args) => link(args, (input, output) async {
  if (input.config.buildWasmComponent) {
    final abi = input.packageRoot.resolve(
      'lib/src/components/demo_component_root.json',
    );

    output.dependencies.add(abi);
    output.assets.webAssemblyComponents.add(
      WasmComponentAsset(
        encoded: json.decode(
          File(abi.toFilePath()).readAsStringSync(),
        ) as Map<String, Object?>,
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
wasmtime --invoke 'generate-greeting()' bin/greeting.wasm
```
