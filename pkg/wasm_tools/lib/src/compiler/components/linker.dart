import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'core_module.dart';
import 'index_space.dart';
import 'type.dart';

sealed class LinkingInstruction extends w.Serializable {}

final class AliasDefinition<I extends Index> extends LinkingInstruction {
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
    ModuleInstanceIndex instance,
    String name,
  ) = CoreExportTarget;
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
  final ModuleInstanceIndex module;
  final String name;

  CoreExportTarget(this.module, this.name);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x01);
    s.writeUnsigned(module.index);
    s.writeName(name);
  }
}

enum StringEncoding { utf8, utf16, latin1OrUtf16 }

/// https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md#canonical-definitions
sealed class CanonicalDefinition extends LinkingInstruction {}

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
  final ModelTypeReference<FunctionType> type;
  final ComponentFunctionIndex createdFunction;

  CanonLift(this.function, this.type, this.createdFunction);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x00);
    s.writeByte(0x00);
    s.writeUnsigned(function.index);
    _serializeOptions(s);
    s.writeUnsigned(type.index.index);
  }
}

sealed class CanonPrimitive extends CanonicalDefinition
    implements CanonDefinitionCreatingCoreFunction {
  @override
  final CoreFunctionIndex createdCoreFunction;

  new(this.createdCoreFunction);
}

final class TaskReturn extends CanonPrimitive with CanonicalHasOptions {
  final ValueTypeReference? returnType;

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

final class FutureNew extends CanonPrimitive {
  final ValueTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x15);
    s.writeUnsigned(futureType.index.index);
  }
}

final class FutureRead extends CanonPrimitive with CanonicalHasOptions {
  final ValueTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x16);
    s.writeUnsigned(futureType.index.index);
    _serializeOptions(s);
  }
}

final class FutureWrite extends CanonPrimitive with CanonicalHasOptions {
  final ValueTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x17);
    s.writeUnsigned(futureType.index.index);
    _serializeOptions(s);
  }
}

final class FutureDropReadable extends CanonPrimitive {
  final ValueTypeReference futureType;

  new(super.createdCoreFunction, this.futureType);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x1a);
    s.writeUnsigned(futureType.index.index);
  }
}

final class FutureDropWritable extends CanonPrimitive {
  final ValueTypeReference futureType;

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

abstract final class CoreInstanceExpression extends LinkingInstruction {
  CoreInstanceExpression._();

  factory CoreInstanceExpression.moduleAndArgs(
    CoreModule module,
    Map<String, ModuleInstanceIndex> args,
  ) = _InstantiateCoreModule;

  factory CoreInstanceExpression.inlineExports(
    List<(String, Sort, Index)> exports,
  ) = _InstantiateFromInlineExports;
}

final class _InstantiateCoreModule extends CoreInstanceExpression {
  final CoreModule module;
  final Map<String, ModuleInstanceIndex> args;

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

final class InstanceFromInlineExports extends LinkingInstruction {
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

final class Export extends LinkingInstruction {
  final String name;
  final Sort sort;
  final Index exported;

  Export(this.name, this.sort, this.exported);

  @override
  void serialize(w.Serializer s) {
    s.writeByte(0x00);
    s.writeName(name);
    sort.serializeAsSort(s);
    s.writeUnsigned(exported.index);
    s.writeByte(0x00); // No externdesc
  }
}
