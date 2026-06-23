use std::{env, fs};

use serde::Serialize;
use wasmtime::{
    Config, Result, Store, bail,
    component::{Component, Linker, Val},
    error::Context,
};

fn main() -> Result<()> {
    let Some(file) = env::args().nth(1) else {
        bail!("Usage: cargo run -- file.wasm")
    };

    let mut config = Config::default();
    config.wasm_gc(true);
    config.wasm_function_references(true);
    config.wasm_exceptions(true);

    let engine = wasmtime::Engine::new(&config)?;
    let mut store = Store::new(&engine, ());

    let bytes = fs::read(&file).with_context(|| format!("Reading {file}"))?;
    let component = Component::new(&engine, bytes)?;
    let Some(run_instance_index) = component.get_export_index(None, "wasmdart:tests/tested-module")
    else {
        bail!("Missing tests export");
    };
    let Some(count_test_idx) = component.get_export_index(Some(&run_instance_index), "count-tests")
    else {
        bail!("Missing count-tests");
    };
    let Some(invoke_test_idx) =
        component.get_export_index(Some(&run_instance_index), "invoke-test")
    else {
        bail!("Missing invoke-test");
    };

    let mut linker = Linker::new(&engine);
    {
        let mut root = linker.root();
        let mut collector = root.instance("wasmdart:tests/result-collector")?;
        collector.func_wrap("record-string", |_store, params: (String,)| {
            post_event(&TestEvent::RecordedString { value: params.0 });
            Ok(())
        })?;
        collector.func_wrap("record-double", |_store, params: (f64,)| {
            post_event(&TestEvent::RecordedDouble { value: params.0 });
            Ok(())
        })?;
        collector.func_wrap("record-int", |_store, params: (i64,)| {
            post_event(&TestEvent::RecordedInt { value: params.0 });
            Ok(())
        })?;
    }

    let instance = linker.instantiate(&mut store, &component)?;
    let count = instance.get_func(&mut store, count_test_idx).unwrap();
    let invoke = instance.get_func(&mut store, invoke_test_idx).unwrap();

    let num_tests = {
        let mut results = [Val::Result(Ok(None))];
        count.call(&mut store, &[], &mut results)?;
        let Val::U32(count) = results[0] else {
            panic!();
        };
        count
    };

    for i in 0..num_tests {
        post_event(&TestEvent::TestStart { test: i });
        invoke.call(&mut store, &[Val::U32(i)], &mut []).unwrap();
        post_event(&TestEvent::TestEnd { test: i });
    }

    Ok(())
}

fn post_event(event: &TestEvent) {
    let formatted = serde_json::to_string(event).unwrap();
    println!("{formatted}")
}

#[derive(Serialize)]
#[serde(tag = "type")]
enum TestEvent {
    #[serde(rename = "start")]
    TestStart { test: u32 },
    #[serde(rename = "end")]
    TestEnd { test: u32 },
    #[serde(rename = "string")]
    RecordedString { value: String },
    #[serde(rename = "double")]
    RecordedDouble { value: f64 },
    #[serde(rename = "int")]
    RecordedInt { value: i64 },
}
