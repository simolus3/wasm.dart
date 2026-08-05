use anyhow::{Result, bail};
use std::{borrow::Cow, collections::HashMap, fmt::Write, mem, rc::Rc};
use wit_bindgen_core::{
    WorldGenerator,
    abi::{
        AbiVariant, LiftLower, WasmSignature, call, guest_export_needs_post_return,
        lift_from_memory, lower_to_memory, post_return,
    },
    uwrite, uwriteln,
    wit_parser::{InterfaceId, Resolve, SizeAlign, Type, TypeDefKind, TypeId, WorldKey},
};

use crate::{
    abi::{
        CanonicalOptions, ImportedFromInstance, ImportedFunction, ImportedFunctionDefinition,
        LiftedFunction, PackageAbiWithWorld,
    },
    call_async::call_async_import,
    dart_source::{DartDefinition, DartSource, ImportMap, KnownDartUri},
    functions::{
        DartFunctionGenerator, ExportedFunctionMode, FunctionMode, ImportedFunctionMode, PostReturn,
    },
};

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

    pub fn to_abi_export(&self) -> crate::abi::ExportedInstance {
        let mut functions = HashMap::new();
        for export in &self.functions {
            functions.insert(export.function_name.clone(), export.lifted.clone());
        }

        crate::abi::ExportedInstance {
            implements: self.interface,
            functions,
        }
    }
}

pub struct ExportedCoreFunction {
    /// The function in the interface type.
    pub function_name: String,
    pub lifted: LiftedFunction,
}

pub struct DartWorldGenerator<'a> {
    pub size_align: SizeAlign,
    pub main: DartSource<'a>,
    pub io: &'a mut ImportsAndExports,
    pub local_exports: Vec<ExportedInstance>,
}

#[derive(Default)]
pub struct ImportsAndExports {
    pub imports: Vec<ImportedFunction>,
    pub exports: Vec<ExportedInstance>,
}

impl<'a> DartWorldGenerator<'a> {
    pub fn new(io: &'a mut ImportsAndExports, map: &'a ImportMap) -> Self {
        Self {
            size_align: Default::default(),
            main: DartSource::new(map),
            io,
            local_exports: Default::default(),
        }
    }

