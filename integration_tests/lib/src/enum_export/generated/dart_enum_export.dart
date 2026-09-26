// ignore_for_file: type=warning

enum CalculateOp { add }

abstract interface class Calculate {
  int evalExpression({required CalculateOp op, required int x, required int y});
}
