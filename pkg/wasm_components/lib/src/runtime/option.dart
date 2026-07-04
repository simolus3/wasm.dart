/// The Dart representation for `option` in WIT.
///
/// In the future, we might use nullable types in cases where that doesn't cause
/// ambiguity.
final class Option<T> {
  final T? _value;
  final bool hasValue;

  const Option.some(T value) : _value = value, hasValue = true;

  const Option._absent() : _value = null, hasValue = false;

  T requireValue() {
    if (!hasValue) throw StateError('requireValue() called on absent option');

    return _value as T;
  }

  static const Option<Never> none = Option._absent();
}
