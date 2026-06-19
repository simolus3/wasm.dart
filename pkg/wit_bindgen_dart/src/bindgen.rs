use anyhow::{Result, bail};
use std::{borrow::Cow, fmt::Write, rc::Rc};
use wit_bindgen_core::{
    WorldGenerator,
    abi::{AbiVariant, LiftLower, call},
    wit_parser::{InterfaceId, SizeAlign, WorldKey},
};

use crate::{
    abi::DartFunctionGenerator,
    dart_source::{DartDefinition, DartSource},
};

pub struct ImportedCoreFunction {
    pub interface: InterfaceId,
    pub function_name: String,
    pub core_name: Rc<String>,
}

#[derive(Default)]
pub struct DartWorldGenerator {
    pub size_align: SizeAlign,
    pub main: DartSource,
    pub function_imports: Vec<ImportedCoreFunction>,
}

impl WorldGenerator for DartWorldGenerator {
    fn import_interface(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        name: &wit_bindgen_core::wit_parser::WorldKey,
        iface: wit_bindgen_core::wit_parser::InterfaceId,
        _files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        let class_name = self.main.define_interface(&resolve, iface);

        let mut def = DartDefinition::default();
        {
            let def = &mut def;
            let _ = writeln!(
                def,
                "final class _Imported${} implements {} {{\n  const _Imported{}();",
                class_name, class_name, class_name
            );

            let interface = &resolve.interfaces[iface];
            for (name, function) in &interface.functions {
                def.write_function_signature(&mut self.main, resolve, name, function);
                let _ = writeln!(def, "{{");
                let mut generator =
                    DartFunctionGenerator::new(self, function, def, iface, name.clone());
                call(
                    resolve,
                    if function.kind.is_async() {
                        AbiVariant::GuestImportAsync
                    } else {
                        AbiVariant::GuestImport
                    },
                    LiftLower::LowerArgsLiftResults,
                    function,
                    &mut generator,
                    function.kind.is_async(),
                );
                generator.write_cleanup();
                let _ = writeln!(def, "}}");
            }

            let _ = writeln!(def, "}}");

            let import_name: Cow<str> = match name {
                WorldKey::Name(name) => name.into(),
                WorldKey::Interface(id) => format!("importedInstance{}", id.index()).into(),
            };
            let _ = writeln!(def, "const {} = _Imported{};", import_name, class_name);
        }
        self.main.consume_definition(def);

        Ok(())
    }

    fn export_interface(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        name: &wit_bindgen_core::wit_parser::WorldKey,
        iface: wit_bindgen_core::wit_parser::InterfaceId,
        files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        Ok(())
    }

    fn import_funcs(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        world: wit_bindgen_core::wit_parser::WorldId,
        funcs: &[(&str, &wit_bindgen_core::wit_parser::Function)],
        files: &mut wit_bindgen_core::Files,
    ) {
    }

    fn export_funcs(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        world: wit_bindgen_core::wit_parser::WorldId,
        funcs: &[(&str, &wit_bindgen_core::wit_parser::Function)],
        files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        bail!("Only instances can be exported")
    }

    fn import_types(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        world: wit_bindgen_core::wit_parser::WorldId,
        types: &[(&str, wit_bindgen_core::wit_parser::TypeId)],
        files: &mut wit_bindgen_core::Files,
    ) {
    }

    fn finish(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        world: wit_bindgen_core::wit_parser::WorldId,
        files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        Ok(())
    }
}
