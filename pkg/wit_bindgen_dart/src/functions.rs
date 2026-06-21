use std::rc::Rc;
use std::{fmt::Write, mem};

use heck::{AsLowerCamelCase, ToLowerCamelCase};
use wit_bindgen_core::wit_parser::{Alignment, ArchitectureSize};
use wit_bindgen_core::{
    abi::{Bindgen, Instruction},
    wit_parser::{Function, Resolve, SizeAlign, Type},
};
use wit_bindgen_core::{uwrite, uwriteln};

use crate::dart_source::DartSource;
use crate::{
    bindgen::{ExportedInstance, FunctionOptions},
    dart_source::{DartDefinition, KnownDartUri},
};

pub struct DartFunctionGenerator<'a> {
    size_align: &'a SizeAlign,
    dart: &'a mut DartSource,
    pub definition: DartDefinition,
    block_storage: Vec<DartDefinition>,
    blocks: Vec<(String, Vec<Rc<String>>)>,
    mode: FunctionMode<'a>,
    cleanup: String,
    next_temporary: usize,
    pub options: FunctionOptions,
    pub allocated_return_value: Option<(ArchitectureSize, Alignment)>,
}

pub enum FunctionMode<'a> {
    Imported(ImportedFunctionMode<'a>),
    Exported(ExportedFunctionMode<'a>),
    PostReturn(PostReturn),
}

pub struct ImportedFunctionMode<'a> {
    pub core_name: &'a str,
    pub function: &'a Function,
}

pub struct ExportedFunctionMode<'a> {
    pub instance: &'a mut ExportedInstance,
    pub function: &'a Function,
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
            allocated_return_value: None,
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

    pub fn write_cleanup(&mut self) {
        if !self.cleanup.is_empty() {
            let cleanup = std::mem::take(&mut self.cleanup);
            let _ = write!(self.definition, "{}", cleanup);
        }
    }
}

impl<'a> Bindgen for DartFunctionGenerator<'a> {
    type Operand = Rc<String>;

    fn emit(
        &mut self,
        _resolve: &wit_bindgen_core::wit_parser::Resolve,
        inst: &wit_bindgen_core::abi::Instruction<'_>,
        operands: &mut Vec<Self::Operand>,
        results: &mut Vec<Self::Operand>,
    ) {
        match inst {
            Instruction::GetArg { nth } => {
                let function = match &self.mode {
                    FunctionMode::Imported(import) => import.function,
                    FunctionMode::Exported(export) => export.function,
                    FunctionMode::PostReturn(_) => {
                        results.push(Rc::new(format!("p{nth}")));
                        return;
                    }
                };

                results.push(Rc::new(function.params[*nth].name.to_lower_camel_case()));
            }
            Instruction::CallWasm { name: _, sig } => {
                let temp = self.temporary_variable();
                let core_name = match &self.mode {
                    FunctionMode::Imported(i) => i.core_name,
                    _ => {
                        panic!("Can't generate call instruction in export mode")
                    }
                };

                let _ = write!(self.definition, "final {} = {}(", temp, core_name);

                let operands = operands.split_off(operands.len() - sig.params.len());
                for (i, operand) in operands.iter().enumerate() {
                    if i != 0 {
                        let _ = write!(self.definition, ", ");
                    }

                    let _ = write!(self.definition, "{}", operand);
                }
                let _ = writeln!(self.definition, ");");

                if !sig.results.is_empty() {
                    todo!("handling webassembly calls with return values")
                }
            }
            Instruction::CallInterface { func, async_ } => {
                if *async_ {
                    todo!()
                }
                let tmp = self.temporary_variable();
                let interface = match &mut self.mode {
                    FunctionMode::Exported(i) => i,
                    _ => panic!("Cannot use CallInterface in import mode"),
                };

                let _ = write!(
                    self.definition,
                    "final {tmp} = {}.{}(",
                    interface.instance.field_name,
                    AsLowerCamelCase(&func.name)
                );
                if !func.params.is_empty() {
                    todo!("Handling interface calls with parameters")
                }
                let _ = writeln!(self.definition, ");");

                results.push(tmp);
            }
            Instruction::Return { amt, func: _ } => {
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
                self.options.use_memory = true;
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
            Instruction::I32Store { offset }
            | Instruction::LengthStore { offset }
            | Instruction::PointerStore { offset } => {
                self.mem_store(operands, "storeInt32", offset);
            }
            Instruction::I32Load { offset }
            | Instruction::LengthLoad { offset }
            | Instruction::PointerLoad { offset } => {
                self.mem_load(operands, results, "loadInt32", offset);
            }
            _ => todo!("Instruction: {inst:?}"),
        }
    }

    fn return_pointer(&mut self, size: ArchitectureSize, align: Alignment) -> Self::Operand {
        assert!(self.allocated_return_value.is_none());

        let local = self.temporary_variable();
        uwrite!(&mut self.definition, "var {local} = ");
        self.definition.imported_identifier(
            self.dart,
            KnownDartUri::PkgWasmComponents,
            "mallocAligned",
        );
        uwrite!(&mut self.definition, "(const ");
        self.definition
            .imported_identifier(self.dart, KnownDartUri::DartWasm, "WasmI32");
        uwrite!(&mut self.definition, "({})", align.align_wasm32());
        uwrite!(&mut self.definition, ", const ");
        self.definition
            .imported_identifier(self.dart, KnownDartUri::DartWasm, "WasmI32");
        uwriteln!(&mut self.definition, "({}));", size.size_wasm32());
        self.allocated_return_value = Some((size, align));

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
