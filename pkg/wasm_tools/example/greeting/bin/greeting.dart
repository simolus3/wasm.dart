import 'dart:math';

import 'package:greeting/src/components/demo_component.dart';

void main(List<String> arguments) {
  defineInstanceExport(unnamedExport0: const _Greeting());
}

final class _Greeting implements Greeting {
  const _Greeting();

  @override
  String generateGreeting() {
    final sw = Stopwatch()..start();
    // Using Random() rand Random.secure() automatically imports wasi:random.
    final random = Random.secure().nextInt(10);
    final time = DateTime.now().microsecondsSinceEpoch;
    final duration = sw.elapsed;

    return "Hello from Dart. Here's a random number: $random. Time: $time, took $duration";
  }
}
