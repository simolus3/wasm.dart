use std::fmt::{Display, Write};
use std::{
    collections::{HashMap, hash_map::Entry},
    rc::Rc,
};

use heck::{AsLowerCamelCase, AsUpperCamelCase, ToLowerCamelCase, ToUpperCamelCase};
use wit_bindgen_core::abi::{WasmSignature, WasmType};
use wit_bindgen_core::wit_parser::{
    Docs, Enum, Flags, Function, Handle, InterfaceId, PackageId, Resolve, Type, TypeDefKind,
    TypeId, TypeOwner, Variant,
};
use wit_bindgen_core::{uwrite, uwriteln};

pub struct DartSource<'a> {
    pub header: String,
    pub import_map: &'a ImportMap,
    definitions: String,
    import_aliases: HashMap<KnownDartUri, Rc<String>>,
    interface_names: HashMap<InterfaceId, Rc<String>>,
    type_definitions: HashMap<TypeId, Rc<String>>,
    pub stream_future_vtables: HashMap<TypeId, Rc<String>>,
}

impl<'a> DartSource<'a> {
    pub fn new(map: &'a ImportMap) -> Self {
        Self {
            header: Default::default(),
            import_map: map,
            definitions: Default::default(),
            import_aliases: Default::default(),
            interface_names: Default::default(),
            type_definitions: Default::default(),
            stream_future_vtables: Default::default(),
        }
    }

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

    /// Generates a type name for an interface, variant, flag, resource or other definition.
    ///
    /// If the element is from an imported package, generates a package import instead.
    ///
    /// Returns whether a package import was crated and the generated name,
    fn type_name(
        &mut self,
        package: Option<&PackageId>,
        name: Option<&str>,
        fallback_prefix: &str,
        idx: usize,
    ) -> (bool, Rc<String>) {
        let import_alias = package
            .and_then(|pkg| self.import_map.map.get(pkg).cloned())
            .map(|uri| self.import(KnownDartUri::Custom(uri)));
        let mut name = match name {
            Some(name) => name.to_upper_camel_case(),
            None => format!("{fallback_prefix}{idx}"),
        };

        if let Some(ref import) = import_alias {
            name.insert_str(0, &import);
            name.insert_str(import.len(), ".");
        }

        (import_alias.is_some(), Rc::new(name))
    }

    fn interface_type_name(
        &mut self,
        owner: &TypeOwner,
        resolve: &Resolve,
        name: Option<&str>,
        fallback_prefix: &str,
        idx: usize,
    ) -> (bool, Rc<String>) {
        match owner {
            TypeOwner::Interface(id) => {
                let interface = &resolve.interfaces[*id];

                let name = name.and_then(|e| {
                    interface
                        .name
                        .as_ref()
                        .map(|iname| format!("{}-{e}", &iname))
                });

                self.type_name(
                    interface.package.as_ref(),
                    name.as_deref(),
                    fallback_prefix,
                    idx,
                )
            }
            _ => self.type_name(None, name, fallback_prefix, idx),
        }
    }

