import 'package:collection/collection.dart';

import 'index_space.dart';

const _listEquality = ListEquality<Object?>();

/// A type in the component model.
sealed class ModelType {}

final class ModelTypeReference<T extends ModelType> extends ModelType {
  final ComponentTypeIndex index;
  final T resolvedType;

  ModelTypeReference(this.index, this.resolvedType);

  // Replacing a type with a type reference must not change hash codes or
  // equality.

  @override
  int get hashCode => resolvedType.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ModelTypeReference &&
      (
      // Comparing indices is an optimization, if the index is the same then so
      // is the underlying type.
      index == other.index || other.resolvedType == resolvedType);
}

sealed class ValueType extends ModelType {}

final class ValueTypeReference extends ModelTypeReference<ValueType>
    implements ValueType {
  ValueTypeReference(super.index, super.resolvedType);
}

enum PrimitiveType implements ValueType {
  bool(0x7f),
  s8(0x7e),
  u8(0x7d),
  s16(0x7c),
  u16(0x7b),
  s32(0x7a),
  u32(0x79),
  s64(0x78),
  u64(0x77),
  f32(0x76),
  f64(0x75),
  char(0x74);

  final int typeCode;

  const PrimitiveType(this.typeCode);
}

/// The `string` type, which decays to a `list<char>` but has a special ABI
/// representation.
final class StringType implements ValueType {
  const StringType();

  @override
  int get hashCode => 'string'.hashCode;

  @override
  bool operator ==(Object other) => other is StringType;
}

final class RecordType implements ValueType {
  final List<RecordField> fields;

  RecordType(this.fields);

  @override
  bool operator ==(Object other) =>
      other is RecordType && _listEquality.equals(fields, other.fields);

  @override
  int get hashCode => _listEquality.hash(fields);
}

final class VariantType implements ValueType {
  final List<VariantField> fields;

  VariantType(this.fields);

  @override
  bool operator ==(Object other) =>
      other is VariantType && _listEquality.equals(fields, other.fields);

  @override
  int get hashCode => _listEquality.hash(fields);
}

typedef RecordField = RecordOrVariantField<ValueType>;

typedef VariantField = RecordOrVariantField<ValueType?>;

final class RecordOrVariantField<T extends ValueType?> {
  final String label;
  final T type;

  RecordOrVariantField({required this.label, required this.type});

  @override
  bool operator ==(Object other) =>
      other is RecordOrVariantField<T> &&
      label == other.label &&
      type == other.type;

  @override
  int get hashCode => Object.hash(label, type);
}

final class VariableLengthListType implements ValueType {
  final ModelTypeReference<ValueType> elementType;

  VariableLengthListType({required this.elementType});

  @override
  bool operator ==(Object other) =>
      other is VariableLengthListType && elementType == other.elementType;

  @override
  int get hashCode => elementType.hashCode;
}

final class FixedLengthListType implements ValueType {
  final ModelTypeReference<ValueType> elementType;
  final int length;

  FixedLengthListType({required this.elementType, required this.length});

  @override
  bool operator ==(Object other) =>
      other is FixedLengthListType &&
      elementType == other.elementType &&
      length == other.length;

  @override
  int get hashCode => Object.hash(elementType, length);
}

final class TupleType implements ValueType {
  final List<ModelTypeReference<ValueType>> elements;

  TupleType(this.elements);

  @override
  bool operator ==(Object other) =>
      other is TupleType && _listEquality.equals(elements, other.elements);

  @override
  int get hashCode => _listEquality.hash(elements);
}

final class FlagsType implements ValueType {
  final List<String> flagNames;

  FlagsType(this.flagNames);

  @override
  bool operator ==(Object other) =>
      other is FlagsType && _listEquality.equals(flagNames, other.flagNames);

  @override
  int get hashCode => _listEquality.hash(flagNames);
}

final class EnumType implements ValueType {
  final List<String> enumNames;

  EnumType(this.enumNames);

  @override
  bool operator ==(Object other) =>
      other is EnumType && _listEquality.equals(enumNames, other.enumNames);

  @override
  int get hashCode => _listEquality.hash(enumNames);
}

final class OptionType implements ValueType {
  final ModelTypeReference<ValueType> inner;

  OptionType(this.inner);

  @override
  bool operator ==(Object other) => other is OptionType && inner == other.inner;

  @override
  int get hashCode => inner.hashCode;
}

final class ResultType implements ValueType {
  final ValueType? ok;
  final ValueType? error;

  ResultType({this.ok, this.error});

  @override
  bool operator ==(Object other) =>
      other is ResultType && ok == other.ok && error == other.error;

  @override
  int get hashCode => Object.hash(ok, error);
}

final class OwnType implements ValueType {
  final ModelTypeReference<ResourceType> resource;

  OwnType(this.resource);

  @override
  bool operator ==(Object other) =>
      other is OwnType && resource == other.resource;

  @override
  int get hashCode => resource.hashCode;
}

final class BorrowType implements ValueType {
  final ModelTypeReference<ResourceType> resource;

  BorrowType(this.resource);

  @override
  bool operator ==(Object other) =>
      other is BorrowType && resource == other.resource;

  @override
  int get hashCode => resource.hashCode;
}

final class StreamType implements ValueType {
  final ValueType element;

  StreamType(this.element);
}

final class FutureType implements ValueType {
  final ValueType element;

  FutureType(this.element);
}

final class ResourceType extends ModelType {
  final bool hasInt64Representation;
  final CoreFunctionIndex? destructor;

  ResourceType(this.hasInt64Representation, this.destructor);
}

final class FunctionType extends ModelType {
  final bool async;
  final List<RecordField> parameters;
  final ValueType? result;

  FunctionType({
    required this.async,
    required this.parameters,
    required this.result,
  });

  @override
  bool operator ==(Object other) =>
      other is FunctionType &&
      async == other.async &&
      _listEquality.equals(parameters, other.parameters) &&
      result == other.result;

  @override
  int get hashCode =>
      Object.hash(async, _listEquality.hash(parameters), result);
}

final class FunctionTypeReference extends ModelTypeReference<FunctionType>
    implements FunctionType {
  FunctionTypeReference(super.index, super.resolvedType);

  @override
  bool get async => resolvedType.async;

  @override
  List<RecordField> get parameters => resolvedType.parameters;

  @override
  ValueType? get result => resolvedType.result;
}

final class InstanceType extends ModelType {
  /// The functions exported by this instance.
  ///
  /// The component model also supports exporting other values, but we don't
  /// currently support that.
  final List<(String, FunctionType)> exports;

  InstanceType(this.exports);

  @override
  int get hashCode => _listEquality.hash(exports);

  @override
  bool operator ==(Object other) =>
      other is InstanceType && _listEquality.equals(other.exports, exports);
}

final class InstanceTypeReference extends ModelTypeReference<InstanceType>
    implements InstanceType {
  InstanceTypeReference(super.index, super.resolvedType);

  @override
  List<(String, FunctionType)> get exports => resolvedType.exports;
}
