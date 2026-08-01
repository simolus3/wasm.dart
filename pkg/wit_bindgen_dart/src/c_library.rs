use std::mem;

#[repr(C)]
pub struct ExportResult {
    pub abi_or_error: ExportedString,
    pub is_error: bool,
}

/// A Rust string shared with Dart.
#[derive(Default)]
#[repr(C)]
pub struct ExportedString {
    start: *const u8,
    length: usize,
    capacity: usize,
}

impl ExportedString {
    fn as_string(self) -> String {
        if self.capacity == 0 {
            return String::default();
        }

        unsafe { String::from_raw_parts(self.start.cast_mut(), self.length, self.capacity) }
    }
}

impl From<String> for ExportedString {
    fn from(value: String) -> Self {
        let (start, length, capacity) = String::into_raw_parts(value);
        Self {
            start: start.cast_const(),
            length,
            capacity,
        }
    }
}

impl Drop for ExportedString {
    fn drop(&mut self) {
        drop(mem::take(self).as_string());
    }
}
