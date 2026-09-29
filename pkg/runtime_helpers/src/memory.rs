use alloc::alloc::{Layout, alloc as allocate, dealloc, handle_alloc_error, realloc};

#[unsafe(no_mangle)]
pub extern "C" fn dart_realloc(
    old_ptr: *mut u8,
    old_len: usize,
    align: usize,
    new_len: usize,
) -> *mut u8 {
    let layout;
    let ptr = unsafe {
        if old_len == 0 {
            if new_len == 0 {
                return align as *mut u8;
            }
            layout = Layout::from_size_align_unchecked(new_len, align);
            allocate(layout)
        } else {
            debug_assert_ne!(new_len, 0, "non-zero old_len requires non-zero new_len!");
            layout = Layout::from_size_align_unchecked(old_len, align);
            realloc(old_ptr, layout, new_len)
        }
    };
    if ptr.is_null() {
        // Print a nice message in debug mode, but in release mode don't
        // pull in so many dependencies related to printing so just emit an
        // `unreachable` instruction.
        if cfg!(debug_assertions) {
            handle_alloc_error(layout);
        } else {
            #[cfg(target_arch = "wasm32")]
            core::arch::wasm32::unreachable();
            #[cfg(not(target_arch = "wasm32"))]
            unreachable!();
        }
    }
    return ptr;
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_free(ptr: *mut u8, num_bytes: usize, align: usize) {
    // dart_realloc returns an aligned placeholder for a zero-size allocation,
    // without allocating a block. Rust's dealloc requires an actual allocation
    // with its original layout, so that placeholder must never reach it.
    if num_bytes == 0 {
        return;
    }
    unsafe { dealloc(ptr, Layout::from_size_align_unchecked(num_bytes, align)) }
}

// These tests use the host system allocator; Wasm uses TALC in lib.rs.
#[cfg(all(test, not(target_family = "wasm")))]
mod tests {
    extern crate std;

    use super::dart_free;
    use core::alloc::{GlobalAlloc, Layout};
    use core::cell::Cell;

    std::thread_local! {
        // Constant initialization and no destructor keep allocator bookkeeping
        // allocation-free. Each test observes only its own pointer and thread.
        static OBSERVED: Cell<Option<(*mut u8, usize)>> = const { Cell::new(None) };
    }

    /// Forwards to the system allocator but records what `dart_free` asked for,
    /// so a test can assert that zero-size blocks never reach the allocator.
    struct RecordingAlloc;

    unsafe impl GlobalAlloc for RecordingAlloc {
        unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
            unsafe { std::alloc::System.alloc(layout) }
        }

        unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
            let _ = OBSERVED.try_with(|observed| {
                if let Some((expected, count)) = observed.get() {
                    if ptr == expected {
                        observed.set(Some((expected, count + 1)));
                    }
                }
            });
            unsafe { std::alloc::System.dealloc(ptr, layout) }
        }
    }

    #[global_allocator]
    static ALLOC: RecordingAlloc = RecordingAlloc;

    fn count_frees(ptr: *mut u8, size: usize, align: usize) -> usize {
        OBSERVED.with(|observed| observed.set(Some((ptr, 0))));
        dart_free(ptr, size, align);
        OBSERVED.with(|observed| observed.take().unwrap().1)
    }

    #[test]
    fn dart_free_ignores_zero_size_blocks() {
        for align in [1, 2, 4, 8, 16] {
            let ptr = super::dart_realloc(core::ptr::null_mut(), 0, align, 0);
            assert_eq!(ptr as usize, align);
            assert_eq!(
                count_frees(ptr, 0, align),
                0,
                "a zero-size free must not reach the allocator"
            );
        }
    }

    #[test]
    fn dart_free_still_frees_nonzero_blocks() {
        // Go through dart_realloc to get a pointer that is genuinely allocated,
        // so the dealloc below is well defined.
        let ptr = super::dart_realloc(core::ptr::null_mut(), 0, 2, 8);
        assert!(!ptr.is_null());

        assert_eq!(
            count_frees(ptr, 8, 2),
            1,
            "a normal free must still reach the allocator"
        );
    }
}
