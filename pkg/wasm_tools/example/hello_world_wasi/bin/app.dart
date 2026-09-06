import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:wasi/cli/command.dart';
import 'package:wasi/cli.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  commandComponent((imports) => _Run(imports.cliStdout));
}

final class _Run(final Stdout stdout) implements Run {
  @override
  Future<Result<void, void>> run() async {
    final out = StreamController<Uint8List>();
    final stdoutDone = stdout.writeViaStream(data: out.stream);

    out.add(utf8.encode('Hello world!\n'));
    await Future.pause(const Duration(seconds: 1));

    final message = utf8.encode('This is running Dart!');
    var i = 0;

    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (i == message.length) {
        out.close();
        timer.cancel();
        return;
      }

      out.add(Uint8List.sublistView(message, i, i + 1));
      i++;
    });

    await stdoutDone;
    return const .ok(null);
  }
}
