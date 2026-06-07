import '../../third_party/wasm_builder/wasm_builder.dart' as w;
import 'component.dart';

final class ModuleSection extends w.Section {
  final ComponentCoreModule module;

  ModuleSection(this.module, [super.watchPoints = const []]);

  @override
  int get id => 1;

  @override
  void serializeContents(w.Serializer s) {
    module.serializeModule(s);
  }
}

final class CoreInstanceSection extends w.Section {
  final List<CoreInstantiation> instantiations;

  CoreInstanceSection(this.instantiations, [super.watchPoints = const []]);

  @override
  int get id => 2;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(instantiations);
  }
}
