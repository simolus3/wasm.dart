use std::fs;

use wasmtime::{
    Config, Result, Store, bail,
    component::{Component, Linker, Val},
};

fn main() -> Result<()> {
    let mut config = Config::default();
    config.wasm_gc(true);
    config.wasm_function_references(true);
    config.wasm_exceptions(true);

    let engine = wasmtime::Engine::new(&config)?;
    let mut store = Store::new(&engine, ());

    let bytes = fs::read("bin/app.wasm")?;
    let component = Component::new(&engine, bytes)?;
    let Some(run_instance_index) = component.get_export_index(None, "wasi:cli/run@0.2.12") else {
        bail!("Expected a wasi:cli/run export");
    };
    let Some(run_func_index) = component.get_export_index(Some(&run_instance_index), "run") else {
        bail!("Did not find run function in cli component");
    };

    let mut linker = Linker::new(&engine);
    {
        let mut root = linker.root();
        let mut print = root.instance("dart:components/print@0.0.1")?;
        print.func_wrap("print", |_store, params: (String,)| {
            println!("{}", &params.0);
            Ok(())
        })?;
    }

    let instance = linker.instantiate(&mut store, &component)?;
    let func = instance.get_func(&mut store, run_func_index).unwrap();

    let mut results = [Val::Result(Ok(None))];
    func.call(&mut store, &[], &mut results)?;

    println!("Invocation result: {results:?}");
    Ok(())
}
