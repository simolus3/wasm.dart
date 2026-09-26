use alloc::string::String;
use alloc::vec::Vec;

pub enum CompiledRegExp {
    Success(regex::Regex),
    Error(Vec<u16>), // Store error message as UTF-16 code units
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpCompile(
    pattern_ptr: *const u16,
    pattern_len: usize,
    multi_line: u32,
    case_sensitive: u32,
    unicode: u32,
    dot_all: u32,
) -> *mut CompiledRegExp {
    let slice = unsafe { core::slice::from_raw_parts(pattern_ptr, pattern_len) };
    let raw_pattern = String::from_utf16_lossy(slice);
    let pattern = normalize_ecmascript_pattern(&raw_pattern);

    let mut builder = regex::RegexBuilder::new(&pattern);
    builder.multi_line(multi_line != 0);
    builder.case_insensitive(case_sensitive == 0);
    // Rust's `regex::Regex` operates on UTF-8 `&str` and rejects negated
    // character classes (e.g. `[^<]*` in `package:shelf_router`) when
    // `.unicode(false)` is set ("pattern can match invalid UTF-8").
    let _ = unicode;
    builder.dot_matches_new_line(dot_all != 0);

    let result = match builder.build() {
        Ok(re) => CompiledRegExp::Success(re),
        Err(err) => {
            let err_str = alloc::format!("{}", err);
            let utf16: Vec<u16> = err_str.encode_utf16().collect();
            CompiledRegExp::Error(utf16)
        }
    };

    alloc::boxed::Box::into_raw(alloc::boxed::Box::new(result))
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpFree(handle: *mut CompiledRegExp) {
    if !handle.is_null() {
        unsafe {
            let _ = alloc::boxed::Box::from_raw(handle);
        }
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpIsError(handle: *mut CompiledRegExp) -> u32 {
    let re = unsafe { &*handle };
    match re {
        CompiledRegExp::Error(_) => 1,
        CompiledRegExp::Success(_) => 0,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpGetErrorPtr(handle: *mut CompiledRegExp) -> *const u16 {
    let re = unsafe { &*handle };
    match re {
        CompiledRegExp::Error(s) => s.as_ptr(),
        CompiledRegExp::Success(_) => core::ptr::null(),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpGetErrorLen(handle: *mut CompiledRegExp) -> usize {
    let re = unsafe { &*handle };
    match re {
        CompiledRegExp::Error(s) => s.len(),
        CompiledRegExp::Success(_) => 0,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpGetGroupCount(handle: *mut CompiledRegExp) -> u32 {
    let re = unsafe { &*handle };
    match re {
        CompiledRegExp::Success(regex) => regex.captures_len() as u32 - 1,
        CompiledRegExp::Error(_) => 0,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpGetNamedGroupCount(handle: *mut CompiledRegExp) -> u32 {
    let re = unsafe { &*handle };
    match re {
        CompiledRegExp::Success(regex) => {
            regex.capture_names().filter(|name| name.is_some()).count() as u32
        }
        CompiledRegExp::Error(_) => 0,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpGetNamedGroupInfo(
    handle: *mut CompiledRegExp,
    named_index: u32,
    out_capture_index: *mut u32,
    out_name_utf16_buf: *mut u16,
) -> usize {
    let re = unsafe { &*handle };
    match re {
        CompiledRegExp::Success(regex) => {
            let mut current_named_index = 0;
            for (cap_index, name_opt) in regex.capture_names().enumerate() {
                if let Some(name) = name_opt {
                    if current_named_index == named_index {
                        let utf16: Vec<u16> = name.encode_utf16().collect();
                        unsafe {
                            *out_capture_index = cap_index as u32;
                            if !out_name_utf16_buf.is_null() {
                                core::ptr::copy_nonoverlapping(
                                    utf16.as_ptr(),
                                    out_name_utf16_buf,
                                    utf16.len(),
                                );
                            }
                        }
                        return utf16.len();
                    }
                    current_named_index += 1;
                }
            }
            0
        }
        CompiledRegExp::Error(_) => 0,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_regexpMatch(
    handle: *mut CompiledRegExp,
    string_ptr: *const u16,
    string_len: usize,
    start_utf16: usize,
    as_prefix: u32,
    out_ptr: *mut i32,
) -> u32 {
    let re = unsafe { &*handle };
    let regex = match re {
        CompiledRegExp::Success(regex) => regex,
        CompiledRegExp::Error(_) => return 0,
    };

    let slice = unsafe { core::slice::from_raw_parts(string_ptr, string_len) };
    let s = String::from_utf16_lossy(slice);

    let utf16_indices = build_utf16_indices(&s);

    let start_utf8 = utf16_to_utf8_index(&utf16_indices, start_utf16);
    if start_utf8 > s.len() {
        return 0;
    }

    let captures = if as_prefix != 0 {
        if let Some(caps) = regex.captures_at(&s, start_utf8) {
            if let Some(m0) = caps.get(0) {
                if m0.start() == start_utf8 {
                    Some(caps)
                } else {
                    None
                }
            } else {
                None
            }
        } else {
            None
        }
    } else {
        regex.captures_at(&s, start_utf8)
    };

    if let Some(caps) = captures {
        let num_groups = regex.captures_len();
        unsafe {
            for i in 0..num_groups {
                if let Some(m) = caps.get(i) {
                    let start_val = utf16_indices[m.start()] as i32;
                    let end_val = utf16_indices[m.end()] as i32;
                    *out_ptr.add(i * 2) = start_val;
                    *out_ptr.add(i * 2 + 1) = end_val;
                } else {
                    *out_ptr.add(i * 2) = -1;
                    *out_ptr.add(i * 2 + 1) = -1;
                }
            }
        }
        1
    } else {
        0
    }
}

fn build_utf16_indices(s: &str) -> Vec<usize> {
    let mut utf16_indices = Vec::with_capacity(s.len() + 1);
    let mut utf16_idx = 0;
    for c in s.chars() {
        let utf8_len = c.len_utf8();
        let utf16_len = c.len_utf16();
        for _ in 0..utf8_len {
            utf16_indices.push(utf16_idx);
        }
        utf16_idx += utf16_len;
    }
    utf16_indices.push(utf16_idx);
    utf16_indices
}

fn utf16_to_utf8_index(utf16_indices: &[usize], utf16_target: usize) -> usize {
    let mut low = 0;
    let mut high = utf16_indices.len();
    while low < high {
        let mid = low + (high - low) / 2;
        if utf16_indices[mid] < utf16_target {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    low
}

/// Escapes unescaped `[` inside `[...]` character classes so ECMAScript/Dart
/// regex patterns (such as `package:http_parser`'s `[^()<>@,;:"\\/[\]?={} ...]+`)
/// compile cleanly under Rust's `regex` crate.
fn normalize_ecmascript_pattern(pattern: &str) -> String {
    let mut out = String::with_capacity(pattern.len() + 4);
    let mut in_char_class = false;
    let mut class_start = false;
    let mut can_negate = false;
    let mut escaped = false;

    for c in pattern.chars() {
        if escaped {
            out.push(c);
            escaped = false;
            class_start = false;
            can_negate = false;
        } else if c == '\\' {
            out.push('\\');
            escaped = true;
        } else if !in_char_class {
            if c == '[' {
                out.push('[');
                in_char_class = true;
                class_start = true;
                can_negate = true;
            } else {
                out.push(c);
            }
        } else if can_negate && c == '^' {
            out.push('^');
            can_negate = false;
        } else if c == ']' && !class_start {
            out.push(']');
            in_char_class = false;
        } else if c == '[' {
            out.push('\\');
            out.push('[');
            class_start = false;
            can_negate = false;
        } else {
            out.push(c);
            class_start = false;
            can_negate = false;
        }
    }
    out
}

