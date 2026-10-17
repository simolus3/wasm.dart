import 'package:test/test.dart';
import 'package:wasm_components/src/embedder/regex/character.dart';
import 'package:wasm_components/src/embedder/regex/literal.dart';
import 'package:wasm_components/src/embedder/regex/quantifier.dart';
import 'package:wasm_components/src/embedder/regex/regex.dart';

import 'utils.dart';

void main() {
  group('agrees with dart:core', () {
    void check(
      String pattern,
      List<String> inputs, {
      bool multiline = false,
      bool caseSensitive = true,
      bool dotAll = false,
    }) {
      final regex = compile(
        pattern,
        multiline: multiline,
        caseSensitive: caseSensitive,
        dotAll: dotAll,
      );
      final reference = RegExp(
        pattern,
        multiLine: multiline,
        caseSensitive: caseSensitive,
        dotAll: dotAll,
      );

      for (final input in inputs) {
        for (var start = 0; start <= input.length; start++) {
          final expected = reference.allMatches(input, start).firstOrNull;
          final actual = regex.firstMatch(DartRegexString(input), start);

          final reason = '/$pattern/ on "$input" from $start';

          if (expected == null) {
            expect(actual, isNull, reason: reason);
            continue;
          }

          expect(actual, isNotNull, reason: reason);
          expect(
            (actual![0], actual[1]),
            (expected.start, expected.end),
            reason: reason,
          );
          expect(regex.groupCount, expected.groupCount, reason: reason);
          expect(
            [
              for (var i = 1; i <= regex.groupCount; i++)
                if (actual[2 * i] == -1)
                  null
                else
                  input.substring(actual[2 * i], actual[2 * i + 1]),
            ],
            expected.groups([for (var i = 1; i <= expected.groupCount; i++) i]),
            reason: reason,
          );
        }
      }
    }

    test('literals', () {
      check('abc', ['', 'abc', 'xxabcxx', 'ababc', 'ab']);
      check('a', ['', 'a', 'ba', 'bb']);
    });

    test('disjunction picks leftmost match', () {
      check('b|a', ['ab', 'ba', 'cc']);
      check('ab|a', ['ab', 'a', 'xab']);
      check('a|ab', ['ab', 'a', 'xab']);
    });

    test('any', () {
      check('a.c', ['abc', 'a\nc', 'ac']);
      check('a.c', ['abc', 'a\nc', 'ac'], dotAll: true);
    });

    test('anchors', () {
      check('^a', ['a', 'ba', 'b\na']);
      check('^a', ['a', 'ba', 'b\na'], multiline: true);
      check(r'a$', ['a', 'ab', 'a\nb']);
      check(r'a$', ['a', 'ab', 'a\nb'], multiline: true);
      check(r'^$', ['', 'a', '\n\n']);
      check(r'^$', ['', 'a', '\n\n'], multiline: true);
    });

    test('case insensitive', () {
      check('aBc', ['abc', 'ABC', 'xAbCx', 'abd'], caseSensitive: false);
    });

    test('greedy quantifiers', () {
      check('a*', ['', 'aaa', 'baa']);
      check('a+', ['', 'aaa', 'baa']);
      check('a?b', ['b', 'ab', 'aab']);
      check('a{2}', ['a', 'aa', 'aaaaa']);
      check('a{2,}', ['a', 'aa', 'aaaaa']);
      check('a{2,3}', ['a', 'aa', 'aaaaa']);
      check('a{9}', ['aaaaaaaa', 'aaaaaaaaa']);
      check('.*c', ['abcabc', 'ab', 'c']);
      check('xa*ay', ['xay', 'xaaaay', 'xy']);
    });

    test('lazy quantifiers', () {
      check('a*?', ['', 'aaa']);
      check('a+?', ['', 'aaa']);
      check('.*?c', ['abcabc', 'ab']);
      check('a{2,3}?', ['aaaa']);
      check('xa*?ay', ['xay', 'xaaaay', 'xy']);
    });

    test('non-capturing groups', () {
      check('x(?:ab)*', ['xababab', 'xa']);
      check('(?:a|ab)c', ['abc', 'ac']);
      check('(?:)', ['', 'a']);
      check('(?:a*)*b', ['aab', 'aac']);
    });

    test('capturing groups', () {
      check('(a)', ['a', 'ba', 'b']);
      check('(a)(b)?', ['a', 'ab']);
      check('(a(b))c', ['abc', 'ab']);
      check('()', ['', 'a']);
      check('(a)b|(a)c', ['ab', 'ac']);
      check('(a|ab)(c|bcd)(d*)', ['abcd']);
    });

    test('quantified groups', () {
      check('(a|b)*', ['abba', '']);
      check('(?:(a)|b)+', ['ab', 'ba']);
      check('(z)((a+)?(b+)?(c))*', ['zaacbbbcac']);
      check('(a*)*', ['b', 'aa']);
      check('(a*)+', ['b', 'aa']);
      check('(a)*?b', ['aab']);
    });

    test('identity escapes', () {
      check(r'a\.b', ['a.b', 'axb']);
      check(r'\(\)\[\]\{\}', ['x()[]{}']);
      check(r'\^\$\\\/\|\*\+\?', [r'^$\/|*+?', '^']);
      check(RegExp.escape(r'1+1=2 (really?)'), ['1+1=2 (really?)', '11=2']);
    });

    test('backreferences', () {
      check(r'(a+)b\1', ['aabaa', 'aaba', 'abaa']);
      check(r'(a)|\1b', ['b', 'a']);
      check(r'\1(a)', ['aa', 'a']);
      check(r'(a\1)', ['a', 'aa']);
      check(r'(?:(a)|b)\1', ['aa', 'b', 'ba']);
      check(r'(.)\1', ['abccd', 'abc']);
      check(r'(a)\1', ['aA', 'Aa', 'AA'], caseSensitive: false);
      check(r'(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)\10', [
        'abcdefghijj',
        'abcdefghija',
      ]);
    });

    test('character escapes and classes', () {
      check(r'\d+', ['abc123def', 'no-digits', '0']);
      check(r'\D+', ['123abc456', '123']);
      check(r'\w+', ['hello_world 123', '---']);
      check(r'\W+', ['hello---world', 'abc_123']);
      check(r'\s+', ['a \t\r\n b', 'nospace']);
      check(r'\S+', ['  hello  ', '   ']);
      check(r'[\t\r\n\x20\u0021]+', [' \t\r\n!abc', 'abc']);
      check(r'[a-z0-9_-]+', ['hello_123-world', 'UPPER']);
      check(r'[a-z]+', ['HeLLo', '123'], caseSensitive: false);
      check(r'[^<]+', ['hello<world>', '<']);
      check(r'[^^]+[a-z]+', ['123abc', '^abc']);
      check(r'[\b]', ['\x08', 'b']);
    });

    test('word boundaries and lookaheads', () {
      check(r'\bword\b', ['a word here', 'sword', 'words']);
      check(r'\Bword\B', ['swords', 'word', 'a word']);
      check(r'\n|\r\n|\r(?!\n)', ['a\nb', 'a\r\nb', 'a\rb']);
      check(r'foo(?=bar)', ['foobar', 'foobaz']);
      check(r'foo(?!bar)', ['foobaz', 'foobar']);
      check(r'(?=(a+))a*b\1', ['aaabaaa', 'aaaba']);
    });

    test('shelf_router and http_parser patterns', () {
      check(r'([^<]*)(?:<([^>|]+)(?:\|([^>]*))?>)?', [
        '/hello/<name>',
        r'/users/<id|[0-9]+>/profile',
        '/static/path',
      ]);
      check(r'[^()<>@,;:"\\/[\]?={} \t\x00-\x1F\x7F]+', [
        'application/json; charset=utf-8',
        'text/plain',
      ]);
      check(r'"(?:[^"\x00-\x1F\x7F\\]|\\.)*"', [
        '"hello \\"world\\""',
        'unquoted',
      ]);
    });
  });

  group('non-simple quantifiers', () {
    // These aren't reachable through the parser yet (they need groups), so
    // we build the nodes manually.
    test('quantified literal', () {
      // (?:ab)*c
      final regex = Regex(
        Concatenation([
          Quantifier(LiteralNode(DartRegexString('ab')), min: 0, max: null),
          MatchSingleCharacter(0x63),
        ]),
      );

      expect(regex.matchAt(DartRegexString('ababc'), 0), [0, 5]);
      expect(regex.matchAt(DartRegexString('abac'), 0), isNull);
      expect(regex.firstMatch(DartRegexString('abac'), 0), [3, 4]);
    });

    test('empty iterations terminate', () {
      // (?:a*)*b
      final regex = Regex(
        Concatenation([
          Quantifier(
            Quantifier(MatchSingleCharacter(0x61), min: 0, max: null),
            min: 0,
            max: null,
          ),
          MatchSingleCharacter(0x62),
        ]),
      );

      expect(regex.firstMatch(DartRegexString('aab'), 0), [0, 3]);
      expect(regex.firstMatch(DartRegexString('aac'), 0), isNull);
    });
  });

  group('captures', () {
    test('are restored when backtracking', () {
      // (a)b|(a)c
      final regex = Regex(
        Disjunction([
          Concatenation([
            CaptureGroup(MatchSingleCharacter(0x61), 1),
            MatchSingleCharacter(0x62),
          ]),
          Concatenation([
            CaptureGroup(MatchSingleCharacter(0x61), 2),
            MatchSingleCharacter(0x63),
          ]),
        ]),
        groupCount: 2,
      );

      expect(regex.matchAt(DartRegexString('ac'), 0), [0, 2, -1, -1, 0, 1]);
      expect(RegExp('(a)b|(a)c').firstMatch('ac')!.group(1), isNull);
    });

    test('are reset on each quantifier iteration', () {
      // (?:(a)|b)+
      final regex = Regex(
        Quantifier(
          Disjunction([
            CaptureGroup(MatchSingleCharacter(0x61), 1),
            MatchSingleCharacter(0x62),
          ]),
          min: 1,
          max: null,
          firstCapture: 1,
          captureCount: 1,
        ),
        groupCount: 1,
      );

      expect(regex.matchAt(DartRegexString('ab'), 0), [0, 2, -1, -1]);
      expect(regex.matchAt(DartRegexString('ba'), 0), [0, 2, 1, 2]);
      expect(RegExp('(?:(a)|b)+').firstMatch('ab')!.group(1), isNull);
    });

    test('last iteration wins', () {
      // (a|b)*
      final regex = Regex(
        Quantifier(
          CaptureGroup(
            Disjunction([
              MatchSingleCharacter(0x61),
              MatchSingleCharacter(0x62),
            ]),
            1,
          ),
          min: 0,
          max: null,
          firstCapture: 1,
          captureCount: 1,
        ),
        groupCount: 1,
      );

      expect(regex.matchAt(DartRegexString('abba'), 0), [0, 4, 3, 4]);
    });
  });

  test('long inputs do not overflow the stack for simple quantifiers', () {
    final input = DartRegexString('${'a' * 1000000}b');
    expect(Regex(parse('a*b')).matchAt(input, 0), [0, 1000001]);
  });
}
