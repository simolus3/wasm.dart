/// A result in the component model.
sealed class Result<Ok, Err> {
  const Result._();

  const factory Result.ok(Ok value) = OkResult;
  const factory Result.error(Err error) = ErrorResult;
}

final class OkResult<Ok, Err> extends Result<Ok, Err> {
  final Ok value;

  const OkResult(this.value) : super._();
}

final class ErrorResult<Ok, Err> extends Result<Ok, Err> {
  final Err value;

  const ErrorResult(this.value) : super._();
}
