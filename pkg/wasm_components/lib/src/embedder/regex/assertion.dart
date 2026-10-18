import 'dart:typed_data';

import 'character.dart';
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

/// Matches `\b` ([inverted] == false) or `\B` ([inverted] == true).
final class const WordBoundary(final bool inverted) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    final before = position > 0 && isWordChar(state.codeUnitAt(position - 1));
    final after =
        position < state.length && isWordChar(state.codeUnitAt(position));
    final isBoundary = before != after;
    final matches = inverted ? !isBoundary : isBoundary;
    return matches && next(position);
  }
}

/// Matches `(?=...)` ([positive] == true) or `(?!...)` ([positive] == false).
final class const Lookahead(
  final Node inner, {
  required final bool positive,
  this.firstCapture = 1,
  this.captureCount = 0,
}) extends Node {
  final int firstCapture;
  final int captureCount;

  @override
  bool match(MatchState state, int position, Continuation next) {
    final captures = state.captures;
    Int32List? savedCaptures;
    final startSlot = 2 * firstCapture;
    final endSlot = 2 * (firstCapture + captureCount);
    if (captureCount > 0) {
      savedCaptures = captures.sublist(startSlot, endSlot);
    }

    final matched = inner.match(state, position, (_) => true);
    if (positive) {
      if (!matched) return false;
      if (next(position)) return true;
      if (savedCaptures != null) {
        captures.setRange(startSlot, endSlot, savedCaptures);
      }
      return false;
    } else {
      if (matched) {
        if (savedCaptures != null) {
          captures.setRange(startSlot, endSlot, savedCaptures);
        }
        return false;
      }
      return next(position);
    }
  }
}
