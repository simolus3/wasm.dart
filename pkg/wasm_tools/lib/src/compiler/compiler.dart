import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'components/component.dart';
import 'components/index_space.dart';
import 'components/linker.dart';
import 'dart_linker.dart';
import 'hooks/builder.dart';
import 'transform.dart';

final class CompilerOptions {
  final File input;
  final File output;
  final bool hooksIncludeDevDependencies;

  CompilerOptions(
    this.input,
    this.output, {
    this.hooksIncludeDevDependencies = false,
  });
}

final class ComponentCompiler {
  final CompilerOptions options;
  final Logger logger;

  ComponentCompiler(this.options, this.logger);

  Future<void> run() async {
    final workspace = await Directory.systemTemp.createTemp('dart-wasm-cm');
    final dart2wasmOut = p.join(workspace.path, 'app.dart2.wasm');

    try {
      logger.fine('Invoking build hooks to infer ABI');
      final resolved = await PackageConfigWithAbi.resolveProgramAbi(
        mainFile: options.input,
        logger: logger,
        includeDevDependencies: options.hooksIncludeDevDependencies,
      );
      if (resolved == null) {
        throw CompilerFailure('Could not resolve components');
      }
      final abi = resolved.abi;

      logger.fine('Building main application');
      final binDir = p.dirname(Platform.resolvedExecutable);
      final sdkDir = p.dirname(binDir);
      final dartAotRuntime = p.join(
        binDir,
        Platform.isWindows ? 'dartaotruntime.exe' : 'dartaotruntime',
      );
      final snapshot = p.join(
        binDir,
        'snapshots',
        'dart2wasm_product.snapshot',
      );
      final librariesSpec = p.join(sdkDir, 'lib', 'libraries.json');

      var result = await (await Process.start(dartAotRuntime, [
        snapshot,
        '--libraries-spec',
        librariesSpec,
        '--packages',
        resolved.packageConfigFile,
        '--standalone',
        '--enable-experimental-wasm-interop',
        '--no-minify',
        '--no-strip-wasm',
        '-O0',
        options.input.path,
        dart2wasmOut,
      ], mode: .inheritStdio)).exitCode;
      if (result != 0) {
        throw CompilerFailure('dart2wasm failed: $result');
      }

      final transformer = ModuleTransformer.fromBytes(
        await File(dart2wasmOut).readAsBytes(),
        logger,
      );
      transformer.transform(abi);

      final builder = ComponentBuilder();
      final libcDef = builder.defineModuleFromBytes(
        await (await resolved.resolveRuntimeHelpersFile()).readAsBytes(),
      );
      final libc = builder.linker.coreInstantiate(.moduleAndArgs(libcDef, {}));

      final appDef = builder.defineModule(transformer.module);
      final linker = DartLinker(builder, abi, libc);
      final app = builder.linker.coreInstantiate(
        .moduleAndArgs(appDef, {
          'libc': libc,
          'component': linker.createImportInstance(),
        }),
      );

      for (final export in abi.interfaces) {
        if (export.exports.isEmpty) continue;

        final inlineExports = <(String, Sort, Index)>[];

        for (final function in export.exports) {
          final resolved = builder.linker.alias(
            .coreFunction,
            .coreInstanceExport(app, function.exportCoreFunctionName),
          );
          CoreFunctionIndex? corePostReturnFunction;
          if (function.options.postReturn case final postReturn?) {
            corePostReturnFunction = builder.linker.alias(
              .coreFunction,
              .coreInstanceExport(app, postReturn),
            );
          }

          final originalType = function.type;
          final lifted = builder.linker.canonLift(
            resolved,
            builder.addFunctionType(originalType),
          );
          linker.applyOptions(function.options, lifted);
          lifted.postReturn = corePostReturnFunction;

          inlineExports.add((
            function.name,
            .componentFunction,
            lifted.createdFunction,
          ));
        }

        final instance = builder.linker.instance(inlineExports: inlineExports);
        builder.linker.export(
          Export(export.fullName, .componentInstance, instance),
        );
      }

      logger.info('Writing component to ${options.output.path}');
      await options.output.writeAsBytes(builder.serializeToBytes());
    } finally {
      await workspace.delete(recursive: true);
    }
  }
}

final class CompilerFailure implements Exception {
  final String message;

  CompilerFailure(this.message);

  @override
  String toString() {
    return 'Compiler failure: $message';
  }
}
