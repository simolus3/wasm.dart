use std::fmt::{Display, Write};
use std::{
    collections::{HashMap, hash_map::Entry},
    rc::Rc,
};

use heck::{AsLowerCamelCase, ToUpperCamelCase};
use wit_bindgen_core::abi::{WasmSignature, WasmType};
use wit_bindgen_core::wit_parser::{
    Docs, Function, InterfaceId, Resolve, Type, TypeDef, TypeDefKind,
};
use wit_bindgen_core::{uwrite, uwriteln};

#[derive(Default)]
pub struct DartSource {
    pub header: String,
    definitions: String,
    import_aliases: HashMap<KnownDartUri, Rc<String>>,
    interface_names: HashMap<InterfaceId, Rc<String>>,
}

impl DartSource {
    pub fn import(&mut self, uri: KnownDartUri) -> Rc<String> {
        let length = self.import_aliases.len();

        match self.import_aliases.entry(uri.clone()) {
            Entry::Occupied(e) => e.get().clone(),
            Entry::Vacant(vacant) => {
                let name = Rc::new(format!("i{}", length));

                if let KnownDartUri::DartWasm = uri {
                    uwriteln!(&mut self.header, "// ignore: import_internal_library");
                }

                self.header.push_str("import ");
                push_dart_string_literal(&mut self.header, uri.uri_str());
                let _ = write!(&mut self.header, " as {};\n", name);

                vacant.insert(name.clone());
                name
            }
        }
    }

    pub fn define_interface(&mut self, resolve: &Resolve, iface: InterfaceId) -> Rc<String> {
        match self.interface_names.entry(iface) {
            Entry::Occupied(e) => e.get().clone(),
            Entry::Vacant(vacant) => {
                let interface = &resolve.interfaces[iface];
                let class_name = Rc::new(match &interface.name {
                    Some(name) => name.to_upper_camel_case(),
                    None => format!("UnnamedInterface{}", iface.index()),
                });
                vacant.insert(class_name.clone());

                let mut definition = DartDefinition::default();

                definition.write_docs(&interface.docs);
                let _ = writeln!(
                    &mut definition,
                    "abstract interface class {} {{",
                    class_name
                );
                for (name, function) in &interface.functions {
                    definition.write_docs(&function.docs);
                    definition.write_function_signature(self, resolve, name, function);
                    let _ = writeln!(&mut definition, ";");
                }
                let _ = writeln!(&mut definition, "}}");
                self.consume_definition(definition);

                class_name
            }
        }
    }

    pub fn consume_definition(&mut self, definition: DartDefinition) {
        self.definitions.push_str(&definition.0);
    }
}

impl Display for DartSource {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("// ignore_for_file: type=warning\n")?;
        f.write_str(&self.header)?;
        f.write_str("\n")?;
        f.write_str(&self.definitions)
    }
}

#[derive(Default, Debug)]
pub struct DartDefinition(String);

impl DartDefinition {
    pub fn imported_identifier<I: Display>(
        &mut self,
        dart: &mut DartSource,
        import: KnownDartUri,
        id: I,
    ) {
        let name = dart.import(import);
        let _ = write!(self, "{}.{}", name, id);
    }

    pub fn write_docs(&mut self, docs: &Docs) {
        let Some(content) = &docs.contents else {
            return;
        };
        for line in content.lines() {
            let _ = writeln!(self, "/// {}", line);
        }
    }

    pub fn write_function_signature(
        &mut self,
        dart: &mut DartSource,
        resolve: &Resolve,
        name: &str,
        function: &Function,
    ) {
        self.write_optional_dart_type(dart, resolve, function.result.as_ref());

        let _ = write!(self, " {}(", AsLowerCamelCase(name));
        if !function.params.is_empty() {
            let _ = write!(self, "{{");
            for param in &function.params {
                let _ = write!(self, "required ");
                self.write_dart_type(dart, resolve, &param.ty);
                let _ = write!(self, " {}, ", AsLowerCamelCase(&param.name));
            }
            let _ = write!(self, "}}");
        }
        let _ = write!(self, ")");
    }

    pub fn write_optional_dart_type(
        &mut self,
        dart: &mut DartSource,
        resolve: &Resolve,
        wit_type: Option<&Type>,
    ) {
        if let Some(wit_type) = wit_type {
            self.write_dart_type(dart, resolve, wit_type);
        } else {
            self.0.push_str("void");
        }
    }

    pub fn write_dart_type(&mut self, dart: &mut DartSource, resolve: &Resolve, wit_type: &Type) {
        let simple_name = match wit_type {
            Type::Bool => "bool",
            Type::U8
            | Type::U16
            | Type::U32
            | Type::U64
            | Type::S8
            | Type::S16
            | Type::S32
            | Type::S64
            | Type::Char => "int",
            Type::F32 | Type::F64 => "double",
            Type::String => "String",
            Type::ErrorContext => {
                self.imported_identifier(dart, KnownDartUri::PkgWasmComponents, "ErrorContext");
                return;
            }
            Type::Id(id) => {
                let def = &resolve.types[*id];
                self.write_def_type(dart, resolve, def);
                return;
            }
        };

        self.0.push_str(simple_name);
    }

