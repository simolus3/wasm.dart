import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _basicMatchAndGroups,
    _namedGroupsAndFlags,
    _replaceAllAndEscape,
    _ecmascriptAndUtf16Indices,
    _edgeCasesAndCompareTo,
  ]);
}

void _basicMatchAndGroups(BaseResultCollector collector) {
  final re = RegExp(r'(\w+)=(\d+)');
  final match = re.firstMatch('foo=42 bar=99')!;
  collector.recordInt(e: match.start);
  collector.recordInt(e: match.end);
  collector.recordInt(e: match.groupCount);
  collector.recordString(e: match.group(0)!);
  collector.recordString(e: match.group(1)!);
  collector.recordString(e: match.group(2)!);

  final all = re.allMatches('a=1 b=22 c=333').map((m) => m.group(2)!).join(',');
  collector.recordString(e: all);

  // Prefix matching (`as_prefix != 0`)
  collector.recordBool(e: re.matchAsPrefix('foo=42', 0) != null);
  collector.recordBool(e: re.matchAsPrefix('!foo=42', 0) == null);
  collector.recordBool(e: '!foo=42'.startsWith(re, 1));

  // Unmatched optional capture group (`-1` bounds)
  final optMatch = RegExp(r'(a)?(b)').firstMatch('b')!;
  collector.recordBool(e: optMatch.group(1) == null);
  collector.recordString(e: optMatch.group(2)!);
}

void _namedGroupsAndFlags(BaseResultCollector collector) {
  final dateRe = RegExp(r'(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})');
  final m = dateRe.firstMatch('Date: 2026-09-26!')!;
  collector.recordString(e: m.namedGroup('year')!);
  collector.recordString(e: m.namedGroup('month')!);
  collector.recordString(e: m.namedGroup('day')!);
  final names = m.groupNames.toList()..sort();
  collector.recordString(e: names.join(','));

  final optNamed = RegExp(r'(?<opt>a)?(?<req>b)').firstMatch('b')!;
  collector.recordBool(e: optNamed.namedGroup('opt') == null);
  collector.recordString(e: optNamed.namedGroup('req')!);

  final ci = RegExp(r'^hello\b', caseSensitive: false, multiLine: true);
  collector.recordBool(e: ci.hasMatch('first line\nHELLO world'));
  collector.recordBool(e: RegExp(r'a.b', dotAll: true).hasMatch('a\nb'));
  collector.recordBool(e: RegExp(r'a.b').hasMatch('a\nb'));
}

void _replaceAllAndEscape(BaseResultCollector collector) {
  collector.recordString(e: 'foo-bar-foo'.replaceAll('foo', 'baz'));
  collector.recordString(e: 'ab'.replaceAll('', '|'));
  collector.recordString(e: 'a1b22c333'.replaceAll(RegExp(r'\d+'), '#'));
  collector.recordString(e: 'ab'.replaceAll(RegExp(r'a*'), 'X'));
  final escaped = RegExp.escape('a-b+c*d?[e]');
  collector.recordString(e: escaped);
  collector.recordBool(e: RegExp('^$escaped\$').hasMatch('a-b+c*d?[e]'));
}

void _ecmascriptAndUtf16Indices(BaseResultCollector collector) {
  // Unescaped `[` inside character class (used by `package:http_parser`) and
  // negated character class (used by `package:shelf_router`).
  final tokenRe = RegExp(r'^[^()<>@,;:"\\/[\]?={} \t]+$');
  collector.recordBool(e: tokenRe.hasMatch('application-json'));
  collector.recordBool(e: tokenRe.hasMatch('bad[token]'));

  // `[^^]` character class followed by `[a-z]+`
  final caretRe = RegExp(r'^[^^]+[a-z]+$');
  collector.recordBool(e: caretRe.hasMatch('123abc'));
  collector.recordBool(e: caretRe.hasMatch('^abc'));

  final routerRe = RegExp(r'/users/(?<id>[^/]+)');
  final routeMatch = routerRe.firstMatch('/users/42')!;
  collector.recordString(e: routeMatch.namedGroup('id')!);

  // Surrogate pair (🚀 is 2 UTF-16 code units, 4 UTF-8 bytes)
  final text = '🚀 hello 🎯 world';
  final wordMatch = RegExp(r'world').firstMatch(text)!;
  collector.recordInt(e: wordMatch.start);
  collector.recordInt(e: wordMatch.end);
  collector.recordString(e: text.substring(wordMatch.start, wordMatch.end));
}

void _edgeCasesAndCompareTo(BaseResultCollector collector) {
  // Empty pattern and empty input string (0-byte allocation paths)
  collector.recordBool(e: RegExp('').hasMatch(''));
  collector.recordBool(e: RegExp('a').hasMatch(''));
  collector.recordString(e: ''.replaceAll(RegExp('a'), 'b'));

  // Invalid pattern throws FormatException
  var threwFormatException = false;
  try {
    // ignore: valid_regexps
    RegExp('(');
  } on FormatException {
    threwFormatException = true;
  }
  collector.recordBool(e: threwFormatException);

  // String.compareTo ordering and prefix length comparison
  collector.recordBool(e: 'apple'.compareTo('banana') < 0);
  collector.recordBool(e: 'banana'.compareTo('apple') > 0);
  collector.recordInt(e: 'apple'.compareTo('apple'));
  collector.recordBool(e: 'ab'.compareTo('abc') < 0);
  collector.recordBool(e: 'abc'.compareTo('ab') > 0);
}
