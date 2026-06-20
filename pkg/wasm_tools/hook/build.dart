import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

Future<void> main(List<String> args) {
  return build(args, (input, output) async {
    if (!input.config.buildCodeAssets) {
      return;
    }

    final sourceRoot = input.packageRoot;
    final config = input.config.code;
    final outputName = config.targetOS.dylibFileName('wit_bindgen_dart');

    // For versions of this package that are published to pub.dev, assets for
    // all supported ABIs are copied to lib/src/wit_gen/precompiled. Use those
    // if available.
    final precompiled = sourceRoot.resolve('lib/src/wit_gen/precompiled/');
    if (Directory.fromUri(precompiled).existsSync()) {
      final outputPath = input.outputDirectory.resolve(outputName);

      String assetName;
      if (_prebuiltAssets[(config.targetOS, config.targetArchitecture)]
          case final asset?) {
        assetName = config.targetOS.dylibFileName('wit_bindgen_dart.$asset');
      } else {
        throw ArgumentError(
          'Unsupported target ABI: ${config.targetArchitecture} on '
          '${config.targetOS}. Please file an issue on '
          'https://github.com/simolus3/sqlite3.dart/ !',
        );
      }

      File.fromUri(
        precompiled.resolve(assetName),
      ).copySync(outputPath.toFilePath());

      output.assets.code.add(
        CodeAsset(
          package: 'wasm_tools',
          name: 'src/wit_gen/native.dart',
          linkMode: DynamicLoadingBundled(),
          file: outputPath,
        ),
      );
    } else {
      // We can't use precompiled assets, use cargo to compile for the current
      // platform.
      final workspaceRoot = sourceRoot.resolve('../..');

      if (config.targetOS != OS.current ||
          config.targetArchitecture != Architecture.current) {
        throw UnsupportedError(
          'Since lib/src/wit_gen/precompiled is missing, this hook only '
          'supports the host ABI.',
        );
      }

      final build = await Process.start('cargo', [
        'build',
        '-p',
        'wit_bindgen_dart',
      ], mode: ProcessStartMode.inheritStdio);
      if (await build.exitCode case final code when code != 0) {
        throw StateError('Rust build failed: exit code $code');
      }

      final library = workspaceRoot.resolve('target/debug/$outputName');

      final depsFile = File.fromUri(
        library.resolve(
          Platform.isWindows ? 'wit_bindgen_dart.d' : 'libwit_bindgen_dart.d',
        ),
      );

      final depsContent = depsFile.readAsStringSync();
      // Format: "target: dep1 dep2 ..."
      final [_, depsList] = depsContent.split(': ');
      // Paths with spaces are escaped as "\ " in the Makefile format.
      final deps = depsList.split(RegExp(r'(?<!\\) '));
      for (final dep in deps) {
        final trimmed = dep.trim().replaceAll(r'\ ', ' ');
        if (trimmed.isNotEmpty) {
          output.dependencies.add(Uri.file(trimmed));
        }
      }
      // Also invalidate build when Cargo.lock changes.
      output.dependencies.add(workspaceRoot.resolve('Cargo.lock'));

      output.assets.code.add(
        CodeAsset(
          package: 'wasm_tools',
          name: 'src/wit_gen/native.dart',
          linkMode: DynamicLoadingBundled(),
          file: library,
        ),
      );
    }
  });
}

const _prebuiltAssets = {
  (OS.windows, Architecture.x64): 'win_x64',
  (OS.windows, Architecture.arm64): 'win_aarch64',

  (OS.macOS, Architecture.x64): 'macos_x64',
  (OS.macOS, Architecture.arm64): 'macos_aarch64',

  (OS.linux, Architecture.x64): 'linux_x64',
  (OS.linux, Architecture.riscv64): 'linux_riscv',
  (OS.linux, Architecture.arm): 'linux_arm7',
  (OS.linux, Architecture.arm64): 'linux_aarch64',
};
