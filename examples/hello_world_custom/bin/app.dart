import 'package:hello_world_custom/src/component.g.dart';
import 'package:wasm_components/wasm_components.dart';

void main() {
  defineInstanceExport(unnamedExport1: const _Run());
}

final class _Run implements Run {
  const _Run();

  @override
  Result<void, void> run() {
    importedInstance0.print(line: 'Hello world!');
    return const .ok(null);
  }
}
