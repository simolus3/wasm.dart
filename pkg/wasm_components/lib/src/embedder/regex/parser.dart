import '../charcodes.dart';
import 'assertion.dart';
import 'character.dart';
import 'literal.dart';
import 'quantifier.dart';
import 'regex.dart';

final class RegexParser(
  final RegexString string,
  final RegexParseOptions options,
  final RegexString Function(List<int>, bool isAscii) stringFromCharCodes,
) {
  final _length = string.length;
  var _position = 0;

  /// The amount of capturing groups opened so far.
  ///
  /// Since groups are numbered by the position of their opening parenthesis,
  /// this is also the index of the most recently opened group.
  var _openedGroups = 0;

  /// The total amount of capturing groups in the pattern, required to resolve
  /// backreferences (which may refer to groups defined later).
  late final int _totalGroups = _countCapturingGroups();

  bool get _isAtEnd => _position == _length;

  int _peek() {
    assert(!_isAtEnd);
    return string.codeUnitAtUnchecked(_position);
  }

  int _advance() {
    final code = string.codeUnitAtUnchecked(_position);
    _position++;
    return code;
  }

  bool _has(int charcode) {
    if (_isAtEnd) return false;
    return _peek() == charcode;
  }

  bool _match(int charcode) {
    if (_has(charcode)) {
      _position++;
      return true;
    }
    return false;
  }

  bool _matchMultiple(List<int> charcodes) {
    if (_position + charcodes.length > _length) {
      return false;
    }

    for (var i = 0; i < charcodes.length; i++) {
      if (string.codeUnitAtUnchecked(_position + i) != charcodes[i]) {
        return false;
      }
    }

    _position += charcodes.length;
    return true;
  }

  void _require(int charcode) {
    if (!_match(charcode)) {
      _error('Expected ${String.fromCharCode(charcode)} here');
    }
  }

  Never _error(String message) {
    throw FormatException(message, string.toString(), _position);
  }

  Regex parse() {
    if (options.unicode) {
      _error('Unicode flag is not currently supported');
    }

    final node = _disjunction();
    if (!_isAtEnd) {
      _error('Expected regular expression to end here');
    }
    assert(_openedGroups == _totalGroups);
    return Regex(node, groupCount: _openedGroups);
  }

  /// Counts capturing groups in the entire pattern, following
  /// https://tc39.es/ecma262/#sec-countleftcapturingparenswithin.
  ///
  /// This runs before parsing so that backreferences to groups that appear
  /// later in the pattern can be resolved.
  int _countCapturingGroups() {
    var count = 0;
    var inClass = false;

    for (var i = 0; i < _length; i++) {
      final char = string.codeUnitAtUnchecked(i);
      if (char == $backslash) {
        // Skip the escaped character.
        i++;
      } else if (inClass) {
        if (char == $rbracket) inClass = false;
      } else if (char == $lbracket) {
        inClass = true;
      } else if (char == $lparen) {
        if (i + 1 < _length && string.codeUnitAtUnchecked(i + 1) == $question) {
          // Only (?<name> is capturing, (?<= and (?<! are lookbehinds.
          if (i + 3 < _length &&
              string.codeUnitAtUnchecked(i + 2) == $lt &&
              string.codeUnitAtUnchecked(i + 3) != $equal &&
              string.codeUnitAtUnchecked(i + 3) != $exclamation) {
            count++;
          }
        } else {
          count++;
        }
      }
    }

    return count;
  }

  Node _disjunction() {
    // https://tc39.es/ecma262/#prod-Disjunction
    final base = _alternative();
    if (_match($bar)) {
      final terms = [base];
      do {
        terms.add(_alternative());
      } while (_match($bar));

      return Disjunction(terms);
    }

    return base;
  }

  Node _alternative() {
    List<Node> concatenation = [];
    _CharBuffer? pendingString;

    void addPendingString() {
      if (pendingString case final buffer?) {
        pendingString = null;

        if (buffer.charCodes.length == 1) {
          concatenation.add(MatchSingleCharacter(buffer.charCodes[0]));
        } else {
          concatenation.add(
            LiteralNode(stringFromCharCodes(buffer.charCodes, buffer.isAscii)),
          );
        }
        pendingString = null;
      }
    }

    consumeAtom:
    while (!_isAtEnd) {
      var isAssertion = false;
      final groupsBeforeAtom = _openedGroups;
      Node next;

      final firstChar = _peek();
      switch (firstChar) {
        case $rparen:
        case $bar:
          break consumeAtom;
        case $caret:
          _advance();
          next = StartAnchor(options.multiline);
          isAssertion = true;
        case $$:
          _advance();
          next = EndAnchor(options.multiline);
          isAssertion = true;
        case $dot:
          _advance();
          next = MatchAny(options.dotAll);
        case $lparen:
          if (_matchMultiple(const [$lparen, $question, $equal])) {
            // (?=, positive lookahead.
            final contents = _disjunction();
            next = Lookahead(
              contents,
              positive: true,
              firstCapture: groupsBeforeAtom + 1,
              captureCount: _openedGroups - groupsBeforeAtom,
            );
            isAssertion = true;
          } else if (_matchMultiple(const [$lparen, $question, $exclamation])) {
            // (?!, negative lookahead
            final contents = _disjunction();
            next = Lookahead(
              contents,
              positive: false,
              firstCapture: groupsBeforeAtom + 1,
              captureCount: _openedGroups - groupsBeforeAtom,
            );
            isAssertion = true;
          } else if (_matchMultiple(const [$lparen, $question, $lt, $equal])) {
            // (?<=, positive lookbehind
            _error('todo');
          } else if (_matchMultiple(const [
            $lparen,
            $question,
            $lt,
            $exclamation,
          ])) {
            // (?<!, negative lookbehind
            _error('todo');
          } else if (_matchMultiple(const [$lparen, $question, $colon])) {
            // (?:, non-capturing group
            next = _disjunction();
          } else {
            // Capturing group.
            _advance();

            if (_match($question)) {
              _require($lt);
              _error('todo: named groups');
              // ignore: dead_code
              _require($gt);
            }

            final index = ++_openedGroups;
            final contents = _disjunction();
            next = CaptureGroup(contents, index);
          }

          _require($rparen);
        case $backslash:
          _advance();
          next = _atomEscape();
          if (next is WordBoundary) {
            isAssertion = true;
          }
        case $lbracket:
          _advance();
          next = _characterClass();
        case $asterisk:
        case $plus:
        case $question:
          _error('Illegal character here');
        default:
          if (options.unicode) {
            if (firstChar case $rbracket || $lbrace || $rbrace) {
              _error('Invalid atom character');
            }
          }

          _advance();
          // Everything else: SyntaxCharacter
          next = _matchCharCode(firstChar);
      }

      if (!isAssertion) {
        final savedOffset = _position;
        try {
          next = _maybeWrapInQuantifier(
            next,
            firstCapture: groupsBeforeAtom + 1,
            captureCount: _openedGroups - groupsBeforeAtom,
          );
        } on FormatException {
          _position = savedOffset;
        }

        if (next case Quantifier(:final min, :final max?) when min > max) {
          _error('Quantifier has min > max');
        }
      }

      if (next is MatchSingleCharacter) {
        (pendingString ??= _CharBuffer()).addCharCode(next.codeUnit);
      } else {
        addPendingString();
        concatenation.add(next);
      }
    }

    addPendingString();
    return switch (concatenation) {
      [final single] => single,
      _ => Concatenation(concatenation),
    };
  }

  SingleCodeUnitNode _matchCharCode(int codeUnit) {
    if (!options.caseSensitive) {
      final matchedCharCodes = [codeUnit];

      final upper = charToUpper(codeUnit);
      final lower = charToLower(codeUnit);

      if (upper != codeUnit) matchedCharCodes.add(upper);
      if (lower != codeUnit) matchedCharCodes.add(lower);

      if (matchedCharCodes.length > 1) {
        return MatchCharacterInList(matchedCharCodes);
      }
    }
    return MatchSingleCharacter(codeUnit);
  }

  /// Parses a character class `[...]` after the opening `[` has been consumed.
  ///
  /// https://tc39.es/ecma262/#prod-CharacterClass
  Node _characterClass() {
    final negated = _match($caret);
    final ranges = <CharacterRange>[];
    final escapes = <SingleCodeUnitNode>[];

    while (!_match($rbracket)) {
      if (_isAtEnd) _error('Unclosed character class');

      final startAtom = _classAtom();
      if (startAtom is SingleCodeUnitNode) {
        if (!_isAtEnd &&
            _peek() == $minus &&
            _position + 1 < _length &&
            string.codeUnitAtUnchecked(_position + 1) != $rbracket) {
          if (options.unicode) {
            _error('Invalid character class range');
          }
        }
        escapes.add(startAtom);
        continue;
      }

      final startCode = startAtom as int;
      if (!_isAtEnd &&
          _peek() == $minus &&
          _position + 1 < _length &&
          string.codeUnitAtUnchecked(_position + 1) != $rbracket) {
        final savedMinusPos = _position;
        _advance(); // consume '-'
        final endAtom = _classAtom();
        if (endAtom is SingleCodeUnitNode) {
          if (options.unicode) {
            _error('Invalid character class range');
          }
          // Annex B: treat `startAtom`, `-`, and `endAtom` as individual class atoms.
          ranges.add(CharacterRange(startCode, startCode));
          ranges.add(const CharacterRange($minus, $minus));
          escapes.add(endAtom);
          continue;
        }
        final endCode = endAtom as int;
        if (startCode > endCode) {
          _position = savedMinusPos;
          _error('Range out of order in character class');
        }
        ranges.add(CharacterRange(startCode, endCode));
      } else {
        ranges.add(CharacterRange(startCode, startCode));
      }
    }

    return CharacterClass(
      ranges,
      escapes,
      negated: negated,
      ignoreCase: !options.caseSensitive,
    );
  }

  /// Returns either an `int` code unit or a [SingleCodeUnitNode] (for `\d`,
  /// `\D`, `\s`, `\S`, `\w`, `\W`).
  Object _classAtom() {
    final char = _advance();
    if (char != $backslash) {
      return char;
    }

    if (_isAtEnd) _error('Expected escape sequence in character class');
    final escaped = _peek();
    if (escaped == 0x62) {
      // `\b` inside a character class is backspace (0x08).
      _advance();
      return 0x08;
    }

    if (_tryParseCharClassEscape() case final classEscape?) {
      return classEscape;
    }

    return _characterEscapeCodeUnit();
  }

  /// Parses the part of an AtomEscape after the backslash.
  ///
  /// https://tc39.es/ecma262/#prod-AtomEscape
  Node _atomEscape() {
    if (_isAtEnd) _error('Expected escape sequence');

    final first = _peek();
    if (first == 0x62) {
      // 'b' -> \b word boundary
      _advance();
      return const WordBoundary(false);
    }
    if (first == 0x42) {
      // 'B' -> \B non-word boundary
      _advance();
      return const WordBoundary(true);
    }

    if (_tryParseCharClassEscape() case final classEscape?) {
      return classEscape;
    }

    if (first > $0 && first <= $9) {
      // https://tc39.es/ecma262/#prod-DecimalEscape. Without the unicode flag,
      // this is only a backreference if the group exists (Annex B).
      final start = _position;
      final index = _decimalDigits()!;
      if (index <= _totalGroups) {
        return BackReference(index, ignoreCase: !options.caseSensitive);
      }

      // Otherwise, this is a legacy octal escape or an identity escape.
      _position = start;
      if (options.unicode) {
        _error('Invalid decimal escape');
      }
    }

    return _matchCharCode(_characterEscapeCodeUnit());
  }

  SingleCodeUnitNode? _tryParseCharClassEscape() {
    if (_isAtEnd) return null;
    switch (_peek()) {
      case 0x64: // 'd'
        _advance();
        return const MatchDigit(inverted: false);
      case 0x44: // 'D'
        _advance();
        return const MatchDigit(inverted: true);
      case 0x73: // 's'
        _advance();
        return const MatchSpace(inverted: false);
      case 0x53: // 'S'
        _advance();
        return const MatchSpace(inverted: true);
      case 0x77: // 'w'
        _advance();
        return const MatchWord(inverted: false);
      case 0x57: // 'W'
        _advance();
        return const MatchWord(inverted: true);
      default:
        return null;
    }
  }

  int _characterEscapeCodeUnit() {
    if (_isAtEnd) _error('Expected escape sequence');
    final first = _advance();
    switch (first) {
      case 0x74: // 't'
        return 0x09;
      case 0x6e: // 'n'
        return $lf;
      case 0x76: // 'v'
        return 0x0b;
      case 0x66: // 'f'
        return 0x0c;
      case $cr:
      case 0x72: // 'r'
        return $cr;
      case $0:
        if (!_isAtEnd) {
          final next = _peek();
          if (next >= $0 && next <= $9) {
            if (options.unicode) {
              _error('Invalid decimal escape');
            }
          }
        }
        return 0x00;
      case 0x63: // 'c' ControlLetter
        if (!_isAtEnd) {
          final letter = _peek();
          if ((letter >= $a && letter <= $z) ||
              (letter >= $A && letter <= $Z)) {
            _advance();
            return letter % 32;
          }
        }
        if (options.unicode) {
          _error('Invalid control escape');
        }
        return first;
      case 0x78: // 'x' HexEscapeSequence \xHH
        final hex = _tryHexDigits(2);
        if (hex != null) return hex;
        if (options.unicode) {
          _error('Invalid hex escape');
        }
        return first;
      case 0x75: // 'u' RegExpUnicodeEscapeSequence \uHHHH or \u{H...}
        if (!_isAtEnd && _peek() == $lbrace && options.unicode) {
          _advance();
          final codePoint = _bracedHexDigits();
          if (codePoint > 0x10ffff) {
            _error('Unicode code point out of range');
          }
          return codePoint;
        }
        final hex = _tryHexDigits(4);
        if (hex != null) return hex;
        if (options.unicode) {
          _error('Invalid unicode escape');
        }
        return first;
      case $caret ||
          $$ ||
          $backslash ||
          $dot ||
          $asterisk ||
          $plus ||
          $question ||
          $lparen ||
          $rparen ||
          $lbracket ||
          $rbracket ||
          $lbrace ||
          $rbrace ||
          $bar ||
          $slash ||
          $minus:
        return first;
      default:
        if (options.unicode) {
          _error('Invalid identity escape');
        }
        return first;
    }
  }

  int? _tryHexDigits(int count) {
    if (_position + count > _length) return null;
    var value = 0;
    for (var i = 0; i < count; i++) {
      final digit = _hexDigitValue(string.codeUnitAtUnchecked(_position + i));
      if (digit == null) return null;
      value = (value << 4) | digit;
    }
    _position += count;
    return value;
  }

  int _bracedHexDigits() {
    if (_isAtEnd) _error('Expected hex digits');
    var value = 0;
    var count = 0;
    while (!_isAtEnd && !_has($rbrace)) {
      final digit = _hexDigitValue(_advance());
      if (digit == null) _error('Invalid hex digit');
      value = (value << 4) | digit;
      count++;
    }
    if (count == 0) _error('Expected hex digits');
    _require($rbrace);
    return value;
  }

  static int? _hexDigitValue(int charCode) {
    if (charCode >= $0 && charCode <= $9) return charCode - $0;
    if (charCode >= $a && charCode <= 0x66) return charCode - $a + 10;
    if (charCode >= $A && charCode <= 0x46) return charCode - $A + 10;
    return null;
  }

  Node _maybeWrapInQuantifier(
    Node inner, {
    required int firstCapture,
    required int captureCount,
  }) {
    if (_isAtEnd) return inner;

    int min;
    int? max;

    switch (_peek()) {
      case $asterisk:
        _advance();
        min = 0;
        max = null;
      case $plus:
        _advance();
        min = 1;
        max = null;
      case $question:
        _advance();
        min = 0;
        max = 1;
      case $lbrace:
        _advance();
        min = _decimalDigits() ?? _error('Expected amount');
        if (_match($comma)) {
          max = _decimalDigits();
        } else {
          max = min;
        }
        _require($rbrace);
      default:
        return inner;
    }

    final lazy = _match($question);
    return Quantifier(
      inner,
      min: min,
      max: max,
      greedy: !lazy,
      firstCapture: firstCapture,
      captureCount: captureCount,
    );
  }

  int? _decimalDigits() {
    if (_isAtEnd) return null;

    // https://tc39.es/ecma262/#prod-DecimalDigits
    final first = _peek();
    if (first < $0 || first > $9) return null;
    _advance();

    var value = first - $0;
    while (!_isAtEnd) {
      final next = _peek();
      if (next < $0 || next > $9) break;

      _advance();
      value = value * 10 + (next - $0);
    }

    return value;
  }
}

class _CharBuffer {
  final List<int> charCodes = [];
  var isAscii = true;

  void addCharCode(int codeUnit) {
    charCodes.add(codeUnit);
    isAscii &= codeUnit < 128;
  }
}
