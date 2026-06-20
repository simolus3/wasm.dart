import 'package:test/test.dart';
import 'package:wasm_tools/src/compiler/components/component.dart';
import 'package:wasm_tools/src/compiler/components/type.dart';

import 'utils.dart';

void main() {
  test('can write types', () async {
    final c = ComponentBuilder();
    final bool = c.addValueType(PrimitiveType.bool);
    final int32 = c.addValueType(PrimitiveType.s32);
    c.addFunctionType(
      FunctionType(
        async: false,
        parameters: [
          RecordOrVariantField(label: 'a', type: int32),
          RecordOrVariantField(label: 'b', type: int32),
        ],
        result: bool,
      ),
    );

    expect(
      await componentToWat(c),
      allOf(
        contains('(type (;0;) bool)'),
        contains('(type (;1;) s32)'),
        contains('(type (;2;) (func (param "a" 1) (param "b" 1) (result 0)))'),
      ),
    );
  });

  test('can write instances', () async {
    final c = ComponentBuilder();
    final result = c.addValueType(ResultType());
    final exitFunction = c.addFunctionType(
      FunctionType(
        async: false,
        parameters: [RecordOrVariantField(label: 'status', type: result)],
        result: null,
      ),
    );
    c.addInstanceType(InstanceType([('exit', exitFunction)]));

    expect(await componentToWat(c), r'''
(component
  (type (;0;) (result))
  (type (;1;) (func (param "status" 0)))
  (type (;2;)
    (instance
      (alias outer 1 1 (type (;0;)))
      (export (;0;) "exit" (func (type 0)))
    )
  )
)
''');
  });
}
