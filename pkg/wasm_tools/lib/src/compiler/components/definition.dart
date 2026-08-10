import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'core_module.dart';
import 'index_space.dart';
import 'type.dart';

sealed class ComponentDefinition extends w.Serializable {}

final class AliasDefinition<I extends Index> extends ComponentDefinition {
  final Sort<I> sort;

  /// The index used to refer to the aliased definition.
  final I index;

  final AliasTarget target;

  AliasDefinition(this.sort, this.index, this.target);

  @override
  void serialize(w.Serializer s) {
    sort.serializeAsSort(s);
    target.serialize(s);
  }
}

sealed class AliasTarget extends w.Serializable {
  AliasTarget();

  factory AliasTarget.instanceExport(
    ComponentInstanceIndex instance,
    String name,
  ) = ExportAliasTarget;

  factory AliasTarget.coreInstanceExport(
    CoreInstanceIndex instance,
    String name,
  ) = CoreExportTarget;

  factory AliasTarget.outer(int context, Index index) = OuterTarget;
}

final class ExportAliasTarget extends AliasTarget {
  final ComponentInstanceIndex instance;
  final String name;

  ExportAliasTarget(this.instance, this.name);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x00);
    s.writeUnsigned(instance.index);
    s.writeName(name);
  }
}

final class CoreExportTarget extends AliasTarget {
  final CoreInstanceIndex module;
  final String name;

  CoreExportTarget(this.module, this.name);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x01);
    s.writeUnsigned(module.index);
    s.writeName(name);
  }
}

final class OuterTarget extends AliasTarget {
  final int context;
  final Index index;

  new(this.context, this.index);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x02);
    s.writeUnsigned(context);
    s.writeUnsigned(index.index);
  }
}

enum StringEncoding { utf8, utf16, latin1OrUtf16 }

/// https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md#canonical-definitions
sealed class CanonicalDefinition extends ComponentDefinition {}

mixin CanonicalHasOptions {
  StringEncoding? stringEncoding;
  CoreMemoryIndex? memory;
  CoreFunctionIndex? realloc;
  CoreFunctionIndex? postReturn;
  bool async = false;
  CoreFunctionIndex? callback;

  void _serializeOptions(w.Serializer s) {
    var numOptions = 0;
    if (stringEncoding != null) numOptions++;
    if (memory != null) numOptions++;
    if (realloc != null) numOptions++;
    if (postReturn != null) numOptions++;
    if (async) numOptions++;
    if (callback != null) numOptions++;

    s.writeUnsigned(numOptions);
    if (stringEncoding case final encoding?) {
      s.writeByte(switch (encoding) {
        StringEncoding.utf8 => 0x00,
        StringEncoding.utf16 => 0x01,
        StringEncoding.latin1OrUtf16 => 0x02,
      });
    }
    if (memory case final memory?) {
      s.writeByte(0x03);
      s.writeUnsigned(memory.index);
    }
    if (realloc case final realloc?) {
      s.writeByte(0x04);
      s.writeUnsigned(realloc.index);
    }
    if (postReturn case final postReturn?) {
      s.writeByte(0x05);
      s.writeUnsigned(postReturn.index);
    }
    if (async) s.writeByte(0x06);
    if (callback case final callback?) {
      s.writeByte(0x07);
      s.writeUnsigned(callback.index);
    }
  }
}

abstract final class CanonicalLiftOrLower extends CanonicalDefinition
    with CanonicalHasOptions {}

abstract interface class CanonDefinitionCreatingCoreFunction {
  abstract final CoreFunctionIndex createdCoreFunction;
}

/// Create a core WebAssembly function from a component function by applying the
/// ABI.
final class CanonLower extends CanonicalLiftOrLower
    implements CanonDefinitionCreatingCoreFunction {
  final ComponentFunctionIndex function;
  @override
  final CoreFunctionIndex createdCoreFunction;

  CanonLower(this.function, this.createdCoreFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x01);
    s.writeByte(0x00);
    s.writeUnsigned(function.index);
    _serializeOptions(s);
  }
}

/// Create a component function from a core WebAssembly function by enriching it
/// with an ABI function type.
final class CanonLift extends CanonicalLiftOrLower {
  final CoreFunctionIndex function;
  final ComponentTypeIndex type;
  final ComponentFunctionIndex createdFunction;

  CanonLift(this.function, this.type, this.createdFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x00);
    s.writeByte(0x00);
    s.writeUnsigned(function.index);
    _serializeOptions(s);
    s.writeUnsigned(type.index);
  }
}

