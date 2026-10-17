import 'character.dart';
import 'regex.dart';

/// Matches [node] repeatedly, between [min] and [max] (inclusive) times.
///
/// Since JavaScript resets capture groups of the quantified atom on every
/// iteration, quantifiers need to know which groups are contained in [node]:
/// Those are the groups `firstCapture` to `firstCapture + captureCount - 1`.
final class Quantifier(
  final Node node, {
  required final int min,
  required final int? max,
  final bool greedy = true,
  final int firstCapture = 0,
  final int captureCount = 0,
}) extends Node {
  @override
  bool match(MatchState state, int position, Continuation next) {
    if (node case final SingleCodeUnitNode single) {
      return _matchSimple(single, state, position, next);
    }

    return _repeat(state, min, max, position, next);
  }

  /// A fast path for quantifiers on atoms that always match a single code
  /// unit (like `.*` or `a+`).
  ///
  /// Those can't contain captures or match the empty string, so we can just
  /// count how often the atom matches and try each possible end position
  /// without recursing for each iteration.
  bool _matchSimple(
    SingleCodeUnitNode single,
    MatchState state,
    int position,
    Continuation next,
  ) {
    final available = state.length - position;
    final limit = max == null || max! > available ? available : max!;

    if (greedy) {
      var count = 0;
      while (count < limit &&
          single.matchesCodeUnit(state.codeUnitAt(position + count))) {
        count++;
      }

      for (var i = count; i >= min; i--) {
        if (next(position + i)) return true;
      }
    } else {
      for (var i = 0; i <= limit; i++) {
        if (i >= min && next(position + i)) return true;
        if (i == limit ||
            !single.matchesCodeUnit(state.codeUnitAt(position + i))) {
          break;
        }
      }
    }

    return false;
  }

  /// The general implementation, following
  /// https://tc39.es/ecma262/#sec-runtime-semantics-repeatmatcher-abstract-operation
  bool _repeat(
    MatchState state,
    int min,
    int? max,
    int position,
    Continuation next,
  ) {
    if (max == 0) {
      return next(position);
    }

    bool iteration(int end) {
      // Stop iterations matching the empty string once the minimum has been
      // reached, as those would otherwise loop forever.
      if (min == 0 && end == position) {
        return false;
      }

      return _repeat(
        state,
        min == 0 ? 0 : min - 1,
        max == null ? null : max - 1,
        end,
        next,
      );
    }

    if (min != 0) {
      return _matchIteration(state, position, iteration);
    }

    if (greedy) {
      return _matchIteration(state, position, iteration) || next(position);
    } else {
      return next(position) || _matchIteration(state, position, iteration);
    }
  }

  /// Matches a single iteration of [node], resetting captures contained in it
  /// beforehand.
  bool _matchIteration(MatchState state, int position, Continuation next) {
    if (captureCount == 0) {
      return node.match(state, position, next);
    }

    final captures = state.captures;
    final from = 2 * firstCapture;
    final to = from + 2 * captureCount;
    final saved = captures.sublist(from, to);
    captures.fillRange(from, to, -1);

    if (node.match(state, position, next)) {
      return true;
    }

    captures.setRange(from, to, saved);
    return false;
  }
}
