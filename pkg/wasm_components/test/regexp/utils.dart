import 'package:wasm_components/src/embedder/regex/assertion.dart';
import 'package:wasm_components/src/embedder/regex/character.dart';
import 'package:wasm_components/src/embedder/regex/literal.dart';
import 'package:wasm_components/src/embedder/regex/parser.dart';
import 'package:wasm_components/src/embedder/regex/quantifier.dart';
import 'package:wasm_components/src/embedder/regex/regex.dart';

final class DartRegexString(final String string) extends RegexString {
  @override
  int codeUnitAtUnchecked(int offset) => string.codeUnitAt(offset);

  @override
  bool get isOneByteString => false; // No way to tell

  @override
  int get length => string.length;

  @override
  String toString() {
    return string;
  }
}

Node parse(
  String source, {
  bool multiline = false,
  bool caseSensitive = true,
  bool unicode = false,
  bool dotAll = false,
}) {
  return compile(
    source,
    multiline: multiline,
    caseSensitive: caseSensitive,
    unicode: unicode,
    dotAll: dotAll,
  ).root;
}

Regex compile(
  String source, {
  bool multiline = false,
  bool caseSensitive = true,
  bool unicode = false,
  bool dotAll = false,
}) {
  return RegexParser(
    DartRegexString(source),
    RegexParseOptions(
      multiline: multiline,
      caseSensitive: caseSensitive,
      unicode: unicode,
      dotAll: dotAll,
    ),
    (codeUnits, _) => DartRegexString(.fromCharCodes(codeUnits)),
  ).parse();
}

extension DumpIR on Node {
  void writeTo(StringBuffer buffer) {
    final node = this;
    switch (node) {
      case Disjunction(:final options):
        buffer.write('or(');
        for (final (i, option) in options.indexed) {
          if (i != 0) buffer.write(', ');

          option.writeTo(buffer);
        }
        buffer.write(')');
      case Concatenation(:final terms):
        buffer.write('cat(');
        for (final (i, term) in terms.indexed) {
          if (i != 0) buffer.write(', ');

          term.writeTo(buffer);
        }
        buffer.write(')');
      case Quantifier(
        :final node,
        :final min,
        :final max,
        :final greedy,
        :final firstCapture,
        :final captureCount,
      ):
        buffer.write('q(');
        node.writeTo(buffer);
        buffer.write(', ');

        buffer.write(switch ((min, max)) {
          (0, null) => '*',
          (0, 1) => '?',
          (1, null) => '+',
          (final min, null) => '{$min,}',
          (final min, final max) when min == max => '{$min}',
          (final min, final max) => '{$min, $max}',
        });
        if (!greedy) {
          buffer.write('?');
        }
        if (captureCount != 0) {
          buffer.write(
            ', groups: $firstCapture..${firstCapture + captureCount - 1}',
          );
        }
        buffer.write(')');
      case CaptureGroup(:final inner, :final index):
        buffer.write('g$index(');
        inner.writeTo(buffer);
        buffer.write(')');
      case BackReference(:final index, :final ignoreCase):
        buffer.write('ref($index${ignoreCase ? ', i' : ''})');
      case WordBoundary(:final inverted):
        buffer.write(inverted ? r'\B' : r'\b');
      case Lookahead(:final inner, :final positive):
        buffer.write(positive ? '(?=' : '(?!');
        inner.writeTo(buffer);
        buffer.write(')');
      case LiteralNode(:final needle):
        buffer.write('lit($needle)');
      case MatchAny(:final dotAll):
        buffer.write('any(dotAll: $dotAll)');
      case MatchSingleCharacter(:final codeUnit):
        buffer.write('c(0x${codeUnit.toRadixString(16)})');
      case MatchCharacterInList(:final charCodes):
        buffer.write(
          'c(${charCodes.map((e) => '0x${e.toRadixString(16)}').join(', ')})',
        );
      case MatchDigit(:final inverted):
        buffer.write(inverted ? r'\D' : r'\d');
      case MatchWord(:final inverted):
        buffer.write(inverted ? r'\W' : r'\w');
      case MatchSpace(:final inverted):
        buffer.write(inverted ? r'\S' : r'\s');
      case CharacterClass(:final ranges, :final escapes, :final negated):
        buffer.write(negated ? '[^' : '[');
        for (final range in ranges) {
          if (range.start == range.end) {
            buffer.write('0x${range.start.toRadixString(16)}');
          } else {
            buffer.write(
              '0x${range.start.toRadixString(16)}-0x${range.end.toRadixString(16)}',
            );
          }
          buffer.write(' ');
        }
        for (final escape in escapes) {
          escape.writeTo(buffer);
          buffer.write(' ');
        }
        buffer.write(']');
      default:
        throw UnimplementedError('Unknown node type');
    }
  }

  String nodeToString() {
    final buffer = StringBuffer();
    writeTo(buffer);
    return buffer.toString();
  }
}
