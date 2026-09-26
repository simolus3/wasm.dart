import 'generated/dart_enum_export.dart';
import 'generated/dart_enum_export_root.dart';

void main() {
  rootComponent((_) => const _Calculate());
}

final class const _Calculate() implements Calculate {
  @override
  int evalExpression({
    required CalculateOp op,
    required int x,
    required int y,
  }) {
    return switch (op) {
      .add => x + y,
    };
  }
}
