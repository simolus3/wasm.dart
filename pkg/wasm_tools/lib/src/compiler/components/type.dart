import 'component.dart';
import 'definition.dart';
import 'index_space.dart';

/// A type in the component model.
sealed class ModelType {}

final class ModelTypeReference extends ModelType {
  /// The index of the referenced type.
  final ComponentTypeIndex index;

  new(this.index);
}

sealed class ValueType extends ModelType {}

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
}

final class RecordType implements ValueType {
  final List<RecordField> fields;

  RecordType(this.fields);
}

final class VariantType implements ValueType {
  final List<VariantField> fields;

  VariantType(this.fields);

  /// The width of the unsigned integer type acting as a discriminant for this
  /// variant.
  ///
  /// This returns either 8, 16 or 32.
  int get discriminantWidth {
    return switch (fields.length.bitLength) {
      <= 8 => 8,
      <= 16 => 16,
      _ => 32,
    };
  }
}

typedef RecordField = RecordOrVariantField<ModelType>;

typedef VariantField = RecordOrVariantField<ModelType?>;

final class RecordOrVariantField<T extends ModelType?> {
  final String label;
  final T type;

  RecordOrVariantField({required this.label, required this.type});
}

final class VariableLengthListType implements ValueType {
  final ModelType elementType;

  VariableLengthListType({required this.elementType});
}

final class FixedLengthListType implements ValueType {
  final ModelType elementType;
  final int length;

  FixedLengthListType({required this.elementType, required this.length});
}

final class TupleType implements ValueType {
  final List<ModelType> elements;

  TupleType(this.elements);
}

final class FlagsType implements ValueType {
  final List<String> flagNames;

  FlagsType(this.flagNames);
}

final class EnumType implements ValueType {
  final List<String> enumNames;

  EnumType(this.enumNames);
}

final class OptionType implements ValueType {
  final ModelType inner;

  OptionType(this.inner);
}

final class ResultType implements ValueType {
  final ModelType? ok;
  final ModelType? error;

  ResultType({this.ok, this.error});
}

final class OwnType implements ValueType {
  final ComponentTypeIndex resource;

  OwnType(this.resource);
}

final class BorrowType implements ValueType {
  final ComponentTypeIndex resource;

  BorrowType(this.resource);
}

final class StreamType implements ValueType {
  final ModelType? element;

  StreamType([this.element]);
}

final class FutureType implements ValueType {
  final ModelType? element;

  FutureType([this.element]);
}

final class ResourceType extends ModelType {
  final bool hasInt64Representation;
  final CoreFunctionIndex? destructor;

  ResourceType(this.hasInt64Representation, this.destructor);
}

final class FunctionType extends ModelType {
  final bool async;
  final List<RecordField> parameters;
  final ModelType? result;

  FunctionType({
    required this.async,
    required this.parameters,
    required this.result,
  });
}

final class InstanceType extends ModelType with HasDefinitions {
  ComponentFunctionIndex exportFunction(
    String name,
    ComponentTypeIndex functionType,
  ) {
    addDefinition(ExportDeclFunction(name, functionType));
    return counters.incrementComponentFunction();
  }

  ComponentTypeIndex exportTypeEq(String name, ComponentTypeIndex type) {
    addDefinition(ExportDeclTypeEq(name, type));
    return counters.incrementComponentType();
  }

  ComponentTypeIndex exportTypeSubResource(String name) {
    addDefinition(ExportDeclTypeSubResource(name));
    return counters.incrementComponentType();
  }
}
