import 'regex.dart';

/// Matches an exact substring.
final class LiteralNode(final RegexString needle) extends Node {
  final int _needleLength = needle.length;

  @override
  bool match(MatchState state, int position, Continuation next) {
    return _matchesAt(state.input, position) && next(position + _needleLength);
  }

  bool _matchesAt(RegexString string, int position) {
    if (position + _needleLength > string.length) return false;

    for (var j = 0; j < _needleLength; j++) {
      if (string.codeUnitAtUnchecked(position + j) !=
          needle.codeUnitAtUnchecked(j)) {
        return false;
      }
    }
    return true;
  }

  /// Returns the first index `>= start` at which [needle] appears in [string],
  /// or `-1`.
  int firstIndexOf(RegexString string, int start) {
    // TODO: Use better string searching algorithm.
    for (var i = start; i + _needleLength <= string.length; i++) {
      if (_matchesAt(string, i)) return i;
    }
    return -1;
  }

  int searchBackwards(RegexString string, int start) {
    final substringLength = _needleLength;
    final limit = string.length - substringLength;
    if (limit < 0) return -1;
    if (start > limit) start = limit;

    for (var i = start; i >= 0; i--) {
      var match = true;
      for (var j = 0; j < substringLength; j++) {
        if (string.codeUnitAtUnchecked(i + j) !=
            needle.codeUnitAtUnchecked(j)) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }

    return -1;
  }
}
