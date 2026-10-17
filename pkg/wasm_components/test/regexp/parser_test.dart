import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('alternative', () {
    expect(parse('ab|cd').nodeToString(), 'or(lit(ab), lit(cd))');
  });

  group('quantifier', () {
    test('star', () {
      expect(parse('a*').nodeToString(), 'q(c(0x61), *)');
    });

    test('plus', () {
      expect(parse('a+').nodeToString(), 'q(c(0x61), +)');
    });

    test('question', () {
      expect(parse('a?').nodeToString(), 'q(c(0x61), ?)');
    });

    test('repetition', () {
      expect(parse('a{123}').nodeToString(), 'q(c(0x61), {123})');
      expect(parse('a{123,}').nodeToString(), 'q(c(0x61), {123,})');
      expect(parse('a{123,456}').nodeToString(), 'q(c(0x61), {123, 456})');
      expect(parse('a{123,456}').nodeToString(), 'q(c(0x61), {123, 456})');

      expect(() => parse('a{10,1}'), throwsFormatException);
    });

    test('not a quantifier', () {
      expect(parse('a{123').nodeToString(), 'lit(a{123)');
      expect(parse('a{1, 10}').nodeToString(), 'lit(a{1, 10})');
    });
  });

  group('groups', () {
    test('capturing', () {
      expect(parse('(a)b').nodeToString(), 'cat(g1(c(0x61)), c(0x62))');
      expect(
        parse('(a(b))(c)').nodeToString(),
        'cat(g1(cat(c(0x61), g2(c(0x62)))), g3(c(0x63)))',
      );
      expect(compile('(a(b))(c)').groupCount, 3);
      expect(compile('(?:a)').groupCount, 0);
    });

    test('non-capturing', () {
      expect(parse('x(?:a)b').nodeToString(), 'lit(xab)');
      expect(parse('(?:ab)*').nodeToString(), 'q(lit(ab), *)');
    });

    test('quantifiers know contained groups', () {
      expect(
        parse('(a)((b)|(c))*').nodeToString(),
        'cat(g1(c(0x61)), q(g2(or(g3(c(0x62)), g4(c(0x63)))), *, groups: 2..4))',
      );
    });

    test('unclosed', () {
      expect(() => parse('(a'), throwsFormatException);
      expect(() => parse('(?:a'), throwsFormatException);
      expect(() => parse('a)'), throwsFormatException);
    });

    test('backreferences', () {
      expect(parse(r'(a)\1').nodeToString(), 'cat(g1(c(0x61)), ref(1))');
      // Forward references are allowed
      expect(parse(r'\1(a)').nodeToString(), 'cat(ref(1), g1(c(0x61)))');
      expect(
        parse(r'(a)\1', caseSensitive: false).nodeToString(),
        'cat(g1(c(0x61, 0x41)), ref(1, i))',
      );
    });
  });
}