sealed class CanonPrimitive extends CanonicalDefinition
    implements CanonDefinitionCreatingCoreFunction {
  @override
  final CoreFunctionIndex createdCoreFunction;

  new(this.createdCoreFunction);
}

final class ResourceDrop extends CanonPrimitive {
  final ModelTypeReference resourceType;

  new(super.createdCoreFunction, this.resourceType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x03);
    s.writeUnsigned(resourceType.index.index);
  }
}

final class TaskReturn extends CanonPrimitive with CanonicalHasOptions {
  final ModelTypeReference? returnType;

  new(super.createdCoreFunction, this.returnType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x09);
    if (returnType case final returnType?) {
      s.writeByte(0x00);
      s.writeUnsigned(returnType.index.index);
    } else {
      s.writeByte(0x01);
      s.writeByte(0x00);
    }

    _serializeOptions(s);
  }
}

final class CanonContextGet extends CanonPrimitive {
  final int i;

  CanonContextGet(super.createdCoreFunction, this.i);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x0a);
    s.writeByte(0x7f); // core:i32
    s.writeUnsigned(i);
  }
}

final class StreamNew extends CanonPrimitive {
  final ModelTypeReference streamType;

  new(super.createdCoreFunction, this.streamType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x0e);
    s.writeUnsigned(streamType.index.index);
  }
}

final class StreamRead extends CanonPrimitive with CanonicalHasOptions {
  final ModelTypeReference streamType;

  new(super.createdCoreFunction, this.streamType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x0f);
    s.writeUnsigned(streamType.index.index);
    _serializeOptions(s);
  }
}

final class StreamWrite extends CanonPrimitive with CanonicalHasOptions {
  final ModelTypeReference streamType;

  new(super.createdCoreFunction, this.streamType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x10);
    s.writeUnsigned(streamType.index.index);
    _serializeOptions(s);
  }
}

final class StreamDropReadable extends CanonPrimitive {
  final ModelTypeReference streamType;

  new(super.createdCoreFunction, this.streamType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x13);
    s.writeUnsigned(streamType.index.index);
  }
}

final class StreamDropWritable extends CanonPrimitive {
  final ModelTypeReference streamType;

  new(super.createdCoreFunction, this.streamType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x14);
    s.writeUnsigned(streamType.index.index);
  }
}

final class FutureNew extends CanonPrimitive {
  final ModelTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x15);
    s.writeUnsigned(futureType.index.index);
  }
}

final class FutureRead extends CanonPrimitive with CanonicalHasOptions {
  final ModelTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x16);
    s.writeUnsigned(futureType.index.index);
    _serializeOptions(s);
  }
}

final class FutureWrite extends CanonPrimitive with CanonicalHasOptions {
  final ModelTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x17);
    s.writeUnsigned(futureType.index.index);
    _serializeOptions(s);
  }
}

final class FutureDropReadable extends CanonPrimitive {
  final ModelTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x1a);
    s.writeUnsigned(futureType.index.index);
  }
}

final class FutureDropWritable extends CanonPrimitive {
  final ModelTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x1b);
    s.writeUnsigned(futureType.index.index);
  }
}

final class CanonContextSet extends CanonPrimitive {
  final int i;

  CanonContextSet(super.createdCoreFunction, this.i);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x0b);
    s.writeByte(0x7f); // core:i32
    s.writeUnsigned(i);
  }
}

final class CanonSubtaskCancel extends CanonPrimitive {
  final bool async;

  CanonSubtaskCancel(super.createdCoreFunction, {required this.async});

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x06);
    s.writeByte(async ? 0x01 : 0x00);
  }
}

final class CanonSubtaskDrop extends CanonPrimitive {
  CanonSubtaskDrop(super.createdCoreFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x0d);
  }
}

final class WaitableSetNew extends CanonPrimitive {
  new(super.createdCoreFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x1f);
  }
}

final class WaitableSetDrop extends CanonPrimitive {
  new(super.createdCoreFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x22);
  }
}

final class WaitableJoin extends CanonPrimitive {
  new(super.createdCoreFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x23);
  }
}

abstract final class CoreInstanceExpression extends ComponentDefinition {
  CoreInstanceExpression._();

  factory CoreInstanceExpression.moduleAndArgs(
    CoreModule module,
    Map<String, CoreInstanceIndex> args,
  ) = _InstantiateCoreModule;

  factory CoreInstanceExpression.inlineExports(
    List<(String, Sort, Index)> exports,
  ) = _InstantiateFromInlineExports;
}

final class _InstantiateCoreModule extends CoreInstanceExpression {
  final CoreModule module;
  final Map<String, CoreInstanceIndex> args;

