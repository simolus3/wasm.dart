use std::collections::HashMap;

use serde::{Serialize, Serializer};
use wit_bindgen_core::wit_parser::{InterfaceId, Param, Resolve, Type};

#[derive(Serialize, Debug)]
pub struct PackageAbiWithWorld<'a> {
    pub imports: &'a [ImportedFunction],
    pub exports: &'a [ExportedInstance],
    pub world: &'a Resolve,
}

#[derive(Serialize, Default, Debug, Clone)]
pub struct CanonicalOptions {
    /// Whether tio add a `memory` option. We only support a single memory instance which is
    /// imported from a libc module.
    pub uses_memory: bool,
    /// Whether to add a `string-encoding=utf16` option.
    pub uses_strings: bool,
    pub uses_realloc: bool,
    /// Whether to add the `async` option.
    pub is_async: bool,
    pub uses_callback: bool,
    /// Only set on lifted (export) functions, a function to clean up temporary values allocated by
    /// this function.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub post_return: Option<String>,
}

/// A function used to instantiate the Dart module.
#[derive(Serialize, Debug)]
pub struct ImportedFunction {
    /// The name of the (core WebAssembly) import. The namespace is always `component`.
    pub import_name: String,
    pub definition: ImportedFunctionDefinition,
    pub lower_options: CanonicalOptions,
}

#[derive(Serialize, Debug)]
pub enum ImportedFunctionDefinition {
    /// A function is lowered from the exports of an imported instance.
    Instance(ImportedFromInstance),
    TaskReturn {
        result_list: Vec<Type>,
    },
    StreamNew {
        stream_type: usize,
    },
    StreamRead {
        stream_type: usize,
    },
    StreamWrite {
        stream_type: usize,
    },
    StreamCancelRead {
        stream_type: usize,
    },
    StreamCancelWrite {
        stream_type: usize,
    },
    StreamDropReadable {
        stream_type: usize,
    },
    StreamDropWritable {
        stream_type: usize,
    },
    FutureNew {
        future_type: usize,
    },
    FutureRead {
        future_type: usize,
    },
    FutureWrite {
        future_type: usize,
    },
    FutureDropReadable {
        future_type: usize,
    },
    FutureDropWritable {
        future_type: usize,
    },
}

#[derive(Debug, Serialize)]
pub struct ImportedFromInstance {
    /// The interface from which the function is being imported.
    #[serde(serialize_with = "serialize_interface")]
    pub interface: InterfaceId,
    pub function_name: String,
}

#[derive(Serialize, Debug, Clone)]
pub struct LiftedFunction {
    /// The name of the (core WebAssembly) function export.
    pub exported_name: String,
    pub options: CanonicalOptions,
    pub parameters: Vec<Param>,
    pub result: Option<Type>,
}

/// An component instance derived from lifted core functions.
#[derive(Serialize, Debug)]
pub struct ExportedInstance {
    #[serde(serialize_with = "serialize_interface")]
    pub implements: InterfaceId,
    pub functions: HashMap<String, LiftedFunction>,
}

fn serialize_interface<S: Serializer>(id: &InterfaceId, s: S) -> Result<S::Ok, S::Error> {
    s.serialize_u32(id.index() as u32)
}
