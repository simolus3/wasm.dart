import 'package:wasm_components/src/embedder/exports.dart';

// 1. Compile with `dart compile wasm --standalone -E --enable-experimental-wasm-interop example/hello_world.dart`.
// 2. `dart bin/transform_to_wasip1.dart`.
void main() {
  print('Hello world!');
}
