use core::slice;
use std::alloc::{Layout, alloc, dealloc};

#[unsafe(no_mangle)]
pub extern "C" fn dart_writeln(len: usize, ptr: *const u8) {
    let msg = unsafe { str::from_utf8_unchecked(slice::from_raw_parts(ptr, len)) };
    println!("{msg}")
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_malloc(num_bytes: usize) -> *mut u8 {
    unsafe { alloc(Layout::from_size_align_unchecked(num_bytes, 8)) }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_free(ptr: *mut u8, num_bytes: usize) {
    unsafe { dealloc(ptr, Layout::from_size_align_unchecked(num_bytes, 8)) }
}
