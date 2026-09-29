#!/bin/sh
set -e

cd "$(dirname "$0")/.."

RUSTFLAGS="-Zlocation-detail=none -Zfmt-debug=none -Zunstable-options -Cpanic=immediate-abort" \
  cargo +nightly build --release \
    -Zbuild-std=core,alloc,panic_abort \
    -Zbuild-std-features= \
    --target wasm32-unknown-unknown \
    -p runtime_helpers

TARGET_DIR=$(cargo metadata --format-version 1 --no-deps | sed -n 's/.*"target_directory":"\([^"]*\)".*/\1/p')
cp "$TARGET_DIR/wasm32-unknown-unknown/release/runtime_helpers.wasm" assets/
