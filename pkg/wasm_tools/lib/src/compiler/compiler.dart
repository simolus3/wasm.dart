import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'abi/linker.dart';
import 'components/component.dart';
import 'components/definition.dart';
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
    final recordedUses = p.join(workspace.path, 'recorded_uses.json');

    try {
      logger.fine('Running build hooks');
      final buildConfig = await PreCompilationBuildResult.runBuild(
        mainFile: options.input,
        logger: logger,
      );
      if (buildConfig == null) {
        throw CompilerFailure('Could not run build hooks');
      }

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
        buildConfig.packageConfigFile,
        '--standalone',
        '--enable-experimental-wasm-interop',
        '--no-minify',
        '--no-strip-wasm',
        '-O0',
        options.input.path,
        dart2wasmOut,
        '--recorded-uses',
        recordedUses,
      ], mode: .inheritStdio)).exitCode;
      if (result != 0) {
        throw CompilerFailure('dart2wasm failed: $result');
      }

      logger.fine('Invoking link hooks to infer ABI');
      final abi = await buildConfig.linkAbi(
        logger: logger,
        entrypoint: options.input,
        useFile: File(recordedUses),
      );

      final transformer = ModuleTransformer.fromBytes(
        await File(dart2wasmOut).readAsBytes(),
        logger,
      );
      transformer.transform(abi);

      final builder = ComponentBuilder();
      final libcDef = builder.defineModuleFromBytes(
        await (await buildConfig.resolveRuntimeHelpersFile()).readAsBytes(),
      );
      final appDef = builder.defineModule(transformer.module);

      final libc = builder.coreInstantiate(.moduleAndArgs(libcDef, {}));
      final linker = Linker(builder, libc: libc, logger: logger);
      linker.program = builder.coreInstantiate(
        .moduleAndArgs(appDef, {
          'libc': libc,
          'component': abi.createImportInstance(linker),
        }),
      );

      for (final export in abi.exports) {
        final instance = export.instantiate(linker);
        builder.export(
          Export(export.interface.fullName, .componentInstance, instance),
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
