import 'package:test/test.dart';
import 'package:wasm_tools/src/compiler/components/component.dart';
import 'package:wasm_tools/src/compiler/components/type.dart';

import 'utils.dart';

void main() {
  test('can write types', () async {
    final c = ComponentBuilder();
    final bool = c.types.addValueType(PrimitiveType.bool);
    final int32 = c.types.addValueType(PrimitiveType.s32);
    c.types.addFunctionType(
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
    // To make sure we either generate an alias or duplicate the type.
    final outerType = c.types.addValueType(PrimitiveType.s8);

    final builder = InstanceTypeBuilder();
    final exportedType = builder.exportType(
      'foo',
      RecordType([
        .new(label: 'a', type: PrimitiveType.bool),
        .new(label: 'b', type: PrimitiveType.s16),
      ]),
    );
    builder.exportFunction(
      'return-foo',
      FunctionType(
        async: false,
        parameters: [.new(label: 'a', type: outerType)],
        result: exportedType,
      ),
    );

    c.types.addInstanceType(builder.build());

    expect(await componentToWat(c), r'''
(component
  (type (;0;) s8)
  (type (;1;)
    (instance
      (type (;0;) bool)
      (type (;1;) s16)
      (type (;2;) (record (field "a" 0) (field "b" 1)))
      (export (;3;) "foo" (type (eq 2)))
      (type (;4;) s8)
      (type (;5;) (func (param "a" 4) (result 3)))
      (export (;0;) "return-foo" (func (type 5)))
    )
  )
)
''');
  });
}
