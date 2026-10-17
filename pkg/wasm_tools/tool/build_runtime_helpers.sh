#!/bin/sh
set -e

RUSTFLAGS="-Zlocation-detail=none -Zfmt-debug=none -Zunstable-options -Cpanic=immediate-abort" \
  cargo +nightly build --release \
    -Zbuild-std=core,alloc,panic_abort \
    -Zbuild-std-features= \
    --target wasm32-unknown-unknown \
    -p runtime_helpers

TARGET_DIR=$(cargo metadata --format-version 1 --no-deps | jq '.target_directory' -r)
cp "$TARGET_DIR/wasm32-unknown-unknown/release/runtime_helpers.wasm" assets/
