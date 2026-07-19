import 'index_space.dart';
import 'type.dart';

final class TypesContainer {
  final List<ModelType> _types;
  final Map<ModelType, ModelTypeReference> _typesToIndex = {};

  TypesContainer(this._types);

  R _addType<T extends ModelType, R extends ModelTypeReference<T>>(
    T type,
    R Function(TypesContainer, ComponentTypeIndex, T) create,
  ) {
    return _typesToIndex.putIfAbsent(type, () {
      final idx = ComponentTypeIndex(_types.length);
      _types.add(type);
      return create(this, idx, type);
    }) as R;
  }

  FunctionTypeReference addFunctionType(FunctionType type) {
    if (type case FunctionTypeReference ref
        when identical(ref.container, this)) {
      return type;
    }

    final result = switch (type.result) {
      null => null,
      final type => addValueType(type),
    };
    final params = [
      for (final param in type.parameters)
        RecordOrVariantField(
          label: param.label,
          type: addValueType(param.type),
        ),
    ];

    return _addType(
      FunctionType(async: type.async, parameters: params, result: result),
      FunctionTypeReference.new,
    );
  }

  InstanceTypeReference addInstanceType(InstanceType type) {
    if (type case InstanceTypeReference ref
        when identical(ref.container, this)) {
      return type;
    }
    return _addType(type, InstanceTypeReference.new);

    // Don't normalize inner types, instance types have their own type index.
    // final exports = <InstanceExport>[
    //   for (final InstanceExport(:name, :kind, :innerType) in type.exports)
    //     switch (kind) {
    //       InstanceExportKind.type => .type(
    //         name,
    //         addValueType(innerType as ValueType),
    //       ),
    //       InstanceExportKind.function => .function(
    //         name,
    //         addFunctionType(innerType as FunctionType),
    //       ),
    //     },
    // ];

    // return _addType(InstanceType(exports), InstanceTypeReference.new);
  }

  ValueTypeReference addValueType(ValueType type) {
    ValueTypeReference addInner(ValueType type) =>
        _addType(type, ValueTypeReference.new);

    switch (type) {
      case ValueTypeReference():
        if (identical(type.container, this)) {
          return type;
        } else {
          // Referenced across containers, copy into this one.
          return addValueType(type.resolvedType);
        }
      case RecordType(:final fields):
        final normalizedFields = <RecordField>[
          for (final field in fields)
            RecordField(label: field.label, type: addValueType(field.type)),
        ];
        return addInner(RecordType(normalizedFields));
      case VariantType():
        // TODO: Handle this case.
        throw UnimplementedError();
      case VariableLengthListType(:final elementType):
        final normalizedElement = addValueType(elementType);
        return addInner(VariableLengthListType(elementType: normalizedElement));
      case FixedLengthListType():
        // TODO: Handle this case.
        throw UnimplementedError();
      case TupleType():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OptionType(:final inner):
        return addInner(OptionType(addValueType(inner)));
      case ResultType(:final ok, :final error):
        final normalizedOk = ok != null ? addValueType(ok) : null;
        final normalizedError = error != null ? addValueType(error) : null;
        return addInner(ResultType(ok: normalizedOk, error: normalizedError));
      case OwnType():
        // TODO: Handle this case.
        throw UnimplementedError();
      case BorrowType():
        // TODO: Handle this case.
        throw UnimplementedError();
      case StreamType(:final element):
        return addInner(
          StreamType(element == null ? null : addValueType(element)),
        );
      case FutureType(:final element):
        return addInner(
          FutureType(element == null ? null : addValueType(element)),
        );
      case EnumType():
      case PrimitiveType():
      case StringType():
      case FlagsType():
        return addInner(type);
    }
  }
}
