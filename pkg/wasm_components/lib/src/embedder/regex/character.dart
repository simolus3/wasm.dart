import '../charcodes.dart';
import 'regex.dart';

/// A node matching exactly one code unit if it satisfies [matchesCodeUnit].
abstract base class const SingleCodeUnitNode() extends Node {
  bool matchesCodeUnit(int codeUnit);

  @override
  bool match(MatchState state, int position, Continuation next) {
    return position < state.length &&
        matchesCodeUnit(state.codeUnitAt(position)) &&
        next(position + 1);
  }
}

/// Matches `.`, which is any character except for line terminators unless
/// [dotAll] is set.
final class const MatchAny(final bool dotAll) extends SingleCodeUnitNode {
  @override
  bool matchesCodeUnit(int codeUnit) {
    return dotAll || !isLineTerminator(codeUnit);
  }
}

final class const MatchSingleCharacter(final int codeUnit)
    extends SingleCodeUnitNode {
  @override
  bool matchesCodeUnit(int codeUnit) => codeUnit == this.codeUnit;
}

final class const MatchCharacterInList(final List<int> charCodes)
    extends SingleCodeUnitNode {
  @override
  bool matchesCodeUnit(int codeUnit) => charCodes.contains(codeUnit);
}

int charToUpper(int code) {
  if (code >= $a && code <= $z) {
    return code - 32;
  }

  return code;
}

int charToLower(int code) {
  if (code >= $A && code <= $Z) {
    return code + 32;
  }

  return code;
}
