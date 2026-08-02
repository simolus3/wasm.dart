use std::{fmt::Write, rc::Rc};

use wit_bindgen_core::{
    abi::{self, AbiVariant, Bindgen},
    uwrite, uwriteln,
    wit_parser::{Function, Param, Resolve},
};

use crate::{dart_source::KnownDartUri, functions::DartFunctionGenerator};

/// Generates a call to an asynchronous function import, something wit bindgen doesn't support out
/// of the box.
pub fn call_async_import(
    resolve: &Resolve,
    variant: AbiVariant,
    core_name: &str,
    func: &Function,
    bindgen: &mut DartFunctionGenerator,
) {
    assert!(func.kind.is_async());
    let signature = resolve.wasm_signature(variant, func);
    let import = bindgen.dart.import(KnownDartUri::PkgWasmComponents);
    let dart = bindgen.dart.import(KnownDartUri::DartWasm);

    let mut wasm_params: Vec<Rc<String>> = if signature.indirect_params {
        // Parameters are allocated as a single record. Allocate that now.
        let abi = bindgen
            .sizes()
            .record(func.params.iter().map(|Param { ty, .. }| ty));
        let size = abi.size.size_wasm32();
        let align = abi.align.align_wasm32();
        let offsets = bindgen
            .sizes()
            .field_offsets(func.params.iter().map(|Param { ty, .. }| ty));
        let ptr_var = bindgen.temporary_variable();
        uwriteln!(
            &mut bindgen.definition,
            "final {ptr_var} = {import}.mallocAligned(const {dart}.WasmI32({align}), const {dart}.WasmI32({size}));"
        );
        uwriteln!(
            &mut bindgen.cleanup,
            "{import}.dartFree({ptr_var}, const {dart}.WasmI32({size}), const {dart}.WasmI32({align}));"
        );

        for (i, (offset, ty)) in offsets.iter().enumerate() {
            abi::lower_to_memory(
                resolve,
                bindgen,
                Rc::new(format!(
                    "({ptr_var} + const {dart}.WasmI32({}))",
                    offset.size_wasm32()
                )),
                Rc::new(bindgen.get_arg(i)),
                ty,
            );
        }

        vec![ptr_var]
    } else {
        func.params
            .iter()
            .enumerate()
            .flat_map(|(index, param)| {
                abi::lower_flat(resolve, bindgen, Rc::new(bindgen.get_arg(index)), &param.ty)
            })
            .collect()
    };

    let return_ptr = if let Some(return_type) = &func.result {
        let sizes = bindgen.sizes();
        let size = sizes.size(return_type);
        let align = sizes.align(return_type);

        let return_ptr = bindgen.return_pointer(size, align);
        wasm_params.push(return_ptr.clone());
        Some((return_ptr, return_type))
    } else {
        None
    };

    uwrite!(
        &mut bindgen.definition,
        "await {import}.createSubtask({core_name}("
    );
    for (i, param) in wasm_params.iter().enumerate() {
        if i != 0 {
            uwrite!(&mut bindgen.definition, ", ");
        }
        uwrite!(&mut bindgen.definition, "{param}");
    }
    uwriteln!(&mut bindgen.definition, ")).completion;");

    // If we have a return type, lift it from memory now that the subtask has completed.
    if let Some((return_ptr, return_type)) = return_ptr {
        let result = abi::lift_from_memory(resolve, bindgen, return_ptr, return_type);
        bindgen.write_cleanup();
        uwriteln!(&mut bindgen.definition, "return {result};");
    }
}
