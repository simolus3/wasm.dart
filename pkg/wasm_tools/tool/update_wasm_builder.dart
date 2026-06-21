import 'dart:io';

import 'package:path/path.dart' as p;

void main(List<String> args) async {
  // To update the path itself, run git apply $pathToPatch in your SDK checkout,
  // make changes, then run git diff > $pathToPath

  if (args.length != 1) {
    print('Usage: dart tool/update_wasm_builder.dart <path to SDK checkout>');
    exit(1);
  }

  final sdk = args[0];
  final source = Directory(p.join(sdk, 'pkg', 'wasm_builder', 'lib'));
  final target = Directory('lib/src/third_party/wasm_builder');
  if (target.existsSync()) {
    target.deleteSync(recursive: true);
  }

  for (final file in source.listSync(recursive: true)) {
    if (file is File) {
      final targetPath = p.join(
        target.path,
        p.relative(file.path, from: source.path),
      );
      final parent = Directory(p.dirname(targetPath));
      if (!parent.existsSync()) {
        parent.createSync(recursive: true);
      }

      file.copySync(targetPath);
    }
  }

  Process.runSync('git', [
    'apply',
    '--directory',
    'pkg/wasm_tools/lib/src/third_party/wasm_builder',
    '-p4', // Skip pkg/wasm_builder/lib/src from patch paths
    'assets/wasm_builder.patch',
  ]);
}
