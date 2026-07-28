import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'binary.dart';
import 'core_module.dart';
import 'index_space.dart';
import 'definition.dart';
import 'type.dart';
import 'type_container.dart';

mixin HasDefinitions {
  final List<ComponentDefinition> _definitions = [];
  final IndexSpaceCounters _counters = IndexSpaceCounters();

  List<ComponentDefinition> get definitions =>
      UnmodifiableListView(_definitions);

  @protected
  IndexSpaceCounters get counters => _counters;

  @protected
  void addDefinition(ComponentDefinition def) => _definitions.add(def);
}

/// Utilities to build a WebAssembly component.
///
/// Since we only generate components (and don't transform / inspect existing
/// ones), we can get away with only supporting the supset of the full component
/// model we really need.
final class ComponentBuilder with HasDefinitions implements w.Serializable {
  // TODO: Migrate this to definitions
  late final TypesContainer types = TypesContainer();

  /// Imported component instances (we don't support any other type of import
  /// currently).
  final List<(String, ComponentTypeIndex)> _imports = [];

  CoreModule _defineCoreModule(CoreModule Function(CoreModuleIndex) create) {
    final index = _counters.incrementCoreModule();
    final module = create(index);
    addDefinition(CoreModuleDefinition(module));
    return module;
  }

  CoreModule defineModuleFromBytes(Uint8List bytes) {
    return _defineCoreModule((idx) => CoreModuleFromBytes(idx, bytes));
  }

  CoreModule defineModule(w.Module module) {
    return _defineCoreModule((idx) => CoreModuleParsed(idx, module));
  }

  ComponentInstanceIndex importInstance(String name, ComponentTypeIndex type) {
    final idx = _counters.incrementComponentInstance();
    _imports.add((name, type));
    return idx;
  }

  CanonLower canonLower(ComponentFunctionIndex function) {
    final index = _counters.incrementCoreFunction();
    final def = CanonLower(function, index);
    _definitions.add(def);
    return def;
  }

  CanonLift canonLift(CoreFunctionIndex function, ComponentTypeIndex type) {
    final index = _counters.incrementComponentFunction();
    final def = CanonLift(function, type, index);
    _definitions.add(def);
    return def;
  }

  T addCanonPrimitive<T extends CanonPrimitive>(
    T Function(CoreFunctionIndex index) create,
  ) {
    final index = _counters.incrementCoreFunction();
    final def = create(index);
    _definitions.add(def);
    return def;
  }

  CanonContextGet canonContextGet(int i) {
    return addCanonPrimitive((index) => CanonContextGet(index, i));
  }

  CanonContextSet canonContextSet(int i) {
    return addCanonPrimitive((index) => CanonContextSet(index, i));
  }

  CoreInstanceIndex coreInstantiate(CoreInstanceExpression expr) {
    final index = _counters.incrementCoreInstance();
    _definitions.add(expr);
    return index;
  }

  ComponentInstanceIndex instance({
    required List<(String, Sort, Index)> inlineExports,
  }) {
    final index = _counters.incrementComponentInstance();
    _definitions.add(InstanceFromInlineExports(inlineExports));
    return index;
  }

  void export(Export export) {
    _definitions.add(export);
  }

  @override
  void serialize(w.Serializer s) {
    s.writeBytes(_preamble);

    for (final section in _toSections()) {
      section.serialize(s);
    }

    //    TypesSection(_types).serialize(s);
    //ImportsSection(_imports).serialize(s);
  }

  Uint8List serializeToBytes() {
    final serializer = w.Serializer();
    serialize(serializer);
    return serializer.data;
  }

  Iterable<w.Section> _toSections() sync* {
    w.Section? currentSection;

    for (final instruction in _definitions) {
      switch (instruction) {
        case TypeDefinition():
          if (currentSection is TypesSection) {
            currentSection.types.add(instruction);
          } else {
            if (currentSection != null) yield currentSection;
            currentSection = TypesSection([instruction]);
          }
        case AliasDefinition():
          if (currentSection is AliasSection) {
            currentSection.aliases.add(instruction);
          } else {
            if (currentSection != null) yield currentSection;
            currentSection = AliasSection([instruction]);
          }
        case CanonicalDefinition():
          if (currentSection is CanonSection) {
            currentSection.definitions.add(instruction);
          } else {
            if (currentSection != null) yield currentSection;
            currentSection = CanonSection([instruction]);
          }
        case CoreInstanceExpression():
          if (currentSection is CoreInstanceSection) {
            currentSection.instances.add(instruction);
          } else {
            if (currentSection != null) yield currentSection;
            currentSection = CoreInstanceSection([instruction]);
          }
        case InstanceFromInlineExports():
          if (currentSection is InstanceSection) {
            currentSection.instances.add(instruction);
          } else {
            if (currentSection != null) yield currentSection;
            currentSection = InstanceSection([instruction]);
          }
        case Export():
          if (currentSection is ExportsSection) {
            currentSection.exports.add(instruction);
          } else {
            if (currentSection != null) yield currentSection;
            currentSection = ExportsSection([instruction]);
          }
        case CoreModuleDefinition(:final module):
          if (currentSection != null) yield currentSection;
          currentSection = null;
          yield ModuleSection(module);

        case ExportDecl():
          throw StateError('Components cannot have ExportDecl definitions');
      }
    }

    if (currentSection != null) yield currentSection;
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

extension AddDefinitions on HasDefinitions {
  I alias<I extends Index>(Sort<I> sort, AliasTarget target) {
    final index = _counters.increment(sort);
    _definitions.add(AliasDefinition(sort, index, target));
    return index;
  }

  ComponentTypeIndex addType(ModelType type) {
    final index = _counters.incrementComponentType();
    _definitions.add(TypeDefinition(type, index));
    return index;
  }
}
