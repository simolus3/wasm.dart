import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hello_world_wasi/src/components/root_component_root.dart';
import 'package:hello_world_wasi/src/components/wasi_cli.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  rootComponent((imports) => _Run(imports.cliStdout));
}

final class _Run implements Run {
  final Stdout stdout;

  _Run(this.stdout);

  @override
  Future<Result<void, void>> run() async {
    final out = StreamController<Uint8List>();
    final stdoutDone = stdout.writeViaStream(data: out.stream);

    out.add(utf8.encode('Hello world!\n'));
    await Future<void>.delayed(const Duration(seconds: 1));
    out.add(utf8.encode('This is running Dart!'));
    out.close();

    await stdoutDone;
    return const .ok(null);
  }
}
