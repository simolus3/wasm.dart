import 'dart:convert';

import 'package:wasi/cli.dart';
import 'package:wasi/cli/command.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  commandComponent(
    (imports) => _WriteImmediatelyClosedStream(imports.cliStdout),
  );
}

final class _WriteImmediatelyClosedStream(final Stdout stdout) implements Run {
  @override
  Future<Result<void, void>> run() async {
    await stdout.writeViaStream(
      data: .value(utf8.encode('Single-chunk stream')),
    );
    return .ok(null);
  }
}
