import 'package:test/test.dart';
import 'package:wasm_tools/src/compiler/components/component.dart';
import 'package:wasm_tools/src/compiler/components/type.dart';

import 'utils.dart';

void main() {
  test('can write types', () async {
    final c = ComponentBuilder();
    final bool = c.addType(PrimitiveType.bool);
    final int32 = c.addType(PrimitiveType.s32);
    c.addType(
      FunctionType(
        async: false,
        parameters: [
          RecordOrVariantField(label: 'a', type: ModelTypeReference(int32)),
          RecordOrVariantField(label: 'b', type: ModelTypeReference(int32)),
        ],
        result: ModelTypeReference(bool),
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
    final outerType = c.addType(PrimitiveType.s8);

    final instanceType = InstanceType();
    final exportedType = instanceType.exportTypeEq(
      'foo',
      instanceType.addType(
        RecordType([
          .new(label: 'a', type: PrimitiveType.bool),
          .new(label: 'b', type: PrimitiveType.s16),
        ]),
      ),
    );
    instanceType.exportFunction(
      'return-foo',
      instanceType.addType(
        FunctionType(
          async: false,
          parameters: [
            .new(
              label: 'a',
              type: ModelTypeReference(
                instanceType.alias(.componentType, .outer(1, outerType)),
              ),
            ),
          ],
          result: ModelTypeReference(exportedType),
        ),
      ),
    );

    c.addType(instanceType);

    expect(await componentToWat(c), r'''
(component
  (type (;0;) s8)
  (type (;1;)
    (instance
      (type (;0;) (record (field "a" bool) (field "b" s16)))
      (export (;1;) "foo" (type (eq 0)))
      (alias outer 1 0 (type (;2;)))
      (type (;3;) (func (param "a" 2) (result 1)))
      (export (;0;) "return-foo" (func (type 3)))
    )
  )
)
''');
  });

  test('resources', () async {
    final c = ComponentBuilder();
    final types = c.addType(
      InstanceType()..exportTypeSubResource('my-resource'),
    );
    final importedTypes = c.importInstance('foo:bar/types', types);
    final resourceType = c.alias(
      .componentType,
      .instanceExport(importedTypes, 'my-resource'),
    );
    final otherType = InstanceType();
    final aliased = otherType.alias(.componentType, .outer(1, resourceType));
    otherType.exportTypeEq('my-resource', aliased);
    otherType.exportFunction(
      'get-my-resource',
      otherType.addType(
        FunctionType(async: false, parameters: [], result: null),
      ),
    );
    c.importInstance('foo:bar/factory', c.addType(otherType));

    expect(await componentToWat(c), r'''(component
  (type (;0;)
    (instance
      (export (;0;) "my-resource" (type (sub resource)))
    )
  )
  (import "foo:bar/types" (instance (;0;) (type 0)))
  (alias export 0 "my-resource" (type (;1;)))
  (type (;2;)
    (instance
      (alias outer 1 1 (type (;0;)))
      (export (;1;) "my-resource" (type (eq 0)))
      (type (;2;) (func))
      (export (;0;) "get-my-resource" (func (type 2)))
    )
  )
  (import "foo:bar/factory" (instance (;1;) (type 2)))
)
''');
  });
}
