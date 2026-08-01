use std::{mem::MaybeUninit, slice};

use heck::AsSnakeCase;
use serde::{Deserialize, Serialize};
use wit_bindgen_core::{Files, WorldGenerator, wit_parser::Resolve};

use crate::bindgen::{DartWorldGenerator, ImportsAndExports};

mod abi;
mod bindgen;
mod dart_source;
mod functions;

#[derive(Deserialize, Debug)]
pub struct GenerateDartOptions {
    pub files: Vec<InputFile>,
    pub runs: Vec<GenerationRun>,
}

#[derive(Deserialize, Debug)]
pub struct GenerationRun {
    pub main: Option<String>,
}

#[derive(Deserialize, Debug)]
pub struct InputFile {
    pub contents: String,
    pub path: String,
    pub is_main: bool,
}

#[derive(Serialize, Debug)]
pub enum ExportResult {
    Ok(Vec<GeneratedFile>),
    Err(String),
}

#[derive(Serialize, Debug)]
pub struct GeneratedFile {
    pub kind: GeneratedFileKind,
    pub contents: String,
}

#[derive(Serialize, Debug)]
pub enum GeneratedFileKind {
    AbiJson,
    Package(String),
}

#[repr(C)]
pub struct RawExportResult {
    start: *const u8,
    length: usize,
    capacity: usize,
}

#[unsafe(no_mangle)]
pub extern "C" fn wit_bindgen_dart_gen(
    input_length: usize,
    input_bytes: *const u8,
    result: &mut MaybeUninit<RawExportResult>,
) {
    let input = unsafe { slice::from_raw_parts(input_bytes, input_length) };

    let outputs = match wit_bindgen_dart_internal(input) {
        Ok(files) => ExportResult::Ok(files),
        Err(e) => ExportResult::Err(format!("{e:?}")),
    };

    let serialized = serde_json::to_string(&outputs).expect("should serialize");
    let (start, length, capacity) = String::into_raw_parts(serialized);
    result.write(RawExportResult {
        start: start.cast_const(),
        length,
        capacity,
    });
}

#[unsafe(no_mangle)]
pub extern "C" fn wit_bindgen_dart_free(options: &RawExportResult) {
    drop(unsafe {
        String::from_raw_parts(options.start.cast_mut(), options.length, options.capacity)
    });
}

fn wit_bindgen_dart_internal(options: &[u8]) -> anyhow::Result<Vec<GeneratedFile>> {
    let input: GenerateDartOptions = serde_json::from_slice(options)?;

    let mut resolve = Resolve::default();
    let mut main_packages = vec![];
    for file in input.files {
        let package_id = resolve.push_str(&file.path, &file.contents)?;
        if file.is_main {
            main_packages.push(package_id);
        }
    }

    let mut abi = ImportsAndExports::default();
    let mut outputs = vec![];

    for run in input.runs {
        let world = resolve.select_world(&main_packages, run.main.as_deref())?;

        let mut generator = DartWorldGenerator::new(&mut abi);
        let mut files = Files::default();
        generator.generate(&mut resolve, world, &mut files)?;

        let world = &resolve.worlds[world];
        outputs.push(GeneratedFile {
            kind: GeneratedFileKind::Package(match world.package.as_ref() {
                Some(package) => {
                    let package = &resolve.packages[*package];

                    format!(
                        "{}_{}",
                        AsSnakeCase(&package.name.namespace),
                        AsSnakeCase(&package.name.name)
                    )
                }
                None => "default".to_string(),
            }),
            contents: generator.main.to_string(),
        });
    }

    outputs.push(GeneratedFile {
        kind: GeneratedFileKind::AbiJson,
        contents: abi.serialize_abi(&resolve)?,
    });
    Ok(outputs)
}

#[cfg(test)]
mod test {
    use wit_bindgen_core::{Files, WorldGenerator, wit_parser::Resolve};

    use crate::bindgen::{DartWorldGenerator, ImportsAndExports};

    fn print_definitions(wit: &str) -> anyhow::Result<()> {
        let mut resolve = Resolve::default();
        let package = resolve.push_str("test.wit", wit)?;

        let world = resolve.select_world(&[package], Some("root"))?;

        let mut abi = ImportsAndExports::default();
        let mut generator = DartWorldGenerator::new(&mut abi);
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
    fn async_export() {
        print_definitions(
            "
package root:component;

world root {
  export wasi:cli/run@0.3.0;
}

package wasi:cli@0.3.0 {
  interface run {
    run: async func() -> result;
  }
}
",
        )
        .expect("Could not generate definitions")
    }

    #[test]
    fn streams() {
        print_definitions(
            "
package root:component;

world root {
  import wasi:cli/stdin@0.3.0;
}

package wasi:cli@0.3.0 {
  interface types {
    enum error-code {
      io,
      illegal-byte-sequence,
      pipe
    }
  }

  interface stdin {
    use types.{error-code};
    write-via-stream: func(data: stream<u8>) -> future<result<_, error-code>>;
  }
}
",
        )
        .expect("Could not generate definitions");
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

    #[test]
    fn return_struct() {
        print_definitions(
            "
package demo:component;

world root {
  import greeting;
}

interface greeting {
  record instant {
        seconds: s64,
        nanoseconds: u32,
    }

 now: func() -> instant;
}
",
        )
        .expect("Could not generate definitions")
    }
}
