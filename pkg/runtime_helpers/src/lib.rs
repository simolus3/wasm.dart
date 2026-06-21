/*
Compile with:

RUSTFLAGS="-Zlocation-detail=none -Zfmt-debug=none -Zunstable-options -Cpanic=immediate-abort" cargo +nightly build \
    --release \
    -Z build-std=std,panic_abort \
    -Z build-std-features= \
    --target wasm32-unknown-unknown \
    -p runtime_helpers
*/

#![no_std]

extern crate alloc;

pub mod memory;

#[cfg(all(target_family = "wasm"))]
#[global_allocator]
static TALC: talc::wasm::WasmDynamicTalc = talc::wasm::new_wasm_dynamic_allocator();