    fn define_stream_vtable(&mut self, resolve: &Resolve, id: TypeId, inner_type: Option<Type>) {
        let id_str = format!("{}", id.index());
        let vtable_name = Rc::new(format!("_Vtable{}", id_str));
        let mut definition = DartDefinition::default();
        let rt_import = self.main.import(KnownDartUri::PkgWasmComponents);
        let wasm_import = self.main.import(KnownDartUri::DartWasm);

        uwrite!(
            &mut definition,
            "
@pragma('wasm:import', 'component.stream{id_str}.new')
external {wasm_import}.WasmI64 _streamNew{id_str}();
@pragma('wasm:import', 'component.stream{id_str}.read')
external {wasm_import}.WasmI32 _streamRead{id_str}({wasm_import}.WasmI32 stream, {wasm_import}.WasmI32 ptr, {wasm_import}.WasmI32 n);
@pragma('wasm:import', 'component.stream{id_str}.write')
external {wasm_import}.WasmI32 _streamWrite{id_str}({wasm_import}.WasmI32 stream, {wasm_import}.WasmI32 ptr, {wasm_import}.WasmI32 n);
@pragma('wasm:import', 'component.stream{id_str}.drop-readable')
external {wasm_import}.WasmVoid _streamDropReadable{id_str}({wasm_import}.WasmI32 stream);
@pragma('wasm:import', 'component.stream{id_str}.drop-writable')
external {wasm_import}.WasmVoid _streamDropWritable{id_str}({wasm_import}.WasmI32 stream);

final class {vtable_name} implements {rt_import}.StreamVtable<"
        );
        self.io.imports.push(ImportedFunction {
            import_name: format!("stream{id_str}.new"),
            definition: ImportedFunctionDefinition::StreamNew {
                stream_type: id.index(),
            },
            lower_options: Default::default(),
        });
        let mut read_write_options = CanonicalOptions::default();
        read_write_options.is_async = true;
        read_write_options.uses_memory = inner_type.is_some();

        self.io.imports.push(ImportedFunction {
            import_name: format!("stream{id_str}.read"),
            definition: ImportedFunctionDefinition::StreamRead {
                stream_type: id.index(),
            },
            lower_options: read_write_options.clone(),
        });
        self.io.imports.push(ImportedFunction {
            import_name: format!("stream{id_str}.write"),
            definition: ImportedFunctionDefinition::StreamWrite {
                stream_type: id.index(),
            },
            lower_options: read_write_options.clone(),
        });
        self.io.imports.push(ImportedFunction {
            import_name: format!("stream{id_str}.drop-readable"),
            definition: ImportedFunctionDefinition::StreamDropReadable {
                stream_type: id.index(),
            },
            lower_options: Default::default(),
        });
        self.io.imports.push(ImportedFunction {
            import_name: format!("stream{id_str}.drop-writable"),
            definition: ImportedFunctionDefinition::StreamDropWritable {
                stream_type: id.index(),
            },
            lower_options: Default::default(),
        });

        definition.write_stream_element_type(&mut self.main, resolve, inner_type.as_ref());
        uwriteln!(&mut definition, "> {{");
        uwriteln!(&mut definition, "  const {vtable_name}();");

        if let Some(inner) = &inner_type {
            let size = self.size_align.size(inner).size_wasm32();
            let align = self.size_align.align(inner).align_wasm32();

            uwrite!(
                &mut definition,
                "
  @override
  int get elementSize => {size};
  @override
  int allocateBuffer(int size) {{
    return {rt_import}.mallocAligned(const {wasm_import}.WasmI32({align}), (size * {size}).toWasmI32()).toIntUnsigned();
  }}
  @override
  void freeBuffer(int address, int totalSize, int start, int amount) {{
    {rt_import}.dartFree(address.toWasmI32(), (totalSize * {size}).toWasmI32(), const {wasm_import}.WasmI32({align}));
  }}
  @override
  void writeToBuffer(int address, "
            );
            definition.write_stream_element_type(&mut self.main, resolve, Some(inner));
            uwriteln!(
                &mut definition,
                " elements) {{
    for (final (i, element) in elements.indexed) {{
      final wasmAddress = {wasm_import}.WasmI32.fromInt(address + i);
"
            );
            let mut generator = DartFunctionGenerator::new(
                &self.size_align,
                &mut self.main,
                FunctionMode::Standalone,
            );
            lower_to_memory(
                resolve,
                &mut generator,
                Rc::new("wasmAddress".to_string()),
                Rc::new("element".to_string()),
                inner,
            );
            uwriteln!(
                &mut definition,
                "{}    }}\n  }}",
                generator.definition.take_code()
            );

            uwriteln!(&mut definition, "@override\n");
            definition.write_stream_element_type(&mut self.main, resolve, Some(inner));
            uwriteln!(
                &mut definition,
                " readFromBuffer(int address, int count) {{"
            );
            let (lifted, code) = {
                let mut generator = DartFunctionGenerator::new(
                    &self.size_align,
                    &mut self.main,
                    FunctionMode::Standalone,
                );
                let lifted =
                    lift_from_memory(resolve, &mut generator, Rc::new("ptr".to_string()), inner);
                (lifted, generator.definition.take_code())
            };

            if let Some(typed_list) = self.main.stream_element_type_typed_list(inner) {
                uwriteln!(
                    &mut definition,
                    "
final typedList = {typed_list}(count);
for (var i = 0; i < count; i++) {{
  final ptr = {wasm_import}.WasmI32(address + i * {size});
  {code}
  typedList[i] = {lifted};
}}
return typedList;"
                );
            } else {
                uwriteln!(
                    &mut definition,
                    "return List.generate(count, (i) {{
  final ptr = {wasm_import}.WasmI32(address + i * {size});
  {code}
  return {lifted};
}});"
                );
            }

            uwriteln!(&mut definition, "}}")
        } else {
            // Stream<void>. This means that elementSize is zero, and that allocateBuffer is a noop.
            uwriteln!(
                &mut definition,
                "
  @override
  int get elementSize => 0;
  @override
  int allocateBuffer(int size) => 0;
  @override
  void freeBuffer(int address, int totalSize, int start, int amount) {{}}
  @override
  List<void> readFromBuffer(int address, int count) {{
    return List.filled(count, null);
  }}
  @override
  void writeToBuffer(int address, List<Object?> elements) {{}}
"
            );
        }

        uwriteln!(
            &mut definition,
            "
  @override
  int newStream() => _streamNew{id_str}().toInt();
  @override
  void dropReadable(int stream) {{
    _streamDropReadable{id_str}({wasm_import}.WasmI32.fromInt(stream));
  }}
  @override
  void dropWritable(int stream) {{
    _streamDropWritable{id_str}({wasm_import}.WasmI32.fromInt(stream));
  }}
  @override
  int read(int stream, int ptr, int n) {{
    return _streamRead{id_str}(
      {wasm_import}.WasmI32.fromInt(stream),
      {wasm_import}.WasmI32.fromInt(ptr),
      {wasm_import}.WasmI32.fromInt(n)
    ).toIntUnsigned();
  }}
  @override
  int write(int stream, int ptr, int n) {{
    return _streamWrite{id_str}(
      {wasm_import}.WasmI32.fromInt(stream),
      {wasm_import}.WasmI32.fromInt(ptr),
      {wasm_import}.WasmI32.fromInt(n)
    ).toIntUnsigned();
  }}
"
        );

        uwriteln!(&mut definition, "}}");

        self.main.consume_definition(definition);
        self.main.stream_future_vtables.insert(id, vtable_name);
    }

