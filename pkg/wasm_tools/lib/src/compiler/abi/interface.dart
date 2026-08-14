import '../components/type.dart' as types;

final class AbiInterface {
  // The full name of this interface, including name and version.
  final String fullName;

  final Map<String, AbiType> exportedTypes = {};
  final Map<String, AbiFunction> exportedFunctions = {};

  AbiInterface(this.fullName);

  @override
  String toString() {
    return 'AbiInterface: $fullName';
  }
}

final class AbiFunction {
  final List<(String, AbiType)> parameters;
  final AbiType? result;
  final bool async;

  const new({this.parameters = const [], this.result, this.async = false});
}

sealed class AbiType {
  final AbiInterface? owner;

  const AbiType({this.owner});
}

final class SimpleAbiType extends AbiType {
  final types.ValueType type;

  const SimpleAbiType.primitive(types.PrimitiveType this.type);
  const SimpleAbiType.string() : type = const types.StringType();
}

final class EnumAbiType extends AbiType {
  final List<String> cases;

  new(this.cases, {super.owner});
}

/// A type imported from another interface definition.
final class ImportedAbiType extends AbiType {
  final AbiInterface definingInterface;
  final String name;

  new(this.definingInterface, this.name, {super.owner});
}

final class StreamAbiType extends AbiType {
  final AbiType? element;

  const new(this.element, {super.owner});
}

final class FutureAbiType extends AbiType {
  final AbiType? element;

  const new(this.element, {super.owner});
}

final class ResultAbiType extends AbiType {
  final AbiType? ok;
  final AbiType? error;

  new({this.ok, this.error, super.owner});
}

final class OptionAbiType extends AbiType {
  final AbiType element;

  const new(this.element, {super.owner});
}

final class VariableLengthListAbiType extends AbiType {
  final AbiType element;

  const new(this.element, {super.owner});
}

final class RecordAbiType extends AbiType {
  final List<(String, AbiType)> fields;

  const new({required this.fields, super.owner});
}

final class VariantAbiType extends AbiType {
  final List<(String, AbiType?)> variants;

  new({super.owner, required this.variants});
}

final class TupleAbiType extends AbiType {
  final List<AbiType> fields;

  new({super.owner, required this.fields});
}

final class FlagsAbiType extends AbiType {
  final List<String> flags;

  new({super.owner, required this.flags});
}

final class ResourceAbiType extends AbiType {
  new({required super.owner});
}

final class HandleAbiType extends AbiType {
  final AbiType resource;
  final bool isOwned;

  new({super.owner, required this.resource, required this.isOwned});
}