    pub fn write_def_type(&mut self, dart: &mut DartSource, resolve: &Resolve, def_type: &TypeDef) {
        // TODO: Some of these will need classes (e.g. enums, also we should use sealed classes for
        // variants). Finally, we should introduce typedefs if the TypeDefs has a name.

        match &def_type.kind {
            TypeDefKind::Record(record) => {
                let _ = write!(self, "({{");
                for element in &record.fields {
                    self.write_dart_type(dart, resolve, &element.ty);
                    let _ = write!(self, " {},", element.name);
                }
                let _ = write!(self, "}})");
                return;
            }
            TypeDefKind::Resource => todo!(),
            TypeDefKind::Handle(_handle) => todo!(),
            TypeDefKind::Flags(_flags) => todo!(),
            TypeDefKind::Tuple(_tuple) => todo!(),
            TypeDefKind::Variant(_variant) => todo!(),
            TypeDefKind::Enum(_) => todo!(),
            TypeDefKind::Option(_) => todo!(),
            TypeDefKind::Result(result) => {
                self.imported_identifier(dart, KnownDartUri::PkgWasmComponents, "Result");
                self.0.push_str("<");
                self.write_optional_dart_type(dart, resolve, result.ok.as_ref());
                self.0.push_str(", ");
                self.write_optional_dart_type(dart, resolve, result.err.as_ref());
                self.0.push_str(">");
            }
            TypeDefKind::List(element_type) | TypeDefKind::FixedLengthList(element_type, _) => {
                self.0.push_str("List<");
                self.write_dart_type(dart, resolve, element_type);
                self.0.push_str(">");
            }
            TypeDefKind::Map(k, v) => {
                self.0.push_str("Map<");
                self.write_dart_type(dart, resolve, k);
                self.0.push_str(", ");
                self.write_dart_type(dart, resolve, v);
                self.0.push_str(">");
            }
            TypeDefKind::Future(element_type) => {
                self.0.push_str("Future<");
                self.write_optional_dart_type(dart, resolve, element_type.as_ref());
                self.0.push_str(">");
            }
            TypeDefKind::Stream(element_type) => {
                self.0.push_str("Stream<");
                self.write_optional_dart_type(dart, resolve, element_type.as_ref());
                self.0.push_str(">");
            }
            TypeDefKind::Type(wit_type) => self.write_dart_type(dart, resolve, wit_type),
            TypeDefKind::Unknown => self.0.push_str("Never /* unknown wit type */"),
        }
    }

    pub fn write_core_signature(
        &mut self,
        dart: &mut DartSource,
        name: &str,
        signature: &WasmSignature,
    ) {
        if signature.results.is_empty() {
            self.imported_identifier(dart, KnownDartUri::DartWasm, "WasmVoid");
        } else {
            assert!(signature.results.len() == 1);
            self.write_core_type(dart, &signature.results[0]);
        }

        let _ = write!(self, " {}(", name);
        for (i, param) in signature.params.iter().enumerate() {
            if i != 0 {
                let _ = write!(self, ", ");
            }
            self.write_core_type(dart, param);
            uwrite!(self, " p{i}");
        }
        let _ = write!(self, ")");
    }

    pub fn write_core_type(&mut self, dart: &mut DartSource, core_type: &WasmType) {
        let simple_name = match core_type {
            WasmType::I32 => "WasmI32",
            WasmType::I64 => "WasmI64",
            WasmType::F32 => "WasmF32",
            WasmType::F64 => "WasmF64",
            WasmType::Pointer => "WasmI32",
            WasmType::PointerOrI64 => "WasmI32",
            WasmType::Length => "WasmI32",
        };
        self.imported_identifier(dart, KnownDartUri::DartWasm, simple_name);
    }

    pub fn take_code(self) -> String {
        self.0
    }
}

impl Write for DartDefinition {
    fn write_str(&mut self, s: &str) -> std::fmt::Result {
        self.0.write_str(s)
    }
}

#[derive(PartialEq, Eq, Hash, Clone)]
pub enum KnownDartUri {
    /// `dart:_wasm`
    DartWasm,
    /// `package:wasm_components/component.dart`
    PkgWasmComponents,
}

impl KnownDartUri {
    fn uri_str(&self) -> &str {
        match self {
            KnownDartUri::DartWasm => "dart:_wasm",
            KnownDartUri::PkgWasmComponents => "package:wasm_components/wasm_components.dart",
        }
    }
}

pub fn push_dart_string_literal(target: &mut String, contents: &str) {
    // TODO: Escape
    target.push_str("r'");
    target.push_str(contents);
    target.push('\'');
}
