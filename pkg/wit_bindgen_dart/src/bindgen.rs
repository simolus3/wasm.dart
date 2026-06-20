use anyhow::{Result, bail};
use std::{borrow::Cow, fmt::Write, mem, rc::Rc};
use wit_bindgen_core::{
    WorldGenerator,
    abi::{AbiVariant, LiftLower, call, guest_export_needs_post_return},
    uwrite, uwriteln,
    wit_parser::{InterfaceId, SizeAlign, WorldKey},
};

use crate::{
    abi::{DartFunctionGenerator, ExportedFunctionMode, FunctionMode, ImportedFunctionMode},
    dart_source::{DartDefinition, DartSource},
};

#[derive(Default, Clone)]
pub struct FunctionOptions {
    pub use_memory: bool,
    pub uses_strings: bool,
}

pub struct ImportedCoreFunction {
    pub interface: InterfaceId,
    pub function_name: String,
    pub core_name: Rc<String>,
    pub options: FunctionOptions,
}

pub struct ExportedInstance {
    /// The private top-level Dart variable storing the instance to export.
    pub field_name: String,
    /// The generated interface of the instance to export.
    pub class_name: Rc<String>,
    pub interface: InterfaceId,
    pub functions: Vec<ExportedCoreFunction>,
}

impl ExportedInstance {
    pub fn public_field_name(&self) -> &str {
        assert!(self.field_name.chars().nth(0) == Some('_'));
        &self.field_name[1..]
    }
}

pub struct ExportedCoreFunction {
    pub core_export_name: String,
    pub options: FunctionOptions,
}

