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
