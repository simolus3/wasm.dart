use std::fmt::Write;
use std::rc::Rc;

use heck::ToLowerCamelCase;
use wit_bindgen_core::{
    abi::{Bindgen, Instruction},
    wit_parser::{Function, InterfaceId, Resolve, SizeAlign, Type},
};

use crate::{
    bindgen::{DartWorldGenerator, ImportedCoreFunction},
    dart_source::{DartDefinition, KnownDartUri},
};

pub struct DartFunctionGenerator<'a> {
    world: &'a mut DartWorldGenerator,
    args: Vec<Rc<String>>,
    definition: &'a mut DartDefinition,
    interface: InterfaceId,
    function_name: String,
    cleanup: String,
    next_temporary: usize,
}

impl<'a> DartFunctionGenerator<'a> {
    pub fn new(
        world: &'a mut DartWorldGenerator,
        function: &Function,
        definition: &'a mut DartDefinition,
        interface: InterfaceId,
        function_name: String,
    ) -> Self {
        Self {
            world,
            args: function
                .params
                .iter()
                .map(|p| Rc::new(p.name.to_lower_camel_case()))
                .collect(),
            definition,
            interface,
            function_name,
            cleanup: Default::default(),
            next_temporary: 0,
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
        resolve: &wit_bindgen_core::wit_parser::Resolve,
        inst: &wit_bindgen_core::abi::Instruction<'_>,
        operands: &mut Vec<Self::Operand>,
        results: &mut Vec<Self::Operand>,
    ) {
        println!("Handling instruction {inst:?}");

        match inst {
            Instruction::GetArg { nth } => results.push(self.args[*nth].clone()),
            Instruction::CallWasm { name: _, sig } => {
                let temp = self.temporary_variable();
                let existing_function_count = self.world.function_imports.len();
                let function_name = Rc::new(format!("_import{}", existing_function_count));
                self.world.function_imports.push(ImportedCoreFunction {
                    interface: self.interface,
                    function_name: self.function_name.clone(),
                    core_name: function_name.clone(),
                });
                self.world
                    .main
                    .add_core_function_import(&function_name, sig);

                let _ = write!(self.definition, "final {} = {}(", temp, function_name);

                let operands = operands.split_off(operands.len() - sig.params.len());
                for (i, operand) in operands.iter().enumerate() {
                    if i != 0 {
                        let _ = write!(self.definition, ", ");
                    }

                    let _ = write!(self.definition, "{}", operand);
                }
                let _ = writeln!(self.definition, ");");

                if !sig.results.is_empty() {
                    todo!()
                }
            }
            Instruction::Return { amt, func: _ } => {
                if *amt != 0 {
                    todo!()
                }
            }
            Instruction::StringLower { realloc: _ } => {
                let temp = self.temporary_variable();
                let _ = write!(self.definition, "final {} = ", temp);
                self.definition.imported_identifier(
                    &mut self.world.main,
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
            _ => todo!(),
        }
    }

    fn return_pointer(
        &mut self,
        size: wit_bindgen_core::wit_parser::ArchitectureSize,
        align: wit_bindgen_core::wit_parser::Alignment,
    ) -> Self::Operand {
        todo!()
    }

    fn push_block(&mut self) {}

    fn finish_block(&mut self, operand: &mut Vec<Self::Operand>) {}

    fn sizes(&self) -> &SizeAlign {
        &self.world.size_align
    }

    fn is_list_canonical(&self, resolve: &Resolve, element: &Type) -> bool {
        false
    }
}
