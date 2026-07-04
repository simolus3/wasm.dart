import 'dart:math';

import 'package:greeting/src/component.g.dart';

void main(List<String> arguments) {
  defineInstanceExport(unnamedExport0: const _Greeting());
}

final class _Greeting implements Greeting {
  const _Greeting();

  @override
  String generateGreeting() {
    // Using Random() rand Random.secure() automatically imports wasi:random.
    final random = Random.secure().nextInt(10);
    return "Hello from Dart. Here's a random number: $random!";
  }
}