    pub fn define_interface(&mut self, resolve: &Resolve, iface: InterfaceId) -> Rc<String> {
        if let Some(name) = self.interface_names.get(&iface) {
            return name.clone();
        }

        let interface = &resolve.interfaces[iface];
        let (imported, class_name) = self.type_name(
            interface.package.as_ref(),
            interface.name.as_deref(),
            "UnnamedInterface",
            iface.index(),
        );
        self.interface_names.insert(iface, class_name.clone());
        if imported {
            return class_name;
        }

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

    pub fn consume_definition(&mut self, definition: DartDefinition) {
        self.definitions.push_str(&definition.0);
    }

    pub fn define_enum(&mut self, id: TypeId, resolve: &Resolve, def: &Enum) -> Rc<String> {
        if let Some(name) = self.type_definitions.get(&id) {
            return name.clone();
        }

        let resolved = &resolve.types[id];
        let (imported, name) = self.interface_type_name(
            &resolved.owner,
            resolve,
            resolved.name.as_deref(),
            "UnnamedEnum",
            id.index(),
        );
        self.type_definitions.insert(id, name.clone());
        if imported {
            return name;
        }

        let mut definition = DartDefinition::default();
        definition.write_docs(&resolved.docs);
        uwriteln!(&mut definition, "enum {name} {{");
        for case in &def.cases {
            definition.write_docs(&case.docs);
            uwriteln!(&mut definition, "{},", case.name.to_lower_camel_case())
        }
        uwriteln!(&mut definition, "}}");

        self.consume_definition(definition);
        name
    }

    pub fn define_resource(&mut self, id: TypeId, resolve: &Resolve) -> Rc<String> {
        if let Some(name) = self.type_definitions.get(&id) {
            return name.clone();
        }

        let resolved = &resolve.types[id];
        let (imported, name) = self.interface_type_name(
            &resolved.owner,
            &resolve,
            resolved.name.as_deref(),
            "Resource",
            id.index(),
        );
        self.type_definitions.insert(id, name.clone());
        if imported {
            return name;
        }

        let mut definition = DartDefinition::default();
        definition.write_docs(&resolved.docs);
        uwriteln!(&mut definition, "final class {name} {{}}");
        self.consume_definition(definition);
        name
    }

    pub fn define_variant(
        &mut self,
        id: TypeId,
        resolve: &Resolve,
        variant: &Variant,
    ) -> Rc<String> {
        if let Some(name) = self.type_definitions.get(&id) {
            return name.clone();
        }

        let resolved = &resolve.types[id];
        let (imported, name) = self.interface_type_name(
            &resolved.owner,
            resolve,
            resolved.name.as_deref(),
            "Variant",
            id.index(),
        );
        self.type_definitions.insert(id, name.clone());
        if imported {
            return name;
        }

        let mut definition = DartDefinition::default();
        definition.write_docs(&resolved.docs);
        uwriteln!(&mut definition, "sealed class {name} {{");
        uwriteln!(&mut definition, "  const {name}._();");

        // Create generative factories for subtypes
        for case in &variant.cases {
            uwrite!(
                &mut definition,
                "  const factory {name}.{}(",
                AsLowerCamelCase(&case.name)
            );
            if let Some(ty) = &case.ty {
                definition.write_dart_type(self, resolve, ty);
                uwrite!(&mut definition, " payload");
            }
            uwriteln!(
                &mut definition,
                ") = {name}{};",
                AsUpperCamelCase(&case.name)
            );
        }

        uwriteln!(&mut definition, "}}");

        for case in &variant.cases {
            let case_name = case.name.to_upper_camel_case();

            uwriteln!(
                &mut definition,
                "final class {name}{case_name} extends {name} {{"
            );
            if let Some(ty) = &case.ty {
                uwrite!(&mut definition, "final ");
                definition.write_dart_type(self, resolve, ty);
                uwriteln!(
                    &mut definition,
                    " payload;\n  const {name}{case_name}(this.payload): super._();"
                );
            } else {
                uwriteln!(&mut definition, "  const {name}{case_name}(): super._();");
            }
            uwriteln!(&mut definition, "}}");
        }

        self.consume_definition(definition);
        name
    }

    pub fn define_flags(&mut self, id: TypeId, resolve: &Resolve, flags: &Flags) -> Rc<String> {
        if let Some(name) = self.type_definitions.get(&id) {
            return name.clone();
        }

        let resolved = &resolve.types[id];
        let (imported, name) = self.interface_type_name(
            &resolved.owner,
            resolve,
            resolved.name.as_deref(),
            "Variant",
            id.index(),
        );
        self.type_definitions.insert(id, name.clone());
        if imported {
            return name;
        }

        let mut definition = DartDefinition::default();
        definition.write_docs(&resolved.docs);
        uwriteln!(
            &mut definition,
            "extension type {name}(int representation) implements int {{"
        );

        for (i, flag) in flags.flags.iter().enumerate() {
            let mask = 1usize << i;

            definition.write_docs(&flag.docs);
            uwriteln!(
                &mut definition,
                "  bool get {} => representation & {mask:#x} == {mask:#x};",
                AsLowerCamelCase(&flag.name)
            );
            uwriteln!(
                &mut definition,
                "  {name} with{}(bool value) {{",
                AsUpperCamelCase(&flag.name)
            );
            uwriteln!(
                &mut definition,
                "  return {name}(value ? representation | {mask:#x} : representation & ~{mask:#x});\n}}",
            );
        }

        uwriteln!(&mut definition, "}}");
        self.consume_definition(definition);
        name
    }

    /// If the given type has a specialized list implementation for stream, returns the associated
    /// type.
    pub fn stream_element_type_typed_list(&mut self, wit_type: &Type) -> Option<String> {
        let typed_list = match wit_type {
            Type::U8 => "Uint8List",
            Type::S8 => "Int8List",
            Type::U16 => "Uint16List",
            Type::S16 => "Int16List",
            Type::U32 => "Uint32List",
            Type::S32 => "Int32List",
            Type::U64 | Type::S64 => "Int64List",
            Type::F32 => "Float32List",
            Type::F64 => "Float64List",
            _ => return None,
        };

        let import = self.import(KnownDartUri::DartTypedData);
        return Some(format!("{import}.{typed_list}"));
    }
}

impl Display for DartSource<'_> {
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
        uwrite!(self, "{}.{}", name, id);
    }

    pub fn write_docs(&mut self, docs: &Docs) {
        let Some(content) = &docs.contents else {
            return;
        };
        for line in content.lines() {
            uwriteln!(self, "/// {}", line);
        }
    }

    pub fn write_function_signature(
        &mut self,
        dart: &mut DartSource,
        resolve: &Resolve,
        name: &str,
        function: &Function,
    ) {
        let is_async = function.kind.is_async();
        if is_async {
            uwrite!(self, "Future<");
        }

        self.write_optional_dart_type(dart, resolve, function.result.as_ref());
        if is_async {
            uwrite!(self, ">");
        }

        let _ = write!(self, " {}(", AsLowerCamelCase(name));
        if !function.params.is_empty() {
            let _ = write!(self, "{{");
            for param in &function.params {
                let _ = write!(self, "required ");
                self.write_dart_type(dart, resolve, &param.ty);
                let _ = write!(self, " {}, ", parameter_name(&param.name));
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
                self.write_def_type(dart, resolve, id);
                return;
            }
        };

        self.0.push_str(simple_name);
    }

    pub fn write_stream_element_type(
        &mut self,
        dart: &mut DartSource,
        resolve: &Resolve,
        wit_type: Option<&Type>,
    ) {
        let Some(wit_type) = wit_type else {
            self.0.push_str("List<Object?>");
            return;
        };

        if let Some(optimized) = dart.stream_element_type_typed_list(wit_type) {
            self.0.push_str(&optimized);
            return;
        }

        self.0.push_str("List<");
        self.write_dart_type(dart, resolve, wit_type);
        self.0.push_str(">");
    }

    pub fn write_def_type(&mut self, dart: &mut DartSource, resolve: &Resolve, def_type: &TypeId) {
        let resolved_type = &resolve.types[*def_type];

        match &resolved_type.kind {
            TypeDefKind::Record(record) => {
                uwrite!(self, "({{");
                for element in &record.fields {
                    self.write_dart_type(dart, resolve, &element.ty);
                    let _ = write!(self, " {},", AsLowerCamelCase(&element.name));
                }
                uwrite!(self, "}})");
            }
            TypeDefKind::Resource => {
                let name = dart.define_resource(*def_type, resolve);
                self.0.push_str(&name);
            }
            TypeDefKind::Handle(handle) => {
                let (class, id) = match handle {
                    Handle::Own(id) => ("Owned", id),
                    Handle::Borrow(id) => ("Borrowed", id),
                };

                self.imported_identifier(dart, KnownDartUri::PkgWasmComponents, class);
                uwrite!(self, "<");
                self.write_def_type(dart, resolve, id);
                uwrite!(self, ">");
            }
            TypeDefKind::Flags(flags) => {
                let name = dart.define_flags(*def_type, resolve, flags);
                self.0.push_str(&name);
            }
            TypeDefKind::Tuple(tuple) => {
                uwrite!(self, "(");
                for element_type in &tuple.types {
                    self.write_dart_type(dart, resolve, element_type);
                    self.0.push_str(", ");
                }
                uwrite!(self, ")");
            }
            TypeDefKind::Variant(variant) => {
                let name = dart.define_variant(*def_type, resolve, variant);
                uwrite!(self, "{name}")
            }
            TypeDefKind::Enum(enum_def) => {
                let name = dart.define_enum(*def_type, resolve, enum_def);
                self.0.push_str(&name);
            }
            TypeDefKind::Option(inner) => {
                self.imported_identifier(dart, KnownDartUri::PkgWasmComponents, "Option");
                self.0.push_str("<");
                self.write_dart_type(dart, resolve, inner);
                self.0.push_str(">");
            }
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
                self.write_stream_element_type(dart, resolve, element_type.as_ref());
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
            WasmType::I32 | WasmType::Pointer | WasmType::Length => "WasmI32",
            WasmType::I64 | WasmType::PointerOrI64 => "WasmI64",
            WasmType::F32 => "WasmF32",
            WasmType::F64 => "WasmF64",
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
    /// `dart:typed_data`
    DartTypedData,
    /// `package:wasm_components/component.dart`
    PkgWasmComponents,
    Custom(Rc<String>),
}

impl KnownDartUri {
    fn uri_str(&self) -> &str {
        match self {
            KnownDartUri::DartWasm => "dart:_wasm",
            KnownDartUri::DartTypedData => "dart:typed_data",
            KnownDartUri::PkgWasmComponents => "package:wasm_components/wasm_components.dart",
            KnownDartUri::Custom(uri) => uri,
        }
    }
}

pub fn push_dart_string_literal(target: &mut String, contents: &str) {
    // TODO: Escape
    target.push_str("r'");
    target.push_str(contents);
    target.push('\'');
}

#[derive(Default)]
pub struct ImportMap {
    map: HashMap<PackageId, Rc<String>>,
}

impl ImportMap {
    pub fn define_package_import(&mut self, package: PackageId, import: Rc<String>) {
        self.map.insert(package, import);
    }
}

pub fn parameter_name(name: &str) -> String {
    if name == "this" {
        "$this".to_string()
    } else {
        name.to_lower_camel_case()
    }
}
