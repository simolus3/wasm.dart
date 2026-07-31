import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hello_world_custom/src/component.g.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  defineInstanceExport(unnamedExport2: _Run());
}

final class _Run implements Run {
  _Run();

  @override
  Future<Result<void, void>> run() async {
    final out = StreamController<Uint8List>();
    final stdoutDone = importedInstance1.writeViaStream(data: out.stream);

    out.add(utf8.encode('Hello world!'));
    out.close();

    await stdoutDone;
    return const .ok(null);
  }
}
