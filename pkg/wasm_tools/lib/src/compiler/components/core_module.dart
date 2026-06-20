import 'dart:typed_data';

import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'index_space.dart';

/// A core WebAssembly module as part of a WebAssembly component.
sealed class CoreModule implements w.Serializable {
  /// The index of the core module in the component.
  final ModuleIndex index;

  CoreModule._(this.index);
}

final class CoreModuleFromBytes extends CoreModule {
  final Uint8List moduleBytes;

  CoreModuleFromBytes(super.index, this.moduleBytes) : super._();

  @override
  void serialize(w.Serializer s) {
    s.writeBytes(moduleBytes);
  }
}

final class CoreModuleParsed extends CoreModule {
  final w.Module module;

  CoreModuleParsed(super.index, this.module) : super._();

  @override
  void serialize(w.Serializer s) {
    module.serialize(s);
  }
}
