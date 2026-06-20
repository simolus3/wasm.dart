final class ToolFailure implements Exception {
  final String message;

  ToolFailure(this.message);

  @override
  String toString() {
    return 'Tool failure: $message';
  }
}
