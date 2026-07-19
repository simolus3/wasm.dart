import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'core_module.dart';
import 'linker.dart';
import 'type.dart';

final class ModuleSection extends w.Section {
  final CoreModule module;

  ModuleSection(this.module, [super.watchPoints = const []]);

  @override
  int get id => 1;

  @override
  void serializeContents(w.Serializer s) {
    module.serialize(s);
  }
}

final class CoreInstanceSection extends w.Section {
  final List<CoreInstanceExpression> instances;

  CoreInstanceSection(this.instances, [super.watchPoints = const []]);

  @override
  int get id => 2;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(instances);
  }
}

final class InstanceSection extends w.Section {
  final List<InstanceFromInlineExports> instances;

  InstanceSection(this.instances, [super.watchPoints = const []]);

  @override
  int get id => 5;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(instances);
  }
}

final class AliasSection extends w.Section {
  final List<AliasDefinition> aliases;

  AliasSection(this.aliases, [super.watchPoints = const []]);

  @override
  int get id => 6;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(aliases);
  }
}

final class TypesSection extends w.Section {
  final List<ModelType> types;

  TypesSection(this.types, [super.watchPoints = const []]);

  @override
  int get id => 7;

  @override
  void serializeContents(w.Serializer s) {
    s.writeUnsigned(types.length);
    for (final type in types) {
      _writeType(type, s);
    }
  }

  void _writeType(ModelType type, w.Serializer s) {
    switch (type) {
      case ModelTypeReference(:final index):
        s.writeUnsigned(index.index);
      case PrimitiveType(:final typeCode):
        s.writeByte(typeCode);
      case StringType():
        s.writeByte(0x73);
      case RecordType(:final fields):
        assert(fields.isNotEmpty);
        s.writeByte(0x72);
        s.writeUnsigned(fields.length);
        for (final field in fields) {
          _writeLabelledType(s, field.label, field.type);
        }
      case VariantType(:final fields):
        assert(fields.isNotEmpty);
        s.writeByte(0x71);
        s.writeUnsigned(fields.length);
        for (final field in fields) {
          s.writeName(field.label);
          _writeOptionalType(field.type, s);
          s.writeByte(0x00);
        }
      case VariableLengthListType(:final elementType):
        s.writeByte(0x70);
        _writeType(elementType, s);
      case FixedLengthListType(:final elementType, :final length):
        assert(length > 0);
        s.writeByte(0x67);
        _writeType(elementType, s);
        s.writeUnsigned(length);
      case TupleType(:final elements):
        assert(elements.isNotEmpty);
        s.writeByte(0x6f);
        s.writeUnsigned(elements.length);
        for (final element in elements) {
          _writeType(element, s);
        }
      case FlagsType(:final flagNames):
        assert(flagNames.isNotEmpty && flagNames.length <= 32);
        s.writeByte(0x6e);
        s.writeUnsigned(flagNames.length);
        for (final name in flagNames) {
          s.writeName(name);
        }
      case EnumType(:final enumNames):
        assert(enumNames.isNotEmpty);
        s.writeByte(0x6d);
        s.writeUnsigned(enumNames.length);
        for (final field in enumNames) {
          s.writeName(field);
        }
      case OptionType(:final inner):
        s.writeByte(0x6b);
        _writeType(inner, s);
      case ResultType(:final ok, :final error):
        s.writeByte(0x6a);
        _writeOptionalType(ok, s);
        _writeOptionalType(error, s);
      case OwnType(:final resource):
        s.writeByte(0x69);
        s.writeUnsigned(resource.index.index);
      case BorrowType(:final resource):
        s.writeByte(0x69);
        s.writeUnsigned(resource.index.index);
      case StreamType(:final element):
        s.writeByte(0x66);
        _writeOptionalType(element, s);
      case FutureType(:final element):
        s.writeByte(0x65);
        _writeOptionalType(element, s);
      case ResourceType(:final destructor, :final hasInt64Representation):
        s.writeByte(0x3f);
        _writeType(
          hasInt64Representation ? PrimitiveType.s64 : PrimitiveType.s64,
          s,
        );
        if (destructor != null) s.writeUnsigned(destructor.index);
      case FunctionType(:final async, :final parameters, :final result):
        s.writeByte(async ? 0x43 : 0x40);
        s.writeUnsigned(parameters.length);
        for (final param in parameters) {
          assert(param.type is ModelTypeReference);
          _writeLabelledType(s, param.label, param.type);
        }
        if (result != null) {
          assert(result is ModelTypeReference);
          s.writeByte(0x00);
          _writeType(result, s);
        } else {
          s
            ..writeByte(0x01)
            ..writeByte(0x00);
        }
      case InstanceType(:final types, :final functionExports):
        s.writeByte(0x42);

        // Type exports are written with other types, an (export ... (type eq))
        s.writeUnsigned(types.length + functionExports.length);
        for (final type in types) {
          if (type is InstanceTypeExport) {
            s.writeByte(0x04); // in instancedecl production, tag export

            s.writeByte(0x00);
            s.writeName(type.name);

            s.writeByte(0x03); // type bound
            s.writeByte(0x00);
            s.writeUnsigned(
              (type.resolvedType as ValueTypeReference).index.index,
            );
          } else {
            s.writeByte(0x01); // in instancedecl production, tag type
            _writeType(type, s);
          }
        }

        for (final export in functionExports) {
          s.writeByte(0x04); // in instancedecl production, tag export

          // exportname'. Not sure what's up with options?
          s.writeByte(0x00);
          s.writeName(export.name);

          s.writeByte(0x01); // type function

          // Function type guaranteed to match index of function because we use
          // aliases.
          s.writeUnsigned(export.function.index.index);
        }
    }
  }

  void _writeOptionalType(ModelType? type, w.Serializer s) {
    if (type != null) {
      s.writeByte(0x01);
      _writeType(type, s);
    } else {
      s.writeByte(0x00);
    }
  }

  void _writeLabelledType(w.Serializer s, String name, ModelType type) {
    s.writeName(name);
    _writeType(type, s);
  }
}

final class CanonSection extends w.Section {
  final List<CanonicalDefinition> definitions;

  CanonSection(this.definitions, [super.watchPoints = const []]);

  @override
  int get id => 8;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(definitions);
  }
}

final class ImportsSection extends w.Section {
  final List<(String, ModelTypeReference<InstanceType>)> imports;

  ImportsSection(this.imports, [super.watchPoints = const []]);

  @override
  int get id => 10;

  @override
  void serializeContents(w.Serializer s) {
    s.writeUnsigned(imports.length);
    for (final (name, importedInstanceType) in imports) {
      // importname'
      s.writeByte(0x00);
      s.writeName(name);

      s.writeByte(0x05); // in externdesc production, tag instance type
      s.writeUnsigned(importedInstanceType.index.index);
    }
  }
}

final class ExportsSection extends w.Section {
  final List<Export> exports;

  ExportsSection(this.exports, [super.watchPoints = const []]);

  @override
  int get id => 11;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(exports);
  }
}
