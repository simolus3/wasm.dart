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
