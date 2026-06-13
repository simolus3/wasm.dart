import 'package:collection/collection.dart';

const _listEquality = ListEquality<Object?>();

/// A type in the component model.
sealed class ModelType {}

sealed class ValueType extends ModelType {}

enum PrimitiveType implements ValueType {
  s8,
  u8,
  s16,
  u16,
  s32,
  u32,
  s64,
  u64,
  f32,
  f64,
  char,
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

typedef VariantField = RecordOrVariantField<ValueType>?;

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
  final ValueType elementType;

  VariableLengthListType({required this.elementType});

  @override
  bool operator ==(Object other) =>
      other is VariableLengthListType && elementType == other.elementType;

  @override
  int get hashCode => elementType.hashCode;
}

final class FixedLengthListType implements ValueType {
  final ValueType elementType;
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
  final List<ModelType> elements;

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
  final ValueType inner;

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
  final ResourceType resource;

  OwnType(this.resource);

  @override
  bool operator ==(Object other) =>
      other is OwnType && resource == other.resource;

  @override
  int get hashCode => resource.hashCode;
}

final class BorrowType implements ValueType {
  final ResourceType resource;

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

final class ResourceType extends ModelType {}

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

final class InstanceType extends ModelType {}
