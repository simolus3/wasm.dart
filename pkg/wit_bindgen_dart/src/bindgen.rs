use anyhow::{Result, bail};
use serde::Serialize;
use std::{borrow::Cow, fmt::Write, rc::Rc};
use wit_bindgen_core::{
    WorldGenerator,
    abi::{
        AbiVariant, LiftLower, WasmSignature, call, guest_export_needs_post_return, post_return,
    },
    uwrite, uwriteln,
    wit_parser::{InterfaceId, Resolve, SizeAlign, WorldKey},
};

use crate::{
    abi_export::SerializableAbi,
    dart_source::{DartDefinition, DartSource, KnownDartUri},
    functions::{
        DartFunctionGenerator, ExportedFunctionMode, FunctionMode, ImportedFunctionMode, PostReturn,
    },
};

#[derive(Default, Clone, Serialize)]
pub struct FunctionOptions {
    pub use_memory: bool,
    pub uses_strings: bool,
    /// Only set on lifted (export) functions, a function to clean up temporary values allocated by
    /// this function.
    #[serde(skip_serializing_if = "Option::is_none")]
    pub post_return: Option<String>,
}

#[derive(Serialize)]
pub struct ImportedCoreFunction {
    pub interface_id: usize,
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

#[derive(Serialize)]
pub struct ExportedCoreFunction {
    pub function_name: String,
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

impl DartWorldGenerator {
    pub fn serialize_abi(&self, resolve: &Resolve) -> anyhow::Result<String> {
        Ok(serde_json::to_string(&SerializableAbi {
            resolve,
            imports: &self.function_imports,
            exports: &self.instance_exports,
        })?)
    }
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
                    FunctionMode::Imported(ImportedFunctionMode {
                        core_name: &core_name,
                        function,
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
                        interface_id: iface.index(),
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
        for mut export in &mut self.instance_exports {
            let interface = &resolve.interfaces[export.interface];

            for (name, function) in &interface.functions {
                let this_export_id = export_id;
                export_id += 1;
                let _ = writeln!(
                    def,
                    "@pragma('wasm:export', r'component_{}')",
                    this_export_id
                );
                let abi_variant = if function.kind.is_async() {
                    AbiVariant::GuestExportAsync
                } else {
                    AbiVariant::GuestExport
                };
                let core_signature = resolve.wasm_signature(abi_variant, function);
                def.write_core_signature(
                    &mut self.main,
                    &format!("_component_{}", this_export_id),
                    &core_signature,
                );
                uwriteln!(def, "{{");

                let mut generator = DartFunctionGenerator::new(
                    &self.size_align,
                    &mut self.main,
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

                uwriteln!(&mut def, "{}}}", generator.definition.take_code());
                let mut options = generator.options;
                let allocated_return = generator.allocated_return_value;

                if guest_export_needs_post_return(resolve, function) {
                    let mut generator = DartFunctionGenerator::new(
                        &self.size_align,
                        &mut self.main,
                        FunctionMode::PostReturn(PostReturn {}),
                    );
                    post_return(resolve, function, &mut generator);
                    let code = generator.definition.take_code();
                    options.post_return = Some(format!("component_{this_export_id}_postreturn"));

                    uwriteln!(
                        def,
                        "@pragma('wasm:export', r'component_{this_export_id}_postreturn')",
                    );
                    def.write_core_signature(
                        &mut self.main,
                        &format!("_component_{this_export_id}$postreturn",),
                        &WasmSignature {
                            params: core_signature.results.clone(),
                            results: vec![],
                            indirect_params: false,
                            retptr: false,
                        },
                    );
                    uwrite!(def, "{{\n{code}");
                    let wasm_import = self.main.import(KnownDartUri::DartWasm);

                    if let Some((size, align)) = allocated_return {
                        assert!(core_signature.retptr);
                        def.imported_identifier(
                            &mut self.main,
                            KnownDartUri::PkgWasmComponents,
                            "dartFree",
                        );
                        uwriteln!(
                            &mut def,
                            "(p0, const {wasm_import}.WasmI32({}), const {wasm_import}.WasmI32({}));",
                            size.size_wasm32(),
                            align.align_wasm32(),
                        );
                    }
                    uwriteln!(def, "return {wasm_import}.WasmVoid();");

                    uwriteln!(def, "}}");
                }

                export.functions.push(ExportedCoreFunction {
                    core_export_name: format!("component_{}", this_export_id),
                    function_name: name.clone(),
                    options,
                });
            }
        }

        self.main.consume_definition(def);

        Ok(())
    }
}
