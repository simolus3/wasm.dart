import 'package:test/test.dart';

import 'package:wasm_components/src/third_party/wasm_builder/wasm_builder.dart'
    as w;
import 'package:wasm_components/src/compiler/components/component.dart';
import 'package:wasm_components/src/compiler/components/type.dart';

import 'utils.dart';

void main() {
  test('can define simple component', () async {
    final builder = ComponentBuilder();
    final app = builder.defineModule(_defineModuleCallingExit0());

    final resultType = builder.addType(ResultType());
    final exitFunctionType = builder.addType(
      FunctionType(
        async: false,
        parameters: [RecordOrVariantField(label: 'status', type: resultType)],
        result: null,
      ),
    );
    final mainType = builder.addType(
      FunctionType(async: false, parameters: [], result: resultType),
    );
    final wasiCliExitInstanceType = builder.addType(
      InstanceType([('exit', exitFunctionType)]),
    );
    final exitInstance = builder.importInstance(
      'wasi:cli/exit@0.2.12',
      wasiCliExitInstanceType,
    );
    final componentExitFunc = builder.linker.alias(
      .componentFunction,
      .instanceExport(exitInstance, 'exit'),
    );
    final coreExitFunc = builder.linker.canonLower(componentExitFunc);
    final instantiatedApp = builder.linker.coreInstantiate(
      .moduleAndArgs(app, {
        'runtime': builder.linker.coreInstantiate(
          .inlineExports([
            ('exit', .coreFunction, coreExitFunc.createdCoreFunction),
          ]),
        ),
      }),
    );
    final coreMain = builder.linker.alias(
      .coreFunction,
      .coreInstanceExport(instantiatedApp, 'main'),
    );
    final main = builder.linker.canonLift(coreMain, mainType);
    final finalInstance = builder.linker.instance(
      inlineExports: [('run', .componentFunction, main.createdFunction)],
    );

    expect(await componentToWat(builder), '''
(component
  (core module (;0;)
    (type (;0;) (func (param i32)))
    (type (;1;) (func (result i32)))
    (import "runtime" "exit" (func (;0;) (type 0)))
    (export "main" (func 1))
    (func (;1;) (type 1) (result i32)
      i32.const 1
      call 0
      i32.const 0
      return
    )
  )
  (type (;0;) (result))
  (type (;1;) (func (param "status" 0)))
  (type (;2;) (func (result 0)))
  (type (;3;)
    (instance
      (alias outer 1 1 (type (;0;)))
      (export (;0;) "exit" (func (type 0)))
    )
  )
  (import "wasi:cli/exit@0.2.12" (instance (;0;) (type 3)))
  (alias export 0 "exit" (func (;0;)))
  (core func (;0;) (canon lower (func 0)))
  (core instance (;0;)
    (export "exit" (func 0))
  )
  (core instance (;1;) (instantiate 0
      (with "runtime" (instance 0))
    )
  )
  (alias core export 1 "main" (core func (;1;)))
  (func (;1;) (type 2) (canon lift (core func 1)))
  (instance (;1;)
    (export "run" (func 1))
  )
)
''');
  });
}

w.Module _defineModuleCallingExit0() {
  final builder = w.ModuleBuilder('callExit0', null);
  final exitSignature = builder.types.defineFunction([w.NumType.i32], []);
  final mainSignature = builder.types.defineFunction([], [w.NumType.i32]);

  final exit = builder.functions.import('runtime', 'exit', exitSignature);
  final main = builder.functions.define(mainSignature);
  main.body
    ..i32_const(1)
    ..call(exit)
    ..i32_const(0)
    ..return_()
    ..end();
  builder.exports.export('main', main);

  return builder.build();
}
