import 'dart:async';

import 'package:hello_world_custom/src/component.g.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  defineInstanceExport(unnamedExport1: _Run());
}

final class _Run implements Run {
  Completer<void>? _previous;

  _Run();

  @override
  Future<Result<void, void>> run() async {
    if (_previous case final previous?) {
      importedInstance0.print(line: 'Completing previous');
      previous.complete();
      return const .ok(null);
    }

    importedInstance0.print(line: 'first run, will wait for second');
    final future = (_previous = Completer()).future;

    await future;
    return const .ok(null);
  }
}
