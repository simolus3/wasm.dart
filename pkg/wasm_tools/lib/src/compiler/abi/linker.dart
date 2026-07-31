import '../components/component.dart';
import '../components/index_space.dart';
import '../components/type.dart' as types;
import '../components/type.dart';
import 'abi.dart';

final class Linker {
  final ComponentBuilder component;
  final Map<AbiType, ComponentTypeIndex> _topLevelTypes = {};
  final Map<AbiInterface, ComponentTypeIndex> _interfaces = {};
  final Map<AbiInterface, ComponentInstanceIndex> _importedInstances = {};

  new(this.component);

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
          resolveImport: (import) {
            return types.ModelTypeReference(importFromOuter(import));
          },
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
  required types.ModelType Function(ImportedAbiType) resolveImport,
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
    return definitions.addType(switch (type) {
      SimpleAbiType(:final type) => type,
      EnumAbiType(:final cases) => types.EnumType(cases),
      ImportedAbiType() => resolveImport(type),
      StreamAbiType(:final element) => types.StreamType(innerType(element)),
      FutureAbiType(:final element) => types.FutureType(innerType(element)),
      ResultAbiType(:final ok, :final error) => types.ResultType(
        ok: ok != null ? innerType(ok) : null,
        error: error != null ? innerType(error) : null,
      ),
    });
  });
}