  _InstantiateCoreModule(this.module, this.args) : super._();

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x00);
    s.writeUnsigned(module.index.index);
    s.writeUnsigned(args.length);
    for (final MapEntry(key: name, value: module) in args.entries) {
      s.writeName(name);
      s.writeByte(0x12);
      s.writeUnsigned(module.index);
    }
  }
}

final class _InstantiateFromInlineExports extends CoreInstanceExpression {
  final List<(String, Sort, Index)> exports;

  _InstantiateFromInlineExports(this.exports) : super._();

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x01);
    s.writeUnsigned(exports.length);
    for (final (name, sort, index) in exports) {
      s.writeName(name);
      s.writeByte(switch (sort) {
        .coreFunction => 0x00,
        .coreMemory => 0x02,
        .componentFunction || .componentInstance => throw ArgumentError(
          'Unsupported sort for core instance: $sort',
        ),
      });
      s.writeUnsigned(index.index);
    }
  }
}

final class InstanceFromInlineExports extends ComponentDefinition {
  final List<(String, Sort, Index)> exports;

  InstanceFromInlineExports(this.exports);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x01);
    s.writeUnsigned(exports.length);
    for (final (name, sort, index) in exports) {
      s.writeByte(0x00);
      s.writeName(name);

      sort.serializeAsSort(s);
      s.writeUnsigned(index.index);
    }
  }
}

final class Export extends ComponentDefinition {
  final String name;
  final Sort sort;
  final Index exported;

  Export(this.name, this.sort, this.exported);

  @override
  void serialize(w.Serializer s) {
    // :<nameattributes> si:<sortidx> et?:<externtype>?
    s.writeByte(0x00);
    s.writeName(name);
    sort.serializeAsSort(s);
    s.writeUnsigned(exported.index);
    s.writeByte(0x00); // No externdesc
  }
}

/// A component-level import.
///
/// We currently only support importing instances.
final class Import extends ComponentDefinition {
  final String name;
  final ComponentTypeIndex instanceType;

  new(this.name, this.instanceType);

  @override
  void serialize(w.Serializer s) {
    // importname'
    s.writeByte(0x00);
    s.writeName(name);

    s.writeByte(0x05); // in externdesc production, tag instance type
    s.writeUnsigned(instanceType.index);
  }
}

sealed class ExportDecl extends ComponentDefinition {
  final String name;

  new(this.name);

  void _serializeName(w.Serializer s) {
    s.writeByte(0x00);
    s.writeName(name);
  }
}

/// An `(export 'name' (func (type i)))` export in an instance type.
final class ExportDeclFunction extends ExportDecl {
  final ComponentTypeIndex functionType;

  new(super.name, this.functionType);

  @override
  void serialize(w.Serializer s) {
    _serializeName(s);
    s.writeByte(0x01);
    s.writeUnsigned(functionType.index);
  }
}

/// An `(export 'name' (type (eq i)))` export in an instance type.
final class ExportDeclTypeEq extends ExportDecl {
  final ComponentTypeIndex type;

  new(super.name, this.type);

  @override
  void serialize(w.Serializer s) {
    _serializeName(s);
    s.writeByte(0x03);
    s.writeByte(0x00);
    s.writeUnsigned(type.index);
  }
}

/// An `(export 'name' (type (sub resource)))` export in an instance type.
final class ExportDeclTypeSubResource extends ExportDecl {
  new(super.name);

  @override
  void serialize(w.Serializer s) {
    _serializeName(s);
    s.writeByte(0x03);
    s.writeByte(0x01);
  }
}

final class TypeDefinition extends ComponentDefinition {
  final ModelType type;
  final ComponentTypeIndex index;

  new(this.type, this.index);

  @override
  void serialize(w.Serializer s) {
    _writeType(type, s);
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
        s.writeUnsigned(resource.index);
      case BorrowType(:final resource):
        s.writeByte(0x69);
        s.writeUnsigned(resource.index);
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
      case InstanceType(:final definitions):
        s.writeByte(0x42);
        s.writeUnsigned(definitions.length);
        for (final def in definitions) {
          switch (def) {
            case TypeDefinition():
              s.writeByte(0x01);
              assert(def.type is! ModelTypeReference);
              def.serialize(s);
            case AliasDefinition():
              s.writeByte(0x02);
              def.serialize(s);
              break;
            case ExportDecl():
              s.writeByte(0x04);
              def.serialize(s);
            default:
              throw ArgumentError('Illegal definition in instance type: $def');
          }
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

final class CoreModuleDefinition extends ComponentDefinition {
  final CoreModule module;

  new(this.module);

  @override
  void serialize(w.Serializer s) {
    module.serialize(s);
  }
}
