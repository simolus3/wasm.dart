use serde::{
    Serialize,
    ser::{SerializeSeq, SerializeStruct},
};
use wit_bindgen_core::wit_parser::{Function, IndexMap, Interface, Resolve};

use crate::bindgen::{ExportedCoreFunction, ExportedInstance, ImportedCoreFunction};

pub struct SerializableAbi<'a> {
    pub resolve: &'a Resolve,
    pub imports: &'a [ImportedCoreFunction],
    pub exports: &'a [ExportedInstance],
}

impl SerializableAbi<'_> {
    fn interface_name(&self, interface: &Interface) -> String {
        let base_name = interface.name.as_deref().unwrap_or("unknown");
        match interface.package {
            Some(pkg) => {
                let pkg = &self.resolve.packages[pkg];
                pkg.name.interface_id(base_name)
            }
            None => base_name.to_string(),
        }
    }
}

impl<'a> Serialize for SerializableAbi<'a> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let mut s = serializer.serialize_struct("ProgramAbi", 3)?;
        s.serialize_field("type_defs", &SerializableTypes(self.resolve))?;

        let interfaces: Vec<_> = self
            .resolve
            .interfaces
            .iter()
            .map(|(_, iface)| SerializableInterface {
                full_name: self.interface_name(iface),
                exported_functions: &iface.functions,
            })
            .collect();
        s.serialize_field("interfaces", &interfaces)?;

        s.serialize_field("imports", &self.imports)?;

        let exports: Vec<_> = self
            .exports
            .iter()
            .flat_map(|i| {
                i.functions
                    .iter()
                    .map(|f| SerializableExportedInstanceFunction {
                        interface_id: i.interface.index(),
                        function: f,
                    })
            })
            .collect();
        s.serialize_field("exports", &exports)?;

        s.end()
    }
}

struct SerializableTypes<'a>(&'a Resolve);

impl<'a> Serialize for SerializableTypes<'a> {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        let mut seq = serializer.serialize_seq(Some(self.0.types.len()))?;
        for (_, item) in self.0.types.iter() {
            seq.serialize_element(item)?;
        }

        seq.end()
    }
}

#[derive(Serialize)]
struct SerializableInterface<'a> {
    full_name: String,
    exported_functions: &'a IndexMap<String, Function>,
}

#[derive(Serialize)]
struct SerializableExportedInstanceFunction<'a> {
    interface_id: usize,
    #[serde(flatten)]
    function: &'a ExportedCoreFunction,
}
