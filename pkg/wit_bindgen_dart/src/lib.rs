use std::{ffi::c_char, mem::MaybeUninit, ptr::null, slice};

use wit_bindgen_core::{
    Files, WorldGenerator,
    wit_parser::{PackageId, Resolve},
};

use crate::bindgen::DartWorldGenerator;

mod abi_export;
mod bindgen;
mod dart_source;
mod functions;

#[repr(C)]
pub struct GenerateDartOptions {
    pub files: *const ImportFile,
    pub file_count: usize,
    pub main: *const u8,
    pub main_length: usize,
}

#[repr(C)]
pub struct ImportFile {
    pub contents: *const u8,
    pub contents_len: usize,
    pub path: *const u8,
    pub path_len: usize,
    pub is_main: c_char,
}

#[repr(C)]
pub struct ExportResult {
    pub output: *const u8,
    pub output_len: usize,
    pub output_capacity: usize,
    pub abi: *const u8,
    pub abi_len: usize,
    pub abi_capacity: usize,
    pub is_error: c_char,
}

#[unsafe(no_mangle)]
pub extern "C" fn wit_bindgen_dart_gen(
    options: &GenerateDartOptions,
    result: &mut MaybeUninit<ExportResult>,
) {
    let (dart, abi) = match wit_bindgen_dart_internal(options) {
        Ok((dart, abi)) => (dart, abi),
        Err(e) => {
            let e = format!("{e:?}");
            let (output, output_len, output_capacity) = String::into_raw_parts(e);

            result.write(ExportResult {
                output,
                output_len,
                output_capacity,
                abi: null(),
                abi_len: 0,
                abi_capacity: 0,
                is_error: 1,
            });
            return;
        }
    };

    let (output, output_len, output_capacity) = String::into_raw_parts(dart);
    let (abi, abi_len, abi_capacity) = String::into_raw_parts(abi);

    result.write(ExportResult {
        output,
        output_len,
        output_capacity,
        abi,
        abi_len,
        abi_capacity,
        is_error: 0,
    });
}

#[unsafe(no_mangle)]
pub extern "C" fn wit_bindgen_dart_free(options: &ExportResult) {
    drop(unsafe {
        String::from_raw_parts(
            options.output.cast_mut(),
            options.output_len,
            options.output_capacity,
        )
    });
    if !options.abi.is_null() {
        drop(unsafe {
            String::from_raw_parts(
                options.abi.cast_mut(),
                options.abi_len,
                options.abi_capacity,
            )
        });
    }
}

fn wit_bindgen_dart_internal(options: &GenerateDartOptions) -> anyhow::Result<(String, String)> {
    let mut resolve = Resolve::default();

    let world = if options.main.is_null() {
        None
    } else {
        Some(unsafe {
            str::from_utf8_unchecked(slice::from_raw_parts(options.main, options.main_length))
        })
    };
    let input_files = unsafe { slice::from_raw_parts(options.files, options.file_count) };
    let mut main: Vec<PackageId> = vec![];

    for file in input_files {
        let contents = unsafe {
            str::from_utf8_unchecked(slice::from_raw_parts(file.contents, file.contents_len))
        };
        let path =
            unsafe { str::from_utf8_unchecked(slice::from_raw_parts(file.path, file.path_len)) };

        let package_id = resolve.push_str(path, contents)?;
        if file.is_main != 0 {
            main.push(package_id);
        }
    }

    let world = resolve.select_world(&main, world)?;
    let mut generator = DartWorldGenerator::default();
    let mut files = Files::default();
    generator.generate(&mut resolve, world, &mut files)?;

    Ok((
        generator.main.to_string(),
        generator.serialize_abi(&resolve)?,
    ))
}

#[cfg(test)]
mod test {
    use wit_bindgen_core::{Files, WorldGenerator, wit_parser::Resolve};

    use crate::bindgen::DartWorldGenerator;

    fn print_definitions(wit: &str) -> anyhow::Result<()> {
        let mut resolve = Resolve::default();
        let package = resolve.push_str("test.wit", wit)?;

        let world = resolve.select_world(&[package], Some("root"))?;

        let mut generator = DartWorldGenerator::default();
        let mut files = Files::default();
        generator.generate(&mut resolve, world, &mut files)?;

        print!("{}", generator.main);
        Ok(())
    }

    #[test]
    fn playground() {
        print_definitions(
            "
package root:component;

world root {
  import dart:components/print@0.0.1;

  export wasi:cli/run@0.2.12;
}
package dart:components@0.0.1 {
  /// Component that can print stuff.
  interface print {
    /// Prints a message to stdout.
    print: func(line: string);
  }
}

package wasi:cli@0.2.12 {
  interface run {
    run: func() -> result;
  }
}
",
        )
        .expect("Could not generate definitions")
    }

    #[test]
    fn post_return() {
        print_definitions(
            "
package demo:component;

world root {
  export greeting;
}

interface greeting {
  generate-greeting: func() -> string;
}
",
        )
        .expect("Could not generate definitions")
    }
}
