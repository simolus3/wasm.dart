import 'hooks/extension.dart';
import 'program_abi.dart';

import 'components/component.dart';
import 'components/index_space.dart';
import 'components/linker.dart';

final class DartLinker {
  final DartProgramAbi abi;
  final ModuleInstanceIndex libc;
  final ComponentBuilder builder;

  CoreMemoryIndex? _libcMemory;

  DartLinker(this.builder, this.abi, this.libc) {
    var needsMemory = false;

    for (final import in abi.functionImports.values) {
      if (import.options.useMemory) {
        needsMemory = true;
      }
    }

    for (final export in abi.functionExports.values) {
      if (export.options.useMemory) {
        needsMemory = true;
      }
    }

    if (needsMemory) {
      _libcMemory = builder.linker.alias(
        .coreMemory,
        .coreInstanceExport(libc, 'memory'),
      );
    }
  }

  ModuleInstanceIndex createImportInstance() {
    // Note: Build all imports first, then all aliases, then all lowerings. This
    // means we can use 3 sections in total instead of 3 sections per function
    // import.
    final importedInstances = abi.importedInstances;
    final instances = [
      for (final import in importedInstances)
        builder.importInstance(
          import.instanceName,
          builder.addInstanceType(import.type),
        ),
    ];

    final functionAliases = [
      for (final (i, instance) in importedInstances.indexed)
        for (final function in instance.importedFunctions)
          builder.linker.alias(
            .componentFunction,
            .instanceExport(instances[i], function.function),
          ),
    ];

    final lowered = <ImportedInstanceFunction, CanonLower>{};
    var i = 0;
    for (final instance in importedInstances) {
      for (final function in instance.importedFunctions) {
        final lower = lowered[function] = builder.linker.canonLower(
          functionAliases[i++],
        );
        _applyOptions(function.options, lower);
      }
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

  void _applyOptions(FunctionOptions options, CanonicalLiftOrLower canon) {
    if (options.useMemory) {
      canon.memory = _libcMemory!;
    }
    if (options.stringEncoding case final encoding?) {
      canon.stringEncoding = encoding;
    }
  }
}