    fn define_future_vtable(&mut self, resolve: &Resolve, id: TypeId, inner_type: Option<Type>) {
        let rt_import = self.main.import(KnownDartUri::PkgWasmComponents);

        let Some(inner_type) = inner_type else {
            self.main
                .stream_future_vtables
                .insert(id, Rc::new(format!("{rt_import}.FutureVtable.voidVtable")));
            return;
        };

        let id_str = format!("{}", id.index());
        let vtable_name = Rc::new(format!("_Vtable{}", id_str));
        let mut definition = DartDefinition::default();
        let wasm_import = self.main.import(KnownDartUri::DartWasm);

        uwrite!(
            &mut definition,
            "
@pragma('wasm:import', 'component.future{id_str}.new')
external {wasm_import}.WasmI64 _futureNew{id_str}();
@pragma('wasm:import', 'component.future{id_str}.write')
external {wasm_import}.WasmI32 _futureWrite{id_str}({wasm_import}.WasmI32 future, {wasm_import}.WasmI32 ptr);
@pragma('wasm:import', 'component.future{id_str}.read')
external {wasm_import}.WasmI32 _futureRead{id_str}({wasm_import}.WasmI32 future, {wasm_import}.WasmI32 ptr);
@pragma('wasm:import', 'component.future{id_str}.drop-readable')
external {wasm_import}.WasmVoid _futureDropReadable{id_str}({wasm_import}.WasmI32 future);
@pragma('wasm:import', 'component.future{id_str}.drop-writable')
external {wasm_import}.WasmVoid _futureDropWritable{id_str}({wasm_import}.WasmI32 future);

final class {vtable_name} implements {rt_import}.FutureVtable<"
        );
        self.io.imports.push(ImportedFunction {
            import_name: format!("future{id_str}.new"),
            definition: ImportedFunctionDefinition::FutureNew {
                future_type: id.index(),
            },
            lower_options: Default::default(),
        });
        let mut read_write_options = CanonicalOptions::default();
        read_write_options.is_async = true;
        read_write_options.uses_memory = true;

        self.io.imports.push(ImportedFunction {
            import_name: format!("future{id_str}.write"),
            definition: ImportedFunctionDefinition::FutureWrite {
                future_type: id.index(),
            },
            lower_options: read_write_options.clone(),
        });
        self.io.imports.push(ImportedFunction {
            import_name: format!("future{id_str}.read"),
            definition: ImportedFunctionDefinition::FutureRead {
                future_type: id.index(),
            },
            lower_options: read_write_options.clone(),
        });
        self.io.imports.push(ImportedFunction {
            import_name: format!("future{id_str}.drop-readable"),
            definition: ImportedFunctionDefinition::FutureDropReadable {
                future_type: id.index(),
            },
            lower_options: Default::default(),
        });
        self.io.imports.push(ImportedFunction {
            import_name: format!("future{id_str}.drop-writable"),
            definition: ImportedFunctionDefinition::FutureDropWritable {
                future_type: id.index(),
            },
            lower_options: Default::default(),
        });

        definition.write_dart_type(&mut self.main, resolve, &inner_type);

        let size = self.size_align.size(&inner_type).size_wasm32();
        let align = self.size_align.align(&inner_type).align_wasm32();

        uwrite!(
                &mut definition,
                "> {{
  const {vtable_name}();

  @override
  int newFuture() => _futureNew{id_str}().toInt();

  @override
  int read(int future, int buffer) {{
    return _futureRead{id_str}({wasm_import}.WasmI32.fromInt(future), {wasm_import}.WasmI32.fromInt(buffer)).toIntUnsigned();
  }}

  @override
  int write(int future, int buffer) {{
    return _futureWrite{id_str}({wasm_import}.WasmI32.fromInt(future), {wasm_import}.WasmI32.fromInt(buffer)).toIntUnsigned();
  }}

  @override
  void dropRead(int future) {{
    _futureDropReadable{id_str}({wasm_import}.WasmI32.fromInt(future));
  }}

  @override
  void dropWrite(int future) {{
    _futureDropWritable{id_str}({wasm_import}.WasmI32.fromInt(future));
  }}

  @override
  int allocateBuffer() {{
    return {rt_import}.mallocAligned(const {wasm_import}.WasmI32({align}), const {wasm_import}.WasmI32({size})).toIntUnsigned();
  }}

  @override
  void freeBuffer(int address, {{required bool containsValue}}) {{
    {rt_import}.dartFree(address.toWasmI32(), const {wasm_import}.WasmI32({size}), const {wasm_import}.WasmI32({align}));
  }}

  @override
  void store(int address, "
            );
        definition.write_dart_type(&mut self.main, resolve, &inner_type);
        uwriteln!(
            &mut definition,
            " value) {{
    final wasmAddress = {wasm_import}.WasmI32.fromInt(address);
"
        );
        let mut generator =
            DartFunctionGenerator::new(&self.size_align, &mut self.main, FunctionMode::Standalone);
        lower_to_memory(
            resolve,
            &mut generator,
            Rc::new("wasmAddress".to_string()),
            Rc::new("value".to_string()),
            &inner_type,
        );
        uwriteln!(
            &mut definition,
            "{}
  }}

  @override
  ",
            generator.definition.take_code()
        );
        definition.write_dart_type(&mut self.main, resolve, &inner_type);
        uwriteln!(
            &mut definition,
            "load(int address) {{
    final wasmAddress = {wasm_import}.WasmI32.fromInt(address);
"
        );
        let mut generator =
            DartFunctionGenerator::new(&self.size_align, &mut self.main, FunctionMode::Standalone);

