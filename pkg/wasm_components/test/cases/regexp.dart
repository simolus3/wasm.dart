import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _hasMatch,
    _firstMatch,
    _matchAsPrefix,
    _allMatches,
    _groups,
    _backreferences,
    _flags,
    _escape,
    _invalidPattern,
  ]);
}

void _recordMatch(BaseResultCollector collector, Match? match) {
  if (match == null) {
    collector.recordOptionalString(e: null);
    return;
  }

  collector.recordInt(e: match.start);
  collector.recordInt(e: match.end);
  collector.recordInt(e: match.groupCount);
  for (var i = 0; i <= match.groupCount; i++) {
    collector.recordOptionalString(e: match.group(i));
  }
}

void _hasMatch(BaseResultCollector collector) {
  collector.recordBool(e: RegExp('b+').hasMatch('abbbc'));
  collector.recordBool(e: RegExp('d').hasMatch('abbbc'));
  collector.recordBool(e: RegExp('').hasMatch(''));
}

void _firstMatch(BaseResultCollector collector) {
  _recordMatch(collector, RegExp('b+').firstMatch('abbbc'));
  _recordMatch(collector, RegExp('b+?').firstMatch('abbbc'));
  _recordMatch(collector, RegExp('x|b').firstMatch('abbbc'));
  _recordMatch(collector, RegExp('d').firstMatch('abbbc'));
  _recordMatch(collector, RegExp(r'c$').firstMatch('abbbc'));
  collector.recordOptionalString(e: RegExp('a.*c').stringMatch('xxabcbcx'));
}

void _matchAsPrefix(BaseResultCollector collector) {
  final regexp = RegExp('b+');
  _recordMatch(collector, regexp.matchAsPrefix('abbbc'));
  _recordMatch(collector, regexp.matchAsPrefix('abbbc', 1));
  _recordMatch(collector, regexp.matchAsPrefix('abbbc', 2));
}

void _allMatches(BaseResultCollector collector) {
  collector.recordStringList(
    e: [for (final match in RegExp('a+').allMatches('aabaaab')) match[0]!],
  );
  collector.recordStringList(
    e: [
      for (final match in RegExp('a*').allMatches('baac'))
        '${match.start}-${match.end}',
    ],
  );
  collector.recordStringList(
    e: [
      for (final match in RegExp('^a', multiLine: true).allMatches('ab\nac'))
        '${match.start}',
    ],
  );
}

void _groups(BaseResultCollector collector) {
  _recordMatch(collector, RegExp('(a)(b)?(c)').firstMatch('xacx'));
  _recordMatch(collector, RegExp('(a(b))c').firstMatch('abc'));
  _recordMatch(collector, RegExp('(?:(a)|b)+').firstMatch('ab'));
  _recordMatch(collector, RegExp('(a|b)*').firstMatch('abba'));
  _recordMatch(
    collector,
    RegExp('(z)((a+)?(b+)?(c))*').firstMatch('zaacbbbcac'),
  );

  final match = RegExp('(a)').firstMatch('a') as RegExpMatch;
  collector.recordStringList(e: match.groupNames.toList());
}

void _backreferences(BaseResultCollector collector) {
  _recordMatch(collector, RegExp(r'(.)\1').firstMatch('abccd'));
  _recordMatch(collector, RegExp(r'(a+)b\1').firstMatch('aaabaa'));
  _recordMatch(collector, RegExp(r'\1(a)').firstMatch('a'));
}

void _flags(BaseResultCollector collector) {
  _recordMatch(
    collector,
    RegExp('aBc', caseSensitive: false).firstMatch('xAbC'),
  );
  _recordMatch(
    collector,
    RegExp(r'(a)\1', caseSensitive: false).firstMatch('Aa'),
  );
  _recordMatch(collector, RegExp('a.b').firstMatch('a\nb'));
  _recordMatch(collector, RegExp('a.b', dotAll: true).firstMatch('a\nb'));
  _recordMatch(collector, RegExp(r'a$', multiLine: true).firstMatch('a\nb'));
}

void _escape(BaseResultCollector collector) {
  collector.recordString(e: RegExp.escape('hello'));
  collector.recordString(
    e: RegExp.escape(r'a.b*c+d?e$f^g(h)i[j]k{l}m|n\o/p-q'),
  );
  collector.recordString(e: RegExp.escape('ä.ö'));
  collector.recordString(e: RegExp.escape('👋+'));
  collector.recordBool(e: RegExp(RegExp.escape('1+1=2')).hasMatch('1+1=2'));
}

void _invalidPattern(BaseResultCollector collector) {
  for (final pattern in ['(a', 'a)', '*', 'a{3,1}']) {
    try {
      RegExp(pattern);
      collector.recordBool(e: false);
    } on FormatException {
      collector.recordBool(e: true);
    }
  }
}
