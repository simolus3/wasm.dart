use libm::{acos, asin, atan, atan2, cos, exp, log, pow, sin, tan};

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathPow(base: f64, exponent: f64) -> f64 {
    pow(base, exponent)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathAtan2(a: f64, b: f64) -> f64 {
    atan2(a, b)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathSin(a: f64) -> f64 {
    sin(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathCos(a: f64) -> f64 {
    cos(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathTan(a: f64) -> f64 {
    tan(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathAcos(a: f64) -> f64 {
    acos(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathAsin(a: f64) -> f64 {
    asin(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathAtan(a: f64) -> f64 {
    atan(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathExp(a: f64) -> f64 {
    exp(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_mathLog(a: f64) -> f64 {
    log(a)
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_doubleParse(ptr: *const u8, len: usize, out_val: *mut f64) -> i32 {
    if ptr.is_null() || len == 0 || out_val.is_null() {
        return 0;
    }
    let slice = unsafe { core::slice::from_raw_parts(ptr, len) };
    let Ok(s) = core::str::from_utf8(slice) else {
        return 0;
    };
    match s.parse::<f64>() {
        Ok(v) => {
            unsafe { *out_val = v };
            1
        }
        Err(_) => 0,
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn dart_doubleToString(val: f64, out_buf: *mut u8, max_len: usize) -> usize {
    let abs = val.abs();
    let s = if abs >= 1e21 || (abs > 0.0 && abs < 1e-6) {
        let raw = alloc::format!("{:e}", val);
        if let Some((mantissa, exp)) = raw.split_once('e') {
            if exp.starts_with('-') {
                raw
            } else {
                alloc::format!("{mantissa}e+{exp}")
            }
        } else {
            raw
        }
    } else {
        let raw = alloc::format!("{}", val);
        if !raw.contains('.') && !raw.contains('e') {
            alloc::format!("{raw}.0")
        } else {
            raw
        }
    };
    let bytes = s.as_bytes();
    let copy_len = bytes.len().min(max_len);
    if !out_buf.is_null() && copy_len > 0 {
        unsafe {
            core::ptr::copy_nonoverlapping(bytes.as_ptr(), out_buf, copy_len);
        }
    }
    copy_len
}
