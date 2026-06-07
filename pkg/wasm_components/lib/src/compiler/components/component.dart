import 'dart:typed_data';

import '../../third_party/wasm_builder/wasm_builder.dart' as w;
import 'binary.dart';

final class WasmComponent implements w.Serializable {
  final List<ComponentCoreModule> modules = [];
  final List<CoreInstantiation> coreInstances = [];

  Uint8List serializeToBytes() {
    final serializer = w.Serializer();
    serialize(serializer);
    return serializer.data;
  }

  @override
  void serialize(w.Serializer s) {
    s.writeBytes(_preamble);

    for (final (i, module) in modules.indexed) {
      ModuleSection(module).serialize(s);
      module.id.finalize(i);
    }

    if (coreInstances.isNotEmpty) {
      CoreInstanceSection(coreInstances).serialize(s);
    }
  }

  static final _preamble = Uint8List.fromList([
    0x00,
    0x61,
    0x73,
    0x6d,
    0x0d,
    0x00,
    0x01,
    0x00,
  ]);
}

sealed class ComponentCoreModule {
  final w.FinalizableIndex id = w.FinalizableIndex();

  void serializeModule(w.Serializer serializer);
}

final class ParsedCoreModule extends ComponentCoreModule {
  final w.Module coreModule;

  ParsedCoreModule(this.coreModule);

  @override
  void serializeModule(w.Serializer serializer) {
    coreModule.serialize(serializer);
  }
}

/// A `(core module)` section backed by an unparsed WebAssembly module.
final class RawCoreModule extends ComponentCoreModule {
  final Uint8List coreModuleBytes;

  RawCoreModule(this.coreModuleBytes);

  @override
  void serializeModule(w.Serializer serializer) {
    serializer.writeBytes(coreModuleBytes);
  }
}

/// An instantiation of a [ComponentCoreModule].
final class CoreInstantiation implements w.Serializable {
  final w.FinalizableIndex id = w.FinalizableIndex();

  final ComponentCoreModule module;

  /// Existing instances to use as instantiations.
  final List<({String name, CoreInstantiation instance})> withInstances;

  CoreInstantiation({required this.module, required this.withInstances});

  @override
  void serialize(w.Serializer s) {
    // https://github.com/WebAssembly/component-model/blob/main/design/mvp/Binary.md#instance-definitions
    s.writeByte(0x00); // We don't support inline exports.
    s.writeUnsigned(module.id.value);

    s.writeUnsigned(withInstances.length);
    for (final (:name, :instance) in withInstances) {
      s.writeName(name);
      s.writeByte(0x12);
      s.writeUnsigned(instance.id.value);
    }
  }
}
