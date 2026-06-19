use wit_bindgen_core::{Files, WorldGenerator, wit_parser::Resolve};

use crate::bindgen::DartWorldGenerator;

mod abi;
mod bindgen;
mod dart_source;

fn main() -> anyhow::Result<()> {
    let mut resolve = Resolve::default();
    let package = resolve.push_str(
        "test.wit",
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
    )?;

    let world = resolve.select_world(&[package], Some("root"))?;

    let mut generator = DartWorldGenerator::default();
    let mut files = Files::default();
    generator.generate(&mut resolve, world, &mut files)?;

    print!("{}", generator.main);

    Ok(())
}
