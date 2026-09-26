#!/bin/sh

RUSTFLAGS="-Zlocation-detail=none -Zfmt-debug=none -Zunstable-options -Cpanic=immediate-abort" \
  cargo +nightly build --release \
    -Zbuild-std=core,alloc,panic_abort \
    -Zbuild-std-features= \
    --config profile.release.lto=true \
    --config 'profile.release.opt-level="z"' \
    --config profile.release.codegen-units=1 \
    --config 'profile.release.strip="symbols"' \
    --target wasm32-unknown-unknown \
    -p runtime_helpers

cp ../../target/wasm32-unknown-unknown/release/runtime_helpers.wasm  assets/
