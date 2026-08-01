import 'package:logging/logging.dart';

import '../components/component.dart';
import '../components/index_space.dart';
import '../components/type.dart' as types;
import '../components/type.dart';
import 'interface.dart';

final class Linker {
  final Logger logger;
  final ComponentBuilder component;
  final CoreInstanceIndex? libc;

  final Map<AbiType, ComponentTypeIndex> _topLevelTypes = {};
  final Map<AbiInterface, ComponentTypeIndex> _interfaces = {};
  final Map<AbiInterface, ComponentInstanceIndex> _importedInstances = {};
  CoreMemoryIndex? _libcMemory;
  CoreFunctionIndex? _libcRealloc;

  CoreInstanceIndex? _program;
  final Map<String, CoreFunctionIndex> _programExports = {};

  new(this.component, {this.libc, Logger? logger})
    : logger = .detached('Linker');

  set program(CoreInstanceIndex value) {
    _program = value;
  }

  CoreMemoryIndex get libcMemory {
    if (_libcMemory case final memory?) return memory;

    return _libcMemory = component.alias(
      .coreMemory,
      .coreInstanceExport(_requireLibc(), 'memory'),
    );
  }

  CoreFunctionIndex get libcRealloc {
    if (_libcRealloc case final realloc?) return realloc;

    return _libcRealloc = component.alias(
      .coreFunction,
      .coreInstanceExport(_requireLibc(), 'dart_realloc'),
    );
  }

  CoreInstanceIndex _requireLibc() => ArgumentError.checkNotNull(libc, 'libc');

  CoreInstanceIndex _requireProgram() {
    if (_program case final program?) return program;

    throw StateError('Cannot use instantiated program, not instantiated yet.');
  }

  CoreFunctionIndex programExport(String name) {
    return _programExports.putIfAbsent(name, () {
      final program = _requireProgram();
      return component.alias(.coreFunction, .coreInstanceExport(program, name));
    });
  }

  ComponentInstanceIndex importInstance(AbiInterface interface) {
    return _importedInstances.putIfAbsent(interface, () {
      final type = interfaceType(interface);
      return component.importInstance(interface.fullName, type);
    });
  }

  ComponentTypeIndex importType(ImportedAbiType import) {
    final instance = importInstance(import.definingInterface);
    return component.alias(
      .componentType,
      .instanceExport(instance, import.name),
    );
  }

  ModelTypeReference mapType(AbiType type) {
    return ModelTypeReference(
      _addType(
        definitions: component,
        existing: _topLevelTypes,
        type: type,
        resolveImport: (type) => importType(type),
      ),
    );
  }

  ComponentTypeIndex interfaceType(AbiInterface interface) {
    return _interfaces.putIfAbsent(interface, () {
      final typeEntries = <AbiType, ComponentTypeIndex>{};
      final mapped = types.InstanceType();

      ComponentTypeIndex importFromOuter(ImportedAbiType import) {
        // We can't import types in an interface type, but we can import it
        // into the outer component and then use a alias.
        final outer = importType(import);
        return mapped.alias(.componentType, .outer(1, outer));
      }

      ComponentTypeIndex addType(AbiType type) {
        return _addType(
          definitions: mapped,
          existing: typeEntries,
          type: type,
          resolveImport: (import) => importFromOuter(import),
        );
      }

      interface.exportedTypes.forEach((name, type) {
        final existing = type is ImportedAbiType
            ? importFromOuter(type)
            : addType(type);

        final exported = mapped.exportTypeEq(name, existing);
        typeEntries[type] = exported;
      });

      interface.exportedFunctions.forEach((name, function) {
        mapped.exportFunction(
          name,
          mapped.addType(
            types.FunctionType(
              async: function.async,
              parameters: [
                for (final (name, paramType) in function.parameters)
                  .new(
                    label: name,
                    type: ModelTypeReference(addType(paramType)),
                  ),
              ],
              result: switch (function.result) {
                null => null,
                final type => ModelTypeReference(addType(type)),
              },
            ),
          ),
        );
      });

      return component.addType(mapped);
    });
  }
}

ComponentTypeIndex _addType({
  required HasDefinitions definitions,
  required Map<AbiType, ComponentTypeIndex> existing,
  required AbiType type,
  required ComponentTypeIndex Function(ImportedAbiType) resolveImport,
}) {
  types.ModelTypeReference innerType(AbiType inner) {
    return types.ModelTypeReference(
      _addType(
        definitions: definitions,
        existing: existing,
        type: inner,
        resolveImport: resolveImport,
      ),
    );
  }

  return existing.putIfAbsent(type, () {
    if (type is ImportedAbiType) {
      return resolveImport(type);
    }

    return definitions.addType(switch (type) {
      SimpleAbiType(:final type) => type,
      EnumAbiType(:final cases) => types.EnumType(cases),
      StreamAbiType(:final element) => types.StreamType(
        element != null ? innerType(element) : null,
      ),
      FutureAbiType(:final element) => types.FutureType(
        element != null ? innerType(element) : null,
      ),
      ResultAbiType(:final ok, :final error) => types.ResultType(
        ok: ok != null ? innerType(ok) : null,
        error: error != null ? innerType(error) : null,
      ),
      OptionAbiType(:final element) => types.OptionType(innerType(element)),
      RecordAbiType(:final fields) => types.RecordType([
        for (final (name, type) in fields)
          .new(label: name, type: innerType(type)),
      ]),
      VariableLengthListAbiType(:final element) => types.VariableLengthListType(
        elementType: innerType(element),
      ),
      ImportedAbiType() => throw AssertionError('handled above'),
    });
  });
}
