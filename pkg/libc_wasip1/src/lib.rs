use core::slice;
pub use libc_common::*;

#[unsafe(no_mangle)]
pub extern "C" fn dart_writeln(len: usize, ptr: *const u8) {
    let msg = unsafe { str::from_utf8_unchecked(slice::from_raw_parts(ptr, len)) };
    println!("{msg}")
}
