import 'package:hello_world_custom/src/components.dart';
import 'package:wasm_components/component.dart';

void main() {
  defineInstanceExport(const _Run());
}

final class _Run implements WasiCliRun {
  const _Run();

  @override
  Result<Null, Null> run() {
    return const .ok(null);
  }
}