        let lifted = lift_from_memory(
            resolve,
            &mut generator,
            Rc::new("wasmAddress".to_string()),
            &inner_type,
        );
        uwriteln!(
            &mut definition,
            "{}\n    return {lifted};\n  }}\n}}",
            generator.definition.take_code()
        );

        self.main.consume_definition(definition);
        self.main.stream_future_vtables.insert(id, vtable_name);
    }

    fn generate_stream_or_future_vtables(&mut self, resolve: &Resolve, iface: InterfaceId) {
        let interface = &resolve.interfaces[iface];

        for function in interface.functions.values() {
            for stream_or_future in function.find_futures_and_streams(resolve) {
                if !self
                    .main
                    .stream_future_vtables
                    .contains_key(&stream_or_future)
                {
                    let resolved_type = &resolve.types[stream_or_future];
                    match resolved_type.kind {
                        TypeDefKind::Stream(inner) => {
                            self.define_stream_vtable(resolve, stream_or_future, inner)
                        }
                        TypeDefKind::Future(inner) => {
                            self.define_future_vtable(resolve, stream_or_future, inner)
                        }
                        _ => panic!("Neither a stream nor future"),
                    }
                }
            }
        }
    }
}

impl<'a> WorldGenerator for DartWorldGenerator<'a> {
    fn preprocess(
        &mut self,
        resolve: &Resolve,
        _world: wit_bindgen_core::wit_parser::WorldId,
    ) -> Result<()> {
        self.size_align.fill(resolve);
        Ok(())
    }

