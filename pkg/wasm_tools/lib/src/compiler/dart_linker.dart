import 'program_abi.dart';

import 'components/component.dart';
import 'components/index_space.dart';
import 'components/linker.dart';

final class DartLinker {
  final DartProgramAbi abi;
  final ModuleInstanceIndex libc;
  final ComponentBuilder builder;

  CoreMemoryIndex? _libcMemory;
  CoreFunctionIndex? _libcRealloc;

  DartLinker(this.builder, this.abi, this.libc) {
    var needsMemory = false;
    var needsRealloc = false;

    for (final import
        in abi.functionImports.values.whereType<ImportedInstanceFunction>()) {
      if (import.options.usesMemory) {
        needsMemory = true;
      }
      if (import.options.needsRealloc) {
        needsRealloc = true;
      }
    }

    for (final export in abi.functionExports.values) {
      if (export.options.usesMemory) {
        needsMemory = true;
      }
      if (export.options.needsRealloc) {
        needsRealloc = true;
      }
    }

    if (needsMemory) {
      _libcMemory = builder.linker.alias(
        .coreMemory,
        .coreInstanceExport(libc, 'memory'),
      );
    }

    if (needsRealloc) {
      _libcRealloc = builder.linker.alias(
        .coreFunction,
        .coreInstanceExport(libc, 'dart_realloc'),
      );
    }
  }

  ModuleInstanceIndex createImportInstance() {
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
          builder.types.addInstanceType(import.type),
        ),
    ];

    final functionAliases = [
      for (final (i, instance) in importedInstances.indexed)
        for (final function in instance.importedFunctions)
          builder.linker.alias(
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
        final lower = lowered[function] = builder.linker.canonLower(
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

    return builder.linker.coreInstantiate(.inlineExports(inlineExports));
  }

  void applyOptions(FunctionOptions options, CanonicalHasOptions canon) {
    if (options.usesMemory) {
      canon.memory = _libcMemory!;
    }
    if (options.needsRealloc) canon.realloc = _libcRealloc;
    if (options.usesStrings) canon.stringEncoding = .utf16;
  }
}
