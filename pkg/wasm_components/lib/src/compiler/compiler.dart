import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'components/component.dart';
import 'components/index_space.dart';
import 'components/linker.dart';
import 'hooks/builder.dart';
import 'subprocess.dart';
import 'transform.dart';

final class CompilerOptions {
  final File input;
  final File output;

  CompilerOptions(this.input, this.output);
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
      final abi = await resolveProgramAbi(
        mainFile: options.input,
        logger: logger,
      );
      if (abi == null) throw CompilerFailure('Could not resolve components');

      logger.fine('Building wasi helpers');
      await compileLibc(.standalone);

      logger.fine('Building main application');
      var result = await (await Process.start(Platform.executable, [
        'compile',
        'wasm',
        '--standalone',
        '-E',
        '--enable-experimental-wasm-interop',
        '--no-minify',
        '--no-strip-wasm',
        options.input.path,
        '--output',
        dart2wasmOut,
      ], mode: .inheritStdio)).exitCode;
      if (result != 0) {
        throw CompilerFailure('dart2wasm failed: $result');
      }

      final transformer = ModuleTransformer.fromBytes(
        await File(dart2wasmOut).readAsBytes(),
      );
      transformer.transform(abi.functionExports.keys.toSet());

      final builder = ComponentBuilder();
      final libcDef = builder.defineModuleFromBytes(
        await File(
          '../../target/wasm32-unknown-unknown/release/dart_libc_standalone.wasm',
        ).readAsBytes(),
      );
      final libc = builder.linker.coreInstantiate(.moduleAndArgs(libcDef, {}));

      final appDef = builder.defineModule(transformer.module);
      final app = builder.linker.coreInstantiate(
        .moduleAndArgs(appDef, {
          'libc': libc,
          // TODO: Additional imported components.
        }),
      );

      for (final export in abi.exportedInstances) {
        final inlineExports = <(String, Sort, Index)>[];

        for (final function in export.exports) {
          final resolved = builder.linker.alias(
            .coreFunction,
            .coreInstanceExport(app, function.exportCoreFunctionName),
          );
          final originalType = function.type;
          final lifted = builder.linker.canonLift(
            resolved,
            builder.addFunctionType(originalType),
          );
          inlineExports.add((
            function.name,
            .componentFunction,
            lifted.createdFunction,
          ));
        }

        final instance = builder.linker.instance(inlineExports: inlineExports);
        builder.linker.export(
          Export(export.instanceName, .componentInstance, instance),
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
