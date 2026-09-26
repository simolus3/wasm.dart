import 'package:test/test.dart';

import '../compiler/components/utils.dart';
import 'utils.dart';

import 'package:path/path.dart' as p;

void main() async {
  await for (final file in compiledIntegrationTestComponents) {
    test(p.basename(file.path), () async {
      await validateComponent(file.openRead().cast());
    });
  }
}
