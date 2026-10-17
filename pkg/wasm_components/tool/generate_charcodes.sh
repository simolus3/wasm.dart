#!/bin/sh

echo -e "@internal\nimport 'package:meta/meta.dart';\n" > lib/src/embedder/charcodes.dart
dart run charcode '\n\r09azAZe.,*:?!=<>()/[]{}|^$\+-' >> lib/src/embedder/charcodes.dart
