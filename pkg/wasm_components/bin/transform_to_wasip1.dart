import 'dart:io';

import 'package:wasm_components/src/compiler/transform.dart';

void main() {
  final transformer = ModuleTransformer.fromBytes(
    File('example/hello_world.wasm').readAsBytesSync(),
  );
  transformer.transform();

  File(
    'example/hello_world.lowered.wasm',
  ).writeAsBytesSync(transformer.serialize());
}
