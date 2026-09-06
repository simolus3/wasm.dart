Dart bindings to the [WebAssembly System Interface](https://github.com/WebAssembly/WASI/).

## Usage

This package allows Dart WebAssembly components (built with the [wasm_tools package](https://pub.dev/packages/wasm_tools))
to access WASI functionality like file systems, low-level networking as well as HTTP clients and servers.

Currently, this exposes the `wasi:cli` and `wasi:http` worlds.

To use this package, add it and `wasm_tools` to your dependencies:

```shell
dart pub add wasi dev:wasm_tools
```

WebAssembly components are defined against a "world" describing imports and
exports. `wasi:cli/command` is one such world meant as a target for CLI 
programs.
A simple Dart component for that world might look like this:

```dart
import 'dart:async';
import 'dart:convert';

import 'package:wasi/cli/command.dart';
import 'package:wasi/cli.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  commandComponent((imports) => _Run(imports.cliStdout));
}

final class _Run(final Stdout stdout) implements Run {
  @override
  Future<Result<void, void>> run() async {
    await stdout.writeViaStream(data: .value(utf8.encode('Hello world!')));
    return const .ok(null);
  }
}
```

Compile this with `dart run wasm_tools compile main.dart`, and run it with
`wasmtime run main.wasm`.
