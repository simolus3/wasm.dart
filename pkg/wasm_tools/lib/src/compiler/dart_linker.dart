import 'program_abi.dart';

import 'components/component.dart';
import 'components/index_space.dart';
import 'components/definition.dart';

final class DartLinker {
  final DartProgramAbi abi;
  final CoreInstanceIndex libc;
  final ComponentBuilder builder;

  late CoreMemoryIndex _libcMemory;
  late CoreFunctionIndex _libcRealloc;

  DartLinker(this.builder, this.abi, this.libc) {
    _libcMemory = builder.alias(
      .coreMemory,
      .coreInstanceExport(libc, 'memory'),
    );

    _libcRealloc = builder.alias(
      .coreFunction,
      .coreInstanceExport(libc, 'dart_realloc'),
    );
  }

  CoreInstanceIndex createImportInstance() {
    // Note: Build all imports first, then all aliases, then all lowerings. This
    // means we can use 3 sections in total instead of 3 sections per function
    // import.
    final importedInstances = abi.interfaces
        .where((e) => e.importedFunctions.isNotEmpty)
        .toList();
    final instances = [
      for (final import in importedInstances)
        builder.importInstance(
          import.fullName,
          builder.types.addInstanceType(import.type).index,
        ),
    ];

    final functionAliases = [
      for (final (i, instance) in importedInstances.indexed)
        for (final function in instance.importedFunctions)
          builder.alias(
            .componentFunction,
            .instanceExport(instances[i], function.interfaceMethod),
          ),
    ];

    final lowered =
        <
          ImportedInstanceFunctionOrCanon,
          CanonDefinitionCreatingCoreFunction
        >{};
    var i = 0;
    for (final instance in importedInstances) {
      for (final function in instance.importedFunctions) {
        final lower = lowered[function] = builder.canonLower(
          functionAliases[i++],
        );
        applyOptions(function.options, lower);
      }
    }

    for (final primitive
        in abi.functionImports.values.whereType<ImportedCanonPrimitive>()) {
      lowered[primitive] = primitive.resolve(this);
    }

    final inlineExports = <(String, Sort, Index)>[];
    for (final MapEntry(:key, :value) in abi.functionImports.entries) {
      inlineExports.add((
        key,
        .coreFunction,
        lowered[value]!.createdCoreFunction,
      ));
    }

    return builder.coreInstantiate(.inlineExports(inlineExports));
  }

  void applyOptions(FunctionOptions options, CanonicalHasOptions canon) {
    if (options.usesMemory) {
      canon.memory = _libcMemory;
    }
    if (options.needsRealloc) canon.realloc = _libcRealloc;
    if (options.usesStrings) canon.stringEncoding = .utf16;
    if (options.async) canon.async = true;
  }
}
