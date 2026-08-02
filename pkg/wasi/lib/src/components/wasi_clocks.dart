// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

abstract interface class Types {}

abstract interface class MonotonicClock {
  int now();
  int getResolution();
  Future<void> waitUntil({required int when});
  Future<void> waitFor({required int howLong});
}

abstract interface class SystemClock {
  ({int seconds, int nanoseconds}) now();
  int getResolution();
}

abstract interface class Timezone {
  i0.Option<String> ianaId();
  i0.Option<int> utcOffset({required ({int seconds, int nanoseconds}) when});
  String toDebugString();
}
