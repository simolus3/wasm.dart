use std::{fs, task::Poll};

use wasmtime::{
    Result, Store, bail,
    component::{Component, Linker, StreamConsumer, StreamReader, StreamResult, Val},
};
use wasmtime_wasi::{ResourceTable, WasiCtx, WasiCtxView, WasiView};

#[tokio::main]
async fn main() -> Result<()> {
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
        print.func_wrap("forward-to-stdout", |store, params: (StreamReader<u8>,)| {
            println!("got stream");
            params.0.pipe(store, StdoutConsumer)
        })?;
    }

    let instance = linker.instantiate_async(&mut store, &component).await?;
    let func = instance.get_func(&mut store, run_func_index).unwrap();

    store
        .run_concurrent(async |accessor| -> wasmtime::Result<()> {
            let first = async {
                let mut results = [Val::Result(Ok(None))];
                func.call_concurrent(accessor, &[], &mut results)
                    .await
                    .expect("first call failed");
                println!("First invocation result: {results:?}");
            };

            let second = async {
                let mut results = [Val::Result(Ok(None))];
                func.call_concurrent(accessor, &[], &mut results)
                    .await
                    .expect("second call failed");
                println!("Second invocation result: {results:?}");
            };

            let (_, _) = tokio::join!(first, second);
            Ok(())
        })
        .await?
}

struct StdoutConsumer;

impl<D> StreamConsumer<D> for StdoutConsumer {
    type Item = u8;

    fn poll_consume(
        self: std::pin::Pin<&mut Self>,
        _cx: &mut std::task::Context<'_>,
        store: wasmtime::StoreContextMut<D>,
        source: wasmtime::component::Source<'_, Self::Item>,
        finish: bool,
    ) -> Poll<Result<StreamResult>> {
        let mut src = source.as_direct(store);
        let buf = src.remaining();

        println!(
            "Stdout write: {}, {}, {finish}",
            unsafe { str::from_utf8_unchecked(buf) },
            buf.len()
        );

        Poll::Ready(Ok(if finish {
            StreamResult::Dropped
        } else {
            StreamResult::Completed
        }))
    }
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
