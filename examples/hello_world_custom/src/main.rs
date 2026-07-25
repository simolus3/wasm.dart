use std::fs;

use futures_lite::future::block_on;
use wasmtime::{
    Result, Store, bail,
    component::{Component, Linker, Val},
};
use wasmtime_wasi::{ResourceTable, WasiCtx, WasiCtxView, WasiView};

fn main() -> Result<()> {
    let engine = wasmtime::Engine::default();
    let mut store = Store::new(&engine, DemoState::default());

    let bytes = fs::read("bin/app.wasm")?;
    let component = Component::new(&engine, bytes)?;
    let Some(run_instance_index) = component.get_export_index(None, "wasi:cli/run@0.3.0") else {
        bail!("Expected a wasi:cli/run export");
    };
    let Some(run_func_index) = component.get_export_index(Some(&run_instance_index), "run") else {
        bail!("Did not find run function in cli component");
    };

    let mut linker = Linker::<DemoState>::new(&engine);
    wasmtime_wasi::p3::add_to_linker(&mut linker)?;

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
    block_on(func.call_async(&mut store, &[], &mut results))?;

    println!("Invocation result: {results:?}");
    Ok(())
}

#[derive(Default)]
struct DemoState {
    ctx: WasiCtx,
    table: ResourceTable,
}

impl WasiView for DemoState {
    fn ctx(&mut self) -> wasmtime_wasi::WasiCtxView<'_> {
        WasiCtxView {
            ctx: &mut self.ctx,
            table: &mut self.table,
        }
    }
}
