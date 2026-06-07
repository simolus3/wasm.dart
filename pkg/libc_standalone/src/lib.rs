/*
Compile with:

RUSTFLAGS="-Zlocation-detail=none -Zfmt-debug=none -Zunstable-options -Cpanic=immediate-abort" cargo +nightly build \
    --release \
    -Z build-std=std,panic_abort \
    -Z build-std-features= \
    --target wasm32-unknown-unknown \
    -p libc_standalone
*/

#![no_std]
pub use libc_common::*;

#[cfg(all(target_family = "wasm"))]
#[global_allocator]
static TALC: talc::wasm::WasmDynamicTalc = talc::wasm::new_wasm_dynamic_allocator();

#[unsafe(no_mangle)]
pub extern "C" fn dart_writeln(_len: usize, _ptr: *const u8) {
    // This is only here temporarily, we'll remove this later.
}
