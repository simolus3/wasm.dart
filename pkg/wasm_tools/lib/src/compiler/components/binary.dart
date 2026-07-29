import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'core_module.dart';
import 'definition.dart';

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
  final List<TypeDefinition> types;

  TypesSection(this.types, [super.watchPoints = const []]);

  @override
  int get id => 7;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(types);
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
  final List<Import> imports;

  ImportsSection(this.imports, [super.watchPoints = const []]);

  @override
  int get id => 10;

  @override
  void serializeContents(w.Serializer s) {
    s.writeList(imports);
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
