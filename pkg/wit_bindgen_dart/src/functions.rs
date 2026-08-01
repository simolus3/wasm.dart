use std::rc::Rc;
use std::{fmt::Write, mem};

use heck::{AsLowerCamelCase, ToLowerCamelCase};
use wit_bindgen_core::abi::WasmType;
use wit_bindgen_core::wit_parser::{Alignment, ArchitectureSize};
use wit_bindgen_core::{
    abi::{Bindgen, Instruction},
    wit_parser::{Function, Resolve, SizeAlign, Type},
};
use wit_bindgen_core::{uwrite, uwriteln};

use crate::abi::{CanonicalOptions, ImportedFunction, ImportedFunctionDefinition};
use crate::dart_source::DartSource;
use crate::{
    bindgen::ExportedInstance,
    dart_source::{DartDefinition, KnownDartUri},
};

pub struct DartFunctionGenerator<'a> {
    size_align: &'a SizeAlign,
    pub dart: &'a mut DartSource,
    pub definition: DartDefinition,
    block_storage: Vec<DartDefinition>,
    blocks: Vec<(String, Vec<Rc<String>>)>,
    mode: FunctionMode<'a>,
    cleanup: String,
    next_temporary: usize,
    pub options: CanonicalOptions,
    pub additional_imports: Vec<ImportedFunction>,
}

pub enum FunctionMode<'a> {
    Imported(ImportedFunctionMode<'a>),
    Exported(ExportedFunctionMode<'a>),
    PostReturn(PostReturn),
    Standalone,
}

pub struct ImportedFunctionMode<'a> {
    pub core_name: &'a str,
    pub function: &'a Function,
}

pub struct ExportedFunctionMode<'a> {
    pub instance: &'a mut ExportedInstance,
    pub result_type: &'a Option<Type>,
    pub async_return_name: &'a str,
    pub async_return_params: &'a mut Option<Vec<WasmType>>,
    pub allocated_return_value: &'a mut Option<(ArchitectureSize, Alignment)>,
}

pub struct PostReturn {}

impl<'a> DartFunctionGenerator<'a> {
    pub fn new(
        size_align: &'a SizeAlign,
        dart: &'a mut DartSource,
        mode: FunctionMode<'a>,
    ) -> Self {
        Self {
            size_align,
            dart,
            definition: DartDefinition::default(),
            mode,
            block_storage: Default::default(),
            blocks: Default::default(),
            cleanup: Default::default(),
            next_temporary: 0,
            options: Default::default(),
            additional_imports: Default::default(),
        }
    }

    fn temporary_variable(&mut self) -> Rc<String> {
        let rc = Rc::new(format!("tmp{}", self.next_temporary));
        self.next_temporary += 1;
        rc
    }

    fn mem_store(
        &mut self,
        operands: &mut Vec<Rc<String>>,
        method: &str,
        offset: &ArchitectureSize,
    ) {
        let ptr = operands.pop().unwrap();
        let value = operands.pop().unwrap();

        self.definition
            .imported_identifier(self.dart, KnownDartUri::PkgWasmComponents, "memory");
        uwriteln!(
            &mut self.definition,
            ".{method}({ptr}.toIntUnsigned(), {value}, offset: {});",
            offset.size_wasm32()
        );
    }

    fn mem_load(
        &mut self,
        operands: &mut Vec<Rc<String>>,
        results: &mut Vec<Rc<String>>,
        method: &str,
        offset: &ArchitectureSize,
    ) {
        let ptr = operands.pop().unwrap();
        let tmp = self.temporary_variable();

        uwrite!(&mut self.definition, "final {tmp} = ");
        self.definition
            .imported_identifier(self.dart, KnownDartUri::PkgWasmComponents, "memory");
        uwriteln!(
            &mut self.definition,
            ".{method}({ptr}.toIntUnsigned(), offset: {});",
            offset.size_wasm32()
        );
        results.push(tmp);
    }

    fn dart_wasm_import(&mut self) -> Rc<String> {
        self.dart.import(KnownDartUri::DartWasm)
    }

