import 'package:test_runner/test_runner.dart';

import 'stream_sink/wasm.dart' if (dart.library.io) 'stream_sink/vm.dart';

void main() {
  defineTests(const [
    testStreamSinkDeferredDrop,
    testStreamSinkBackpressure,
    testStreamSinkPartialWritesAndReaderDrop,
  ]);
}