    fn import_interface(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        name: &wit_bindgen_core::wit_parser::WorldKey,
        iface: wit_bindgen_core::wit_parser::InterfaceId,
        _files: &mut wit_bindgen_core::Files,
    ) -> Result<()> {
        self.generate_stream_or_future_vtables(resolve, iface);
        let interface = &resolve.interfaces[iface];
        let class_name = self.main.define_interface(&resolve, iface);
        let mut def = DartDefinition::default();
        let impl_name = format!("_Imported${}", iface.index());

        {
            let def = &mut def;
            let _ = writeln!(
                def,
                "final class {impl_name} implements {class_name} {{\n  const {impl_name}();",
            );

            for (name, function) in &interface.functions {
                let variant = if function.kind.is_async() {
                    AbiVariant::GuestImportAsync
                } else {
                    AbiVariant::GuestImport
                };
                let core_name = Rc::new(format!("_import{}", self.io.imports.len()));

                uwriteln!(def, "@override");
                def.write_function_signature(&mut self.main, resolve, name, function);
                if function.kind.is_async() {
                    uwrite!(def, "async");
                }

                let _ = writeln!(def, "{{");
                let mut generator = DartFunctionGenerator::new(
                    &self.size_align,
                    &mut self.main,
                    FunctionMode::Imported(ImportedFunctionMode {
                        core_name: &core_name,
                        function,
                    }),
                );

                if function.kind.is_async() {
                    call_async_import(resolve, variant, &core_name, function, &mut generator);
                } else {
                    call(
                        resolve,
                        variant,
                        LiftLower::LowerArgsLiftResults,
                        function,
                        &mut generator,
                        false,
                    );
                }

                generator.write_cleanup();
                let _ = writeln!(def, "{}\n}}", generator.definition.take_code());
                self.io.imports.extend(generator.additional_imports);

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

                    self.io.imports.push(ImportedFunction {
                        import_name: (*core_name).clone(),
                        definition: ImportedFunctionDefinition::Instance(ImportedFromInstance {
                            interface: iface,
                            function_name: name.to_string(),
                        }),
                        lower_options: options,
                    });
                }
            }

            let _ = writeln!(def, "}}");

            let import_name: Cow<str> = match name {
                WorldKey::Name(name) => name.into(),
                WorldKey::Interface(id) => format!("importedInstance{}", id.index()).into(),
            };
            let _ = writeln!(def, "const {class_name} {import_name} = {impl_name}();",);
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
        self.generate_stream_or_future_vtables(resolve, iface);
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

        self.local_exports.push(ExportedInstance {
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
        if self.local_exports.is_empty() {
            return Ok(());
        }

        // Generate defineInstanceExport to set instance fields, users are supposed to call it in
        // their main() function.
        let mut def = DartDefinition::default();
        {
            let def = &mut def;
            let _ = write!(def, "void defineInstanceExport({{");
            for export in &self.local_exports {
                let _ = write!(
                    def,
                    "required {} {},",
                    export.class_name,
                    export.public_field_name()
                );
            }
            let _ = writeln!(def, "}}) {{");
            for export in &self.local_exports {
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
        for mut export in &mut self.local_exports {
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
                let is_async = function.kind.is_async();
                let async_return_name = format!("_component_{}taskReturn", { this_export_id });
                let mut async_return_params = None;
                let mut allocated_return_value = None;

                let mut generator = DartFunctionGenerator::new(
                    &self.size_align,
                    &mut self.main,
                    FunctionMode::Exported(ExportedFunctionMode {
                        instance: &mut export,
                        result_type: &function.result,
                        async_return_name: &async_return_name,
                        async_return_params: &mut async_return_params,
                        allocated_return_value: &mut allocated_return_value,
                    }),
                );
                call(
                    resolve,
                    abi_variant,
                    LiftLower::LiftArgsLowerResults,
                    function,
                    &mut generator,
                    is_async,
                );
                let body = generator.definition.take_code();
                self.io.imports.extend(generator.additional_imports);

                if is_async {
                    let components = generator.dart.import(KnownDartUri::PkgWasmComponents);

                    uwriteln!(
                        def,
                        "{{
final asyncExitCode = {components}.spawnTask(
  run: () async {{
    {body}
  }},
  debugName: '{name}',
);
return asyncExitCode.toWasmI32();
}}"
                    );
                } else {
                    uwriteln!(def, "{{\n{body}\n}}");
                }

                let mut options = generator.options;

                if let Some(params) = async_return_params {
                    uwrite!(
                        def,
                        "@pragma('wasm:import', 'component.{}')\nexternal ",
                        async_return_name
                    );
                    def.write_core_signature(
                        &mut self.main,
                        &async_return_name,
                        &WasmSignature {
                            params,
                            results: vec![],
                            indirect_params: false,
                            retptr: false,
                        },
                    );
                    uwrite!(def, ";")
                }

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

                    if let Some((size, align)) = allocated_return_value {
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

                options.is_async = is_async;
                options.uses_callback = is_async;
                export.functions.push(ExportedCoreFunction {
                    function_name: name.clone(),
                    lifted: LiftedFunction {
                        exported_name: format!("component_{}", this_export_id),
                        options,
                        parameters: function.params.clone(),
                        result: function.result.clone(),
                    },
                });
            }
        }

        self.main.consume_definition(def);

        self.io.exports.extend(mem::take(&mut self.local_exports));
        Ok(())
    }
}

impl ImportsAndExports {
    pub fn serialize_abi(&self, resolve: &Resolve) -> anyhow::Result<String> {
        let exports: Vec<crate::abi::ExportedInstance> =
            self.exports.iter().map(|e| e.to_abi_export()).collect();

        Ok(serde_json::to_string(&PackageAbiWithWorld {
            imports: &self.imports,
            exports: &exports,
            world: resolve,
        })?)
    }
}
