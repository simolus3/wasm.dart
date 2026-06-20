use std::rc::Rc;
use std::{fmt::Write, mem};

use heck::ToLowerCamelCase;
use wit_bindgen_core::{
    abi::{Bindgen, Instruction},
    wit_parser::{Function, InterfaceId, Resolve, SizeAlign, Type},
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
    args: Vec<Rc<String>>,
    pub definition: DartDefinition,
    block_storage: Vec<DartDefinition>,
    blocks: Vec<(String, Vec<Rc<String>>)>,
    interface: InterfaceId,
    mode: FunctionMode<'a>,
    cleanup: String,
    next_temporary: usize,
    pub options: FunctionOptions,
}

pub enum FunctionMode<'a> {
    Imported(ImportedFunctionMode<'a>),
    Exported(ExportedFunctionMode<'a>),
}

pub struct ImportedFunctionMode<'a> {
    pub function_name: String,
    pub core_name: &'a str,
}

pub struct ExportedFunctionMode<'a> {
    pub instance: &'a mut ExportedInstance,
}

impl<'a> DartFunctionGenerator<'a> {
    pub fn new(
        size_align: &'a SizeAlign,
        dart: &'a mut DartSource,
        function: &Function,
        interface: InterfaceId,
        mode: FunctionMode<'a>,
    ) -> Self {
        Self {
            size_align,
            dart,
            args: function
                .params
                .iter()
                .map(|p| Rc::new(p.name.to_lower_camel_case()))
                .collect(),
            definition: DartDefinition::default(),
            interface,
            mode,
            block_storage: Default::default(),
            blocks: Default::default(),
            cleanup: Default::default(),
            next_temporary: 0,
            options: Default::default(),
        }
    }

    fn temporary_variable(&mut self) -> Rc<String> {
        let rc = Rc::new(format!("tmp{}", self.next_temporary));
        self.next_temporary += 1;
        rc
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
            Instruction::GetArg { nth } => results.push(self.args[*nth].clone()),
            Instruction::CallWasm { name: _, sig } => {
                let temp = self.temporary_variable();
                let core_name = match &self.mode {
                    FunctionMode::Imported(i) => i.core_name,
                    FunctionMode::Exported(_) => {
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
                    "final {} = {}.{}(",
                    tmp, interface.instance.field_name, func.name
                );
                if !func.params.is_empty() {
                    todo!("Handling interface calls with parameters")
                }
                let _ = writeln!(self.definition, ");");

                results.push(tmp);
            }
            Instruction::Return { amt, func: _ } => {
                if *amt == 0 {
                    // Nothing to do
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
            _ => todo!("Instruction: {inst:?}"),
        }
    }

    fn return_pointer(
        &mut self,
        size: wit_bindgen_core::wit_parser::ArchitectureSize,
        align: wit_bindgen_core::wit_parser::Alignment,
    ) -> Self::Operand {
        todo!()
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

    fn is_list_canonical(&self, resolve: &Resolve, element: &Type) -> bool {
        false
    }
}
