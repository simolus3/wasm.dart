import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'core_module.dart';
import 'index_space.dart';

sealed class LinkingInstruction extends w.Serializable {}

final class AliasDefinition<I extends Index> extends LinkingInstruction {
  final Sort<I> sort;

  /// The index used to refer to the aliased definition.
  final I index;

  final AliasTarget target;

  AliasDefinition(this.sort, this.index, this.target);

  @override
  void serialize(w.Serializer s) {
    switch (sort) {
      case .coreFunction:
        s.writeByte(0x00);
        s.writeByte(0x00);
      case .coreMemory:
        s.writeByte(0x00);
        s.writeByte(0x02);
      case .componentFunction:
        s.writeByte(0x01);
      case .componentInstance:
        s.writeByte(0x05);
    }

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

/// https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md#canonical-definitions
sealed class CanonicalDefinition extends LinkingInstruction {}

abstract final class _CanonicalLiftOrLower extends CanonicalDefinition {
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

/// Create a core WebAssembly function from a component function by applying the
/// ABI.
final class CanonLower extends _CanonicalLiftOrLower {
  final ComponentFunctionIndex function;
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

enum StringEncoding { utf8, utf16, latin1OrUtf16 }

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
