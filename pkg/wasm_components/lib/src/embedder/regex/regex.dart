/// A Dart implementation for Regular expressions.
///
/// This is intended as a stopgap solution until the component model supports
/// garbage collection in interfaces, at that point we'd use strings and regular
/// expressions implemented in another language.
///
/// In this implementation, we prioritze simplicity above all else, including
/// performance. All matchers use a primitive backtracking implementation and
/// we only support a subset of nodes.
///
/// The matching algorithm closely follows the one described in the
/// [ECMAScript specification](https://tc39.es/ecma262/#sec-pattern-semantics):
/// Each [Node] is a matcher that receives the current [MatchState], a position
/// and a [Continuation] representing the rest of the pattern. A node tries each
/// way it could match at that position (in priority order) and calls the
/// continuation for each of them. As soon as a continuation reports success,
/// the whole match has succeeded and we unwind. When a continuation fails, we
/// try the next alternative (this is the backtracking part).
library;

import 'dart:typed_data';

import '../charcodes.dart';
import 'character.dart';

/// Abstraction over wasm string implementations so that we can test and debug
/// the regex engine on a Dart VM.
///
/// Let's hope that TFA makes this free.
abstract base class const RegexString() {
  int get length;
  bool get isOneByteString;

  int codeUnitAtUnchecked(int offset);
}

/// The rest of a pattern, invoked with the position at which the preceding
/// nodes have finished matching.
///
/// Returns whether the rest of the pattern (and thus the entire regex) matched.
typedef Continuation = bool Function(int position);

/// Mutable state shared by all nodes during a single match attempt.
final class MatchState {
  final RegexString input;

  /// Start and end offsets of capture groups, with `-1` representing groups
  /// that didn't participate in the match.
  ///
  /// Group `i` (1-indexed, like in JavaScript) is stored at `2 * i` and
  /// `2 * i + 1`. The first two entries are the bounds of the whole match.
  ///
  /// Nodes writing to this list are responsible for restoring the previous
  /// values if the continuation fails, so that alternatives tried later see
  /// the state they would have seen without the failed attempt.
  final Int32List captures;

  MatchState(this.input, int groupCount)
    : captures = Int32List(2 * (groupCount + 1))
        ..fillRange(0, 2 * (groupCount + 1), -1);

  int get length => input.length;

  int codeUnitAt(int position) => input.codeUnitAtUnchecked(position);
}

final class const RegexParseOptions({
  required final bool multiline,
  required final bool caseSensitive,
  required final bool unicode,
  required final bool dotAll,
});

/// A compiled regular expression.
final class const Regex(final Node root, {final int groupCount = 0}) {
  /// Attempts to match the regex starting exactly at [start].
  ///
  /// Returns capture offsets as described in [MatchState.captures], or `null`
  /// if the regex doesn't match at [start].
  Int32List? matchAt(RegexString input, int start) {
    final state = MatchState(input, groupCount);
    if (_matchAt(state, start)) {
      return state.captures;
    }
    return null;
  }

  /// Finds the first match at or after [start].
  Int32List? firstMatch(RegexString input, int start) {
    final state = MatchState(input, groupCount);
    // Note that we have to try matching at input.length too, as the regex may
    // match the empty string.
    for (var i = start; i <= input.length; i++) {
      if (_matchAt(state, i)) {
        return state.captures;
      }
    }
    return null;
  }

  /// Finds a match of this regex as used by `RegExp.firstMatch` (when
  /// [asPrefix] is false) or `RegExp.matchAsPrefix` (when it's true).
  RegexMatch? search(RegexString input, int start, {required bool asPrefix}) {
    final captures = asPrefix
        ? matchAt(input, start)
        : firstMatch(input, start);
    return captures == null ? null : RegexMatch(input, this, captures);
  }

  bool _matchAt(MatchState state, int start) {
    return root.match(state, start, (end) {
      state.captures
        ..[0] = start
        ..[1] = end;
      return true;
    });
  }
}

/// A successful match of a [Regex] on an [input].
final class const RegexMatch(
  final RegexString input,
  final Regex regex,

  /// Capture offsets, as described in [MatchState.captures].
  final Int32List captures,
) {
  int get start => captures[0];
  int get end => captures[1];
  int get groupCount => regex.groupCount;

  /// The start offset of the group at [index], or `-1` if the group did not
  /// participate in the match.
  int groupStart(int index) => captures[2 * index];

  /// The end offset of the group at [index], or `-1` if the group did not
  /// participate in the match.
  int groupEnd(int index) => captures[2 * index + 1];
}

abstract base class const Node() {
  /// Attempts to match this node at [position].
  ///
  /// For each way this node can match at [position], in the order of priority
  /// mandated by JavaScript semantics, this calls [next] with the position at
  /// which the match of this node ends (since this implementation doesn't
  /// support lookbehinds, that is always `>= position`).
  ///
  /// If [next] returns `true`, the overall regex has matched and this method
  /// must return `true` immediately without touching [state] further. If no
  /// attempt resulted in [next] returning `true`, return `false` after having
  /// restored all changes made to [state].
  bool match(MatchState state, int position, Continuation next);
}

/// Matches an `a|b` regex.
final class const Disjunction(final List<Node> options) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    for (final option in options) {
      if (option.match(state, position, next)) {
        return true;
      }
    }
    return false;
  }
}

final class const Concatenation(final List<Node> terms) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    return _matchFrom(0, state, position, next);
  }

  bool _matchFrom(
    int index,
    MatchState state,
    int position,
    Continuation next,
  ) {
    if (index == terms.length) {
      return next(position);
    }

    return terms[index].match(
      state,
      position,
      (end) => _matchFrom(index + 1, state, end, next),
    );
  }
}

/// Matches a capturing group `(...)`.
final class const CaptureGroup(final Node inner, final int index) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    final captures = state.captures;
    final startSlot = 2 * index;

    return inner.match(state, position, (end) {
      final oldStart = captures[startSlot];
      final oldEnd = captures[startSlot + 1];
      captures
        ..[startSlot] = position
        ..[startSlot + 1] = end;

      if (next(end)) {
        return true;
      }

      captures
        ..[startSlot] = oldStart
        ..[startSlot + 1] = oldEnd;
      return false;
    });
  }
}

/// Matches a backreference `\\1` to a capturing group.
///
/// Backreferences to groups that haven't participated in the match (yet) match
/// the empty string.
final class const BackReference(
  final int index, {
  final bool ignoreCase = false,
}) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    final captures = state.captures;
    final start = captures[2 * index];
    final end = captures[2 * index + 1];
    if (start == -1) {
      return next(position);
    }

    final length = end - start;
    if (position + length > state.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      var expected = state.codeUnitAt(start + i);
      var actual = state.codeUnitAt(position + i);
      if (ignoreCase) {
        expected = charToLower(expected);
        actual = charToLower(actual);
      }

      if (expected != actual) return false;
    }

    return next(position + length);
  }
}

bool isLineTerminator(int codeUnit) {
  // https://tc39.es/ecma262/#prod-LineTerminator
  return codeUnit == $lf ||
      codeUnit == $cr ||
      codeUnit == 0x2028 || // Line separator
      codeUnit == 0x2029; // Paragraph separator
}
