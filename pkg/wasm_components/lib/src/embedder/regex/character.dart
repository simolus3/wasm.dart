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

/// Matches `\d` ([inverted] == false) or `\D` ([inverted] == true).
final class const MatchDigit({this.inverted = false})
    extends SingleCodeUnitNode {
  final bool inverted;

  @override
  bool matchesCodeUnit(int codeUnit) {
    final isDigit = isDigitChar(codeUnit);
    return inverted ? !isDigit : isDigit;
  }
}

/// Matches `\w` ([inverted] == false) or `\W` ([inverted] == true).
final class const MatchWord({this.inverted = false})
    extends SingleCodeUnitNode {
  final bool inverted;

  @override
  bool matchesCodeUnit(int codeUnit) {
    final isWord = isWordChar(codeUnit);
    return inverted ? !isWord : isWord;
  }
}

/// Matches `\s` ([inverted] == false) or `\S` ([inverted] == true).
final class const MatchSpace({this.inverted = false})
    extends SingleCodeUnitNode {
  final bool inverted;

  @override
  bool matchesCodeUnit(int codeUnit) {
    final isSpace = isSpaceChar(codeUnit);
    return inverted ? !isSpace : isSpace;
  }
}

final class const CharacterRange(final int start, final int end);

/// Matches a character class `[...]` or `[^...]`.
final class const CharacterClass(
  final List<CharacterRange> ranges,
  final List<SingleCodeUnitNode> escapes, {
  this.negated = false,
  this.ignoreCase = false,
}) extends SingleCodeUnitNode {
  final bool negated;
  final bool ignoreCase;

  @override
  bool matchesCodeUnit(int codeUnit) {
    final matched =
        _matchesRaw(codeUnit) ||
        (ignoreCase &&
            (_matchesRaw(charToLower(codeUnit)) ||
                _matchesRaw(charToUpper(codeUnit))));
    return negated ? !matched : matched;
  }

  bool _matchesRaw(int codeUnit) {
    for (final range in ranges) {
      if (codeUnit >= range.start && codeUnit <= range.end) {
        return true;
      }
    }
    for (final escape in escapes) {
      if (escape.matchesCodeUnit(codeUnit)) {
        return true;
      }
    }
    return false;
  }
}

bool isDigitChar(int code) => code >= $0 && code <= $9;

bool isWordChar(int code) =>
    (code >= $a && code <= $z) ||
    (code >= $A && code <= $Z) ||
    (code >= $0 && code <= $9) ||
    code == 0x5f; // '_'

bool isSpaceChar(int code) {
  // https://tc39.es/ecma262/#prod-WhiteSpace and LineTerminator
  return (code >= 0x09 && code <= 0x0d) ||
      code == 0x20 ||
      code == 0xa0 ||
      code == 0x1680 ||
      (code >= 0x2000 && code <= 0x200a) ||
      code == 0x2028 ||
      code == 0x2029 ||
      code == 0x202f ||
      code == 0x205f ||
      code == 0x3000 ||
      code == 0xfeff;
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
