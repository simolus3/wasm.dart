import 'dart:typed_data';

import '../../third_party/wasm_builder/wasm_builder.dart' as w;

import 'binary.dart';
import 'index_space.dart';
import 'type.dart';

/// Utilities to build a WebAssembly component.
///
/// Since we only generate components (and don't transform / inspect existing
/// ones), we can get away with only supporting the supset of the full component
/// model we really need.
///
/// In our case, components are unconditionally created like this:
///
///  1. We include the core module for the transformed dart2wasm app and our
///     libc.
///  2. We create a `(core instance)` of libc.
///  3. We generate a type section with all types used in public imports/exports.
///  4. We import existing instances.
///  5. We extract functions from imported instances to component functions via
///     `(alias export $imported-instance "export" (func $...))`.
///  6. We lower these imported functions to core functions with
///     `(canon lower)`.
///  7. We define a `(core instance)` exporting imported functions as core
///     functions with the correct name.
///  8. We create a `(core instance)` of the dart2wasm module.
///  9. We lift exported functions from dart2wasm into module functions.
/// 10. We create an instance exporting all these functions.
/// 11. We export that instance.
final class ComponentBuilder implements w.Serializable {
  final List<ModelType> _types = [];
  final Map<ModelType, ModelTypeReference> _typesToIndex = {};

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
    TypesSection(_types).serialize(s);
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
