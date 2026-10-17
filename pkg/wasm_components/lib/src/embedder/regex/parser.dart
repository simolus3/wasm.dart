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
            _error('todo');
          } else if (_matchMultiple(const [$lparen, $question, $exclamation])) {
            // (?!, negative lookahead
            _error('todo');
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
        case $lbracket:
          _advance();
          _error('todo');
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
          if (!options.caseSensitive) {
            final matchedCharCodes = [firstChar];

            final upper = charToUpper(firstChar);
            final lower = charToLower(firstChar);

            if (upper != firstChar) matchedCharCodes.add(upper);
            if (lower != firstChar) matchedCharCodes.add(lower);

            if (matchedCharCodes.length == 1) {
              next = MatchSingleCharacter(firstChar);
            } else {
              next = MatchCharacterInList(matchedCharCodes);
            }
          } else {
            next = MatchSingleCharacter(firstChar);
          }
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

  /// Parses the part of an AtomEscape after the backslash.
  ///
  /// https://tc39.es/ecma262/#prod-AtomEscape
  Node _atomEscape() {
    if (_isAtEnd) _error('Expected escape sequence');

    final first = _peek();
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
    }

    switch (first) {
      // https://tc39.es/ecma262/#prod-IdentityEscape for syntax characters and
      // `/`, which are valid with and without the unicode flag.
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
          $slash:
        _advance();
        return MatchSingleCharacter(first);
    }

    _error('todo');
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