#[derive(Default)]
pub struct DartWorldGenerator {
    pub size_align: SizeAlign,
    pub main: DartSource,
    pub function_imports: Vec<ImportedCoreFunction>,
    pub instance_exports: Vec<ExportedInstance>,
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
                "final class _Imported${} implements {} {{\n  const _Imported${}();",
                class_name, class_name, class_name
            );

            let interface = &resolve.interfaces[iface];
            for (name, function) in &interface.functions {
                let variant = if function.kind.is_async() {
                    AbiVariant::GuestImportAsync
                } else {
                    AbiVariant::GuestImport
                };
                let core_name = Rc::new(format!("_import{}", self.function_imports.len()));

                uwriteln!(def, "@override");
                def.write_function_signature(&mut self.main, resolve, name, function);
                let _ = writeln!(def, "{{");
                let mut generator = DartFunctionGenerator::new(
                    &self.size_align,
                    &mut self.main,
                    function,
                    iface,
                    FunctionMode::Imported(ImportedFunctionMode {
                        function_name: name.clone(),
                        core_name: &core_name,
                    }),
                );
                call(
                    resolve,
                    variant,
                    LiftLower::LowerArgsLiftResults,
                    function,
                    &mut generator,
                    function.kind.is_async(),
                );
                generator.write_cleanup();
                let _ = writeln!(def, "{}\n}}", generator.definition.take_code());

                {
                    let options = generator.options;
                    let signature = resolve.wasm_signature(variant, function);
                    let mut import = DartDefinition::default();
                    uwriteln!(
                        &mut import,
                        "@pragma(\"wasm:import\", r\"component.{}\")",
                        core_name
                    );
                    uwrite!(&mut import, "external ");
                    import.write_core_signature(&mut self.main, &core_name, &signature);
                    let _ = writeln!(&mut import, ";");
                    self.main.consume_definition(import);

                    self.function_imports.push(ImportedCoreFunction {
                        interface: iface,
                        function_name: name.to_string(),
                        core_name: core_name.clone(),
                        options,
                    });
                }
            }

            let _ = writeln!(def, "}}");

            let import_name: Cow<str> = match name {
                WorldKey::Name(name) => name.into(),
                WorldKey::Interface(id) => format!("importedInstance{}", id.index()).into(),
            };
            let _ = writeln!(def, "const {} = _Imported${}();", import_name, class_name);
        }
        self.main.consume_definition(def);

        Ok(())
    }

    fn export_interface(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        name: &wit_bindgen_core::wit_parser::WorldKey,
        iface: wit_bindgen_core::wit_parser::InterfaceId,
        _files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        let class_name = self.main.define_interface(&resolve, iface);
        let field_name = match name {
            WorldKey::Name(name) => format!("_{}", name),
            WorldKey::Interface(id) => format!("_unnamedExport{}", id.index()),
        };

        {
            let mut def = DartDefinition::default();
            let _ = writeln!(&mut def, "late {} {};", class_name, field_name);
            self.main.consume_definition(def);
        }

        self.instance_exports.push(ExportedInstance {
            field_name,
            class_name,
            interface: iface,
            functions: Default::default(),
        });
        Ok(())
    }

    fn import_funcs(
        &mut self,
        _resolve: &wit_bindgen_core::wit_parser::Resolve,
        _world: wit_bindgen_core::wit_parser::WorldId,
        _funcs: &[(&str, &wit_bindgen_core::wit_parser::Function)],
        _files: &mut wit_bindgen_core::Files,
    ) {
    }

    fn export_funcs(
        &mut self,
        _resolve: &wit_bindgen_core::wit_parser::Resolve,
        _world: wit_bindgen_core::wit_parser::WorldId,
        _funcs: &[(&str, &wit_bindgen_core::wit_parser::Function)],
        _files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        bail!("Only instances can be exported")
    }

    fn import_types(
        &mut self,
        _resolve: &wit_bindgen_core::wit_parser::Resolve,
        _world: wit_bindgen_core::wit_parser::WorldId,
        _types: &[(&str, wit_bindgen_core::wit_parser::TypeId)],
        _files: &mut wit_bindgen_core::Files,
    ) {
    }

    fn finish(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        _world: wit_bindgen_core::wit_parser::WorldId,
        _files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        if self.instance_exports.is_empty() {
            return Ok(());
        }

        // Generate defineInstanceExport to set instance fields, users are supposed to call it in
        // their main() function.
        let mut def = DartDefinition::default();
        {
            let def = &mut def;
            let _ = write!(def, "void defineInstanceExport({{");
            for export in &self.instance_exports {
                let _ = write!(
                    def,
                    "required {} {},",
                    export.class_name,
                    export.public_field_name()
                );
            }
            let _ = writeln!(def, "}}) {{");
            for export in &self.instance_exports {
                let _ = writeln!(
                    def,
                    "  {} = {};",
                    export.field_name,
                    export.public_field_name()
                );
            }
            let _ = writeln!(def, "}}");
        }

        let mut export_id = 0usize;
        for mut export in mem::take(&mut self.instance_exports) {
            let interface = &resolve.interfaces[export.interface];

            for (_, function) in &interface.functions {
                let needs_post_return = guest_export_needs_post_return(resolve, function);
                if needs_post_return {
                    todo!()
                }

                let _ = writeln!(def, "@pragma('wasm:export', r'component_{}')", export_id);
                let abi_variant = if function.kind.is_async() {
                    AbiVariant::GuestExportAsync
                } else {
                    AbiVariant::GuestExport
                };
                let core_signature = resolve.wasm_signature(abi_variant, function);
                def.write_core_signature(
                    &mut self.main,
                    &format!("_component_{}", export_id),
                    &core_signature,
                );
                uwriteln!(def, "{{");

                export_id += 1;

                let mut generator = DartFunctionGenerator::new(
                    &self.size_align,
                    &mut self.main,
                    function,
                    export.interface,
                    FunctionMode::Exported(ExportedFunctionMode {
                        instance: &mut export,
                    }),
                );
                call(
                    resolve,
                    abi_variant,
                    LiftLower::LiftArgsLowerResults,
                    function,
                    &mut generator,
                    function.kind.is_async(),
                );
                generator.write_cleanup();
                let _ = write!(&mut def, "{}}}", generator.definition.take_code());
            }
        }

        self.main.consume_definition(def);

        Ok(())
    }
}
