import 'dart:typed_data';

import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'binary.dart';
import 'core_module.dart';
import 'index_space.dart';
import 'linker.dart';
import 'type.dart';

/// Utilities to build a WebAssembly component.
///
/// Since we only generate components (and don't transform / inspect existing
/// ones), we can get away with only supporting the supset of the full component
/// model we really need.
///
/// In our case, components unconditionally have the following shape:
///
///  1. Define core modules (the Rust helper and the dart2wasm-compiled app).
///  2. Define all (component-level) types.
///  3. Import used component instances.
///  4. Create a `(core instance)` of the Rust helper.
///  5. Create `(alias export)` and `(canon lower)` definitions to turn builtins
///     and imported definitions into core modules.
///  6. Create a `(core instance)` exporting those imports.
///  7. Create a `(core instance)` of the dart2wasm app.
///  8. Create a `(instance)` with inlineexports.
///  9. Export that instance.
final class ComponentBuilder implements w.Serializable {
  final List<CoreModule> _modules = [];

  final List<ModelType> _types = [];
  final Map<ModelType, ModelTypeReference> _typesToIndex = {};

  final IndexSpaceCounters _counters = IndexSpaceCounters();

  /// Imported component instances (we don't support any other type of import
  /// currently).
  final List<(String, ModelTypeReference<InstanceType>)> _imports = [];

  late final LinkingBuilder linker = LinkingBuilder(this);

  CoreModule _defineCoreModule(CoreModule Function(ModuleIndex) create) {
    final index = ModuleIndex(_modules.length);
    final module = create(index);
    _modules.add(module);
    return module;
  }

  CoreModule defineModuleFromBytes(Uint8List bytes) {
    return _defineCoreModule((idx) => CoreModuleFromBytes(idx, bytes));
  }

  CoreModule defineModule(w.Module module) {
    return _defineCoreModule((idx) => CoreModuleParsed(idx, module));
  }

  ComponentInstanceIndex importInstance(
    String name,
    ModelTypeReference<InstanceType> type,
  ) {
    final idx = _counters.incrementComponentInstance();
    _imports.add((name, type));
    return idx;
  }

  ModelTypeReference<T> addType<T extends ModelType>(T type) {
    return _typesToIndex.putIfAbsent(type, () {
          final idx = _types.length;
          _types.add(type);
          return ModelTypeReference<T>(ComponentTypeIndex(idx), type);
        })
        as ModelTypeReference<T>;
  }

  @override
  void serialize(w.Serializer s) {
    s.writeBytes(_preamble);
    for (final module in _modules) {
      ModuleSection(module).serialize(s);
    }
    TypesSection(_types).serialize(s);
    ImportsSection(_imports).serialize(s);
    linker.serialize(s);
  }

  Uint8List serializeToBytes() {
    final serializer = w.Serializer();
    serialize(serializer);
    return serializer.data;
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

final class LinkingBuilder implements w.Serializable {
  final ComponentBuilder _component;
  final List<LinkingInstruction> _instructions = [];

  LinkingBuilder(this._component);

  I alias<I extends Index>(Sort<I> sort, AliasTarget target) {
    final index = _component._counters.increment(sort);
    _instructions.add(AliasDefinition(sort, index, target));
    return index;
  }

  CanonLower canonLower(ComponentFunctionIndex function) {
    final index = _component._counters.incrementCoreFunction();
    final def = CanonLower(function, index);
    _instructions.add(def);
    return def;
  }

  ModuleInstanceIndex coreInstantiate(CoreInstanceExpression expr) {
    final index = _component._counters.incrementCoreInstance();
    _instructions.add(expr);
    return index;
  }

  @override
  void serialize(w.Serializer s) {
    for (final section in _toSections()) {
      section.serialize(s);
    }
  }

  Iterable<w.Section> _toSections() sync* {
    w.Section? currentSection;

    for (final instruction in _instructions) {
      switch (instruction) {
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
      }
    }

    if (currentSection != null) yield currentSection;
  }
}

/**
TODO: Be able to generate something like this

(component
  (type $result (result))
  (type $exit-type (func (param "status" $result)))

  (type $ty-exit-instance (instance
      (export (;0;) "exit" (func (type $exit-type)))
  ))
  (import "wasi:cli/exit@0.2.12" (instance $exit-instance (type $ty-exit-instance)))

  (core module $C
    (func $exit (import "runtime" "exit") (param i32))
    (func (export "add") (result i32) (i32.const 1))
  )

  (alias export $exit-instance "exit" (func $exit))
  (canon lower (func $exit) (core func $exit))
  (core instance $host-imports
    (export "exit" (func $exit))
  )

  (core instance $c (instantiate $C (with "runtime" (instance $host-imports))))

  (type $main (func (result (result))))
  (component $exports
    (import "import-main" (func (type $main)))
    (export "run" (func 0) (func (type $main)))
  )

  (canon lift (core func $c "add") (func $run (type $main)))
  (instance $mainInstance (instantiate $exports
    (with "import-main" (func $run))
  ))
  (export "wasi:cli/run@0.2.12" (instance $mainInstance))
)
 */