    pub fn write_cleanup(&mut self) {
        if !self.cleanup.is_empty() {
            let cleanup = std::mem::take(&mut self.cleanup);
            uwrite!(self.definition, "{}", cleanup);
        }
    }
}

impl<'a> Bindgen for DartFunctionGenerator<'a> {
    type Operand = Rc<String>;

    fn emit(
        &mut self,
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        inst: &wit_bindgen_core::abi::Instruction<'_>,
        operands: &mut Vec<Self::Operand>,
        results: &mut Vec<Self::Operand>,
    ) {
        match inst {
            Instruction::GetArg { nth } => {
                let function = match &self.mode {
                    FunctionMode::Imported(import) => import.function,
                    FunctionMode::Exported(_) | FunctionMode::PostReturn(_) => {
                        results.push(Rc::new(format!("p{nth}")));
                        return;
                    }
                    FunctionMode::Standalone => panic!("Standalone mode has no arguments"),
                };

                results.push(Rc::new(function.params[*nth].name.to_lower_camel_case()));
            }
            Instruction::CallWasm { name: _, sig } => {
                let has_results = !sig.results.is_empty();
                let (core_name, is_async) = match &self.mode {
                    FunctionMode::Imported(i) => (i.core_name, i.function.kind.is_async()),
                    _ => {
                        panic!("Can't generate call instruction in export mode")
                    }
                };

                if is_async {
                    let import = self.dart.import(KnownDartUri::PkgWasmComponents);
                    uwrite!(self.definition, "await {import}.createSubtask(")
                }

                if has_results {
                    let temp = self.temporary_variable();
                    uwrite!(self.definition, "final {} = ", temp);
                    results.push(temp.clone());
                }

                uwrite!(self.definition, "{}(", core_name);

                let operands = operands.split_off(operands.len() - sig.params.len());
                for (i, operand) in operands.iter().enumerate() {
                    if i != 0 {
                        uwrite!(self.definition, ", ");
                    }

                    uwrite!(self.definition, "{}", operand);
                }
                uwrite!(self.definition, ")");
                if is_async {
                    uwrite!(self.definition, ").completion")
                }

                uwriteln!(self.definition, ";");
            }
            Instruction::CallInterface { func, async_ } => {
                if func.result.is_some() {
                    let tmp = self.temporary_variable();
                    uwrite!(self.definition, "final {tmp} = ");
                    results.push(tmp);
                }
                let interface = match &mut self.mode {
                    FunctionMode::Exported(i) => i,
                    _ => panic!("Cannot use CallInterface in import mode"),
                };

                if *async_ {
                    uwrite!(self.definition, "await ");
                }

                uwrite!(
                    self.definition,
                    "{}.{}(",
                    interface.instance.field_name,
                    AsLowerCamelCase(&func.name)
                );

                let params = operands.split_off(operands.len() - func.params.len());
                for (value, param) in params.into_iter().zip(func.params.iter()) {
                    uwrite!(
                        self.definition,
                        "{}: {},",
                        AsLowerCamelCase(&param.name),
                        value
                    );
                }

                uwriteln!(self.definition, ");");
            }
            Instruction::Return { amt, func: _ } => {
                if let FunctionMode::Imported(_) = self.mode {
                    self.write_cleanup();
                }

                if *amt == 0 {
                    if let FunctionMode::Exported(_) = self.mode {
                        let import = self.dart.import(KnownDartUri::DartWasm);
                        uwriteln!(self.definition, "return {import}.WasmVoid();");
                    }
                } else if *amt == 1 {
                    let _ = writeln!(self.definition, "return {};", operands.pop().unwrap());
                } else {
                    todo!("Returning multiple parameters")
                }
            }
            Instruction::StringLower { realloc: _ } => {
                self.options.uses_memory = true;
                self.options.uses_strings = true;

                let temp = self.temporary_variable();
                let _ = write!(self.definition, "final {} = ", temp);
                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "AllocatedString",
                );
                let _ = writeln!(
                    self.definition,
                    ".allocateUtf16({});",
                    operands.pop().unwrap()
                );
                let _ = writeln!(&mut self.cleanup, "{}.free();", temp);
                results.push(Rc::new(format!("{}.ptr", temp)));
                results.push(Rc::new(format!("{}.packedLength", temp)));
            }
            Instruction::StringLift {} => {
                self.options.uses_memory = true;
                self.options.uses_strings = true;

                let length = operands.pop().unwrap();
                let ptr = operands.pop().unwrap();

                let import = self.dart.import(KnownDartUri::PkgWasmComponents);
                results.push(Rc::new(format!(
                    "{import}.AllocatedString.read({ptr}, {length})"
                )));
            }
            Instruction::OptionLift { payload, ty: _ } => {
                let tmp = self.temporary_variable();

                let (some, some_results) = self.blocks.pop().unwrap();
                let (none, _) = self.blocks.pop().unwrap();

                let has_value = operands.pop().unwrap();
                uwrite!(self.definition, "final ");
                self.definition.write_dart_type(self.dart, resolve, payload);
                uwriteln!(
                    self.definition,
                    " {tmp};
if ({has_value}.toBool()) {{
  {some}
  {tmp} = .some({});
}} else {{
  {none}
  {tmp} = .none;
}}
                    ",
                    some_results[0]
                );
                uwriteln!(self.definition, " {tmp};");
                uwriteln!(self.definition, "if ({has_value}.toBool()) {{");
                uwriteln!(self.definition, "}} else {{");
                uwriteln!(self.definition, "}}");

                results.push(tmp);
            }
            Instruction::ResultLift { result: _, ty } => {
                let tmp = self.temporary_variable();
                let (err, err_results) = self.blocks.pop().unwrap();
                let (ok, ok_results) = self.blocks.pop().unwrap();
                let is_err = operands.pop().unwrap();

                uwrite!(self.definition, "final ");
                self.definition
                    .write_dart_type(self.dart, resolve, &Type::Id(*ty));
                uwriteln!(
                    self.definition,
                    " {tmp};
if ({is_err}.toBool()) {{
  {err}
  {tmp} = .error({});
}} else {{
  {ok}
  {tmp} = .ok({});
}}
",
                    match err_results.get(0) {
                        None => "null",
                        Some(e) => e,
                    },
                    match ok_results.get(0) {
                        None => "null",
                        Some(e) => e,
                    },
                );
                results.push(tmp);
            }
            Instruction::FutureLift { payload: _, ty } => {
                let tmp = self.temporary_variable();
                let future = operands.pop().unwrap();
                uwrite!(self.definition, "final {tmp} = ");
                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "readFuture",
                );
                let vtable = self.dart.stream_future_vtables.get(ty).unwrap().clone();
                uwriteln!(
                    self.definition,
                    "(const {vtable}(), {future}.toIntUnsigned());"
                );
                results.push(tmp);
            }
            Instruction::StreamLift { payload: _, ty } => {
                let tmp = self.temporary_variable();
                let stream = operands.pop().unwrap();
                uwrite!(self.definition, "final {tmp} = ");
                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "readStream",
                );
                let vtable = self.dart.stream_future_vtables.get(ty).unwrap().clone();
                uwriteln!(
                    self.definition,
                    "(const {vtable}(), {stream}.toIntUnsigned());"
                );
                results.push(stream)
            }
            Instruction::EnumLift { enum_, name: _, ty } => {
                let index = operands.pop().unwrap();
                let enum_class = self.dart.define_enum(*ty, &resolve.types[*ty], *enum_);

                results.push(Rc::new(format!(
                    "{enum_class}.values[{index}.toIntUnsigned()]"
                )));
            }
            Instruction::GuestDeallocateString => {
                let length = operands.pop().unwrap();
                let ptr = operands.pop().unwrap();

                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "AllocatedString",
                );
                uwriteln!(&mut self.definition, "({ptr}, {length}).free();");
            }
            Instruction::VariantPayloadName => {
                results.push(Rc::new("value".into()));
            }
            Instruction::I32Const { val } => {
                let mut def = DartDefinition::default();
                let _ = write!(&mut def, "const ");
                def.imported_identifier(self.dart, KnownDartUri::DartWasm, "WasmI32");
                let _ = write!(&mut def, "({})", *val);
                results.push(Rc::new(def.take_code()));
            }
            Instruction::ResultLower {
                result: _,
                ty: _,
                results: result_types,
            } => {
                let (err, err_results) = self.blocks.pop().unwrap();
                let (ok, ok_results) = self.blocks.pop().unwrap();
                let value = operands.pop().unwrap();

                let result_names = (0..result_types.len())
                    .map(|_| self.temporary_variable())
                    .collect::<Vec<_>>();

                for (wasm_type, name) in result_types.iter().zip(&result_names) {
                    self.definition.write_core_type(self.dart, wasm_type);
                    uwriteln!(self.definition, " {};", name);
                }

                uwrite!(self.definition, "switch ({value}) {{\n  case ");
                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "OkResult",
                );
                uwriteln!(self.definition, "(:final value):\n{ok}");
                for (value, name) in ok_results.iter().zip(&result_names) {
                    uwriteln!(self.definition, "{name} = {value};");
                }
                uwrite!(self.definition, "  case ");
                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "ErrorResult",
                );
                uwriteln!(self.definition, "(:final value):\n{err}");
                for (value, name) in err_results.iter().zip(&result_names) {
                    uwriteln!(self.definition, "{name} = {value};");
                }
                uwriteln!(self.definition, "}}");

                results.extend(result_names);
            }
            Instruction::StreamLower { payload: _, ty } => {
                let vtable = self.dart.stream_future_vtables.get(ty).cloned().unwrap();
                let tmp = self.temporary_variable();

                uwrite!(self.definition, "  final {tmp} = ");
                self.definition.imported_identifier(
                    self.dart,
                    KnownDartUri::PkgWasmComponents,
                    "newReadableStream",
                );
                uwriteln!(
                    self.definition,
                    "(const {vtable}(), {}).toWasmI32();",
                    operands.pop().unwrap()
                );
                results.push(tmp);
            }
            Instruction::EnumLower {
                enum_: _,
                name: _,
                ty: _,
            } => {
                let value = operands.pop().unwrap();
                results.push(Rc::new(format!("{value}.index.toWasmI32()")));
            }
            Instruction::I32Store { offset }
            | Instruction::LengthStore { offset }
            | Instruction::PointerStore { offset } => {
                self.mem_store(operands, "storeInt32", offset);
            }
            Instruction::I32Store8 { offset } => self.mem_store(operands, "storeInt8", offset),
            Instruction::I32Store16 { offset } => self.mem_store(operands, "storeInt16", offset),
            Instruction::I64Store { offset } => self.mem_store(operands, "storeInt64", offset),
            Instruction::I32Load { offset }
            | Instruction::LengthLoad { offset }
            | Instruction::PointerLoad { offset } => {
                self.mem_load(operands, results, "loadInt32", offset);
            }
            Instruction::I32Load8U { offset } => {
                self.mem_load(operands, results, "loadUint8", offset)
            }
            Instruction::I32Load8S { offset } => {
                self.mem_load(operands, results, "loadInt8", offset)
            }
            Instruction::I32Load16U { offset } => {
                self.mem_load(operands, results, "loadUint16", offset)
            }
            Instruction::I32Load16S { offset } => {
                self.mem_load(operands, results, "loadInt16", offset)
            }
            Instruction::I64Load { offset } => {
                self.mem_load(operands, results, "loadInt64", offset)
            }
            Instruction::I32FromBool => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.fromBool({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromChar => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.fromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I64FromU64 | Instruction::I64FromS64 => {
                results.push(Rc::new(format!(
                    "{}.WasmI64.fromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromS8 => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.int8FromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromU8 => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.uint8FromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromS16 => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.int16FromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromU16 => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.uint16FromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromS32 => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.fromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::I32FromU32 => {
                results.push(Rc::new(format!(
                    "{}.WasmI32.fromInt({})",
                    self.dart_wasm_import(),
                    operands.pop().unwrap(),
                )));
            }
            Instruction::CoreF32FromF32 => {
                let dart_double = operands.pop().unwrap();
                results.push(Rc::new(format!(
                    "{}.WasmF32.fromDouble({dart_double})",
                    self.dart_wasm_import()
                )));
            }
            Instruction::CoreF64FromF64 => {
                let dart_double = operands.pop().unwrap();
                results.push(Rc::new(format!(
                    "{}.WasmF64.fromDouble({dart_double})",
                    self.dart.import(KnownDartUri::DartWasm)
                )));
            }
            Instruction::BoolFromI32 => {
                results.push(Rc::new(format!("{}.toBool()", operands.pop().unwrap())));
            }
            Instruction::CharFromI32 => {
                let import = self.dart.import(KnownDartUri::PkgWasmComponents);
                results.push(Rc::new(format!(
                    "{import}.CharCode({}.toIntUnsigned())",
                    operands.pop().unwrap()
                )));
            }
            Instruction::S64FromI64 | Instruction::U64FromI64 => {
                results.push(Rc::new(format!("{}.toInt()", operands.pop().unwrap())));
            }
            Instruction::S8FromI32 | Instruction::S16FromI32 | Instruction::S32FromI32 => {
                results.push(Rc::new(format!(
                    "{}.toIntSigned()",
                    operands.pop().unwrap()
                )));
            }
            Instruction::U8FromI32 | Instruction::U16FromI32 | Instruction::U32FromI32 => {
                results.push(Rc::new(format!(
                    "{}.toIntUnsigned()",
                    operands.pop().unwrap()
                )));
            }
            Instruction::F32FromCoreF32 => {
                let f32 = operands.pop().unwrap();
                results.push(Rc::new(format!("{f32}.toDouble()")));
            }
            Instruction::F64FromCoreF64 => {
                let f64 = operands.pop().unwrap();
                results.push(Rc::new(format!("{f64}.toDouble()")));
            }
            Instruction::RecordLift {
                record,
                name: _,
                ty: _,
            } => {
                let tmp = self.temporary_variable();
                uwrite!(self.definition, "  final {tmp} = (");

                for f in &record.fields {
                    let op = operands.pop().unwrap();
                    uwrite!(self.definition, "{} {op}, ", f.name);
                }

                uwriteln!(self.definition, ");");
                results.push(tmp);
            }
            Instruction::TupleLift { tuple, ty: _ } => {
                let tmp = self.temporary_variable();
                uwrite!(self.definition, "  final {tmp} = (");

                for _ in &tuple.types {
                    let op = operands.pop().unwrap();
                    uwrite!(self.definition, "{op}, ");
                }

                uwriteln!(self.definition, ");");
                results.push(tmp);
            }
            Instruction::AsyncTaskReturn { name: _, params } => {
                let args = operands.split_off(operands.len() - params.len());

                let name = match &mut self.mode {
                    FunctionMode::Exported(exported) => {
                        *exported.async_return_params = Some(params.iter().cloned().collect());

                        self.additional_imports.push(ImportedFunction {
                            import_name: exported.async_return_name.to_string(),
                            definition: ImportedFunctionDefinition::TaskReturn {
                                result_list: match exported.result_type {
                                    None => vec![],
                                    Some(e) => vec![e.clone()],
                                },
                            },
                            lower_options: self.options.clone(),
                        });

                        exported.async_return_name
                    }
                    _ => {
                        return;
                    }
                };

                uwrite!(self.definition, "{name}(");
                for arg in args {
                    uwrite!(self.definition, "{arg},");
                }
                uwrite!(self.definition, ");");
            }
            Instruction::IterElem { element: _ } => {
                results.push(Rc::new("element".to_string()));
            }
            Instruction::IterBasePointer => {
                results.push(Rc::new("elementPtr".to_string()));
            }
            Instruction::ListLower {
                element,
                realloc: _,
            } => {
                self.options.uses_memory = true;
                self.options.uses_realloc = true;
                let size = self.size_align.size(element).size_wasm32();
                let align = self.size_align.align(element).align_wasm32();

                let list = operands.pop().unwrap();

                let runtime = self.dart.import(KnownDartUri::PkgWasmComponents);
                let dart = self.dart.import(KnownDartUri::DartWasm);
                let total_length = self.temporary_variable();
                let ptr = self.temporary_variable();
                let base_ptr = self.temporary_variable();

                let (body, _) = self.blocks.pop().unwrap();
                uwriteln!(
                    self.definition,
                    "
final {total_length} = {dart}.WasmI32.fromInt({size} * {list}.length);
final {ptr} = {runtime}.mallocAligned(const {dart}.WasmI32({align}), {total_length});
var {base_ptr} = {ptr}.toIntUnsigned();
for (final element in {list}) {{
  final elementPtr = {base_ptr};
  {body}
  {base_ptr} += {size};
}}
"
                );

                uwriteln!(
                    &mut self.cleanup,
                    "{runtime}.dartFree({ptr}, {total_length}, const {dart}.WasmI32({align}));"
                );

                results.push(ptr);
                results.push(Rc::new(format!("{dart}.WasmI32.fromInt({list}.length)")));
            }
            Instruction::ListLift { element, ty: _ } => {
                self.options.uses_memory = true;
                let list = self.temporary_variable();
                let start_ptr = self.temporary_variable();

                let size = self.size_align.size(element).size_wasm32();
                let dart = self.dart.import(KnownDartUri::DartWasm);
                let ptr = operands.pop().unwrap();
                let length = operands.pop().unwrap();
                let (body, mut elements) = self.blocks.pop().unwrap();
                let value = elements.pop().unwrap();

                uwriteln!(
                    self.definition,
                    "
final {start_ptr} = {ptr}.toIntUnsigned();
final {list} = List.generate({length}.toIntUnsigned(), growable: false, (i) {{
  final elementPtr = {dart}.WasmI32.fromInt({start_ptr} + i * {size});
  {body}
  return {value};
}});
"
                );

                results.push(list);
            }
            Instruction::Flush { amt } => {
                let operands = operands.split_off(operands.len() - *amt);
                results.extend_from_slice(&operands);
            }
            _ => todo!("Instruction: {inst:?}"),
        }
    }

    fn return_pointer(&mut self, size: ArchitectureSize, align: Alignment) -> Self::Operand {
        let local = self.temporary_variable();
        let wasm_import = self.dart.import(KnownDartUri::DartWasm);
        let rt_import = self.dart.import(KnownDartUri::PkgWasmComponents);

        uwriteln!(
            &mut self.definition,
            "var {local} = {rt_import}.mallocAligned(const {wasm_import}.WasmI32({}), const {wasm_import}.WasmI32({}));",
            align.align_wasm32(),
            size.size_wasm32(),
        );

        match &mut self.mode {
            FunctionMode::Exported(e) => {
                *e.allocated_return_value = Some((size, align));
            }
            _ => {
                uwriteln!(
                    &mut self.cleanup,
                    "{rt_import}.dartFree({local}, const {wasm_import}.WasmI32({}), const {wasm_import}.WasmI32({}));",
                    size.size_wasm32(),
                    align.align_wasm32(),
                );
            }
        }

        local
    }

    fn push_block(&mut self) {
        let prev = mem::take(&mut self.definition);
        self.block_storage.push(prev);
    }

    fn finish_block(&mut self, operands: &mut Vec<Self::Operand>) {
        let to_restore = self.block_storage.pop().unwrap();
        let def = mem::replace(&mut self.definition, to_restore);
        self.blocks.push((def.take_code(), mem::take(operands)));
    }

    fn sizes(&self) -> &SizeAlign {
        self.size_align
    }

    fn is_list_canonical(&self, _resolve: &Resolve, _element: &Type) -> bool {
        false
    }
}
