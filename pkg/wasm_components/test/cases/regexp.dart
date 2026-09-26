import 'package:test_runner/test_runner.dart';

void main() {
  defineTests(const [
    _basicMatchAndGroups,
    _namedGroupsAndFlags,
    _replaceAllAndEscape,
    _ecmascriptAndUtf16Indices,
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
}

void _namedGroupsAndFlags(BaseResultCollector collector) {
  final dateRe = RegExp(r'(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})');
  final m = dateRe.firstMatch('Date: 2026-09-26!')!;
  collector.recordString(e: m.namedGroup('year')!);
  collector.recordString(e: m.namedGroup('month')!);
  collector.recordString(e: m.namedGroup('day')!);
  final names = m.groupNames.toList()..sort();
  collector.recordString(e: names.join(','));

  final ci = RegExp(r'^hello\b', caseSensitive: false, multiLine: true);
  collector.recordBool(e: ci.hasMatch('first line\nHELLO world'));
}

void _replaceAllAndEscape(BaseResultCollector collector) {
  collector.recordString(e: 'foo-bar-foo'.replaceAll('foo', 'baz'));
  collector.recordString(e: 'a1b22c333'.replaceAll(RegExp(r'\d+'), '#'));
  final escaped = RegExp.escape('a+b*c?[d]');
  collector.recordBool(e: RegExp('^$escaped\$').hasMatch('a+b*c?[d]'));
}

void _ecmascriptAndUtf16Indices(BaseResultCollector collector) {
  // Unescaped `[` inside character class (used by `package:http_parser`) and
  // negated character class (used by `package:shelf_router`).
  final tokenRe = RegExp(r'^[^()<>@,;:"\\/[\]?={} \t]+$');
  collector.recordBool(e: tokenRe.hasMatch('application-json'));
  collector.recordBool(e: tokenRe.hasMatch('bad[token]'));

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
