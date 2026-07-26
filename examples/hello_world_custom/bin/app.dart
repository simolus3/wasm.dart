import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hello_world_custom/src/component.g.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  defineInstanceExport(unnamedExport1: _Run());
}

final class _Run implements Run {
  StreamController<Uint8List>? _stdout;

  Completer<void>? _previous;

  _Run();

  @override
  Future<Result<void, void>> run() async {
    final out = _configureStdout();

    if (_previous case final previous?) {
      out.add(utf8.encode('Second run, delaying for one second\n'));
      await Future<void>.delayed(const Duration(seconds: 1));
      out.add(utf8.encode('Completing previous\n'));
      previous.complete();
      return const .ok(null);
    }

    out.add(utf8.encode('first run, wil wait for second\n'));
    final future = (_previous = Completer()).future;

    await future;
    return const .ok(null);
  }

  StreamController<Uint8List> _configureStdout() {
    if (_stdout case final out?) return out;

    final controller = StreamController<Uint8List>();
    importedInstance0.forwardToStdout(data: controller.stream);
    return _stdout = controller;
  }
}
