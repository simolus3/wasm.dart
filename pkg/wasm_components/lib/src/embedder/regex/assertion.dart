import 'regex.dart';

/// Matches `^`.
final class const StartAnchor(final bool multiline) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    final matches =
        position == 0 ||
        (multiline && isLineTerminator(state.codeUnitAt(position - 1)));
    return matches && next(position);
  }
}

/// Matches `\$`.
final class const EndAnchor(final bool multiline) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    final matches =
        position == state.length ||
        (multiline && isLineTerminator(state.codeUnitAt(position)));
    return matches && next(position);
  }
}
