import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file/local.dart';
import 'package:hooks_runner/hooks_runner.dart';
import 'package:logging/logging.dart';
import 'package:package_config/package_config.dart';

import '../../failure.dart';
import '../abi/abi.dart';
import '../abi/reader.dart' hide Package;
import 'extension.dart';
import 'extension.dart' as hooks;

final class PreCompilationBuildResult {
  final String packageConfigFile;
  final PackageConfig packageConfig;
  final NativeAssetsBuildRunner _buildRunner;
  final BuildResult _result;

  PreCompilationBuildResult._(
    this.packageConfigFile,
    this.packageConfig,
    this._buildRunner,
    this._result,
  );

  /// Resolves the file containing pre-compiled WebAssembly helpers used to
  /// implement component interop.
  ///
  /// This file is stored in `assets/runtime_helpers.wasm` of the `wasm_tools`
  /// package, which we locate through the package config.
  Future<File> resolveRuntimeHelpersFile() async {
    final entry = packageConfig.packages.firstWhereOrNull(
      (p) => p.name == 'wasm_tools',
    );
    if (entry == null) {
      throw ToolFailure('No dependency on wasm_tools found.');
    }

    final file = File.fromUri(
      entry.root.resolve('assets/runtime_helpers.wasm'),
    );
    if (!await file.exists()) {
      throw ToolFailure('Internal error, expected ${file.path} to exist');
    }
    return file;
  }

  Future<ProgramAbi> linkAbi({
    required Logger logger,
    required File entrypoint,
    required File useFile,
  }) async {
    final linkResult = await _buildRunner.link(
      extensions: [WasmComponentExtension()],
      buildResult: _result,
      recordUse: RecordUseConfig(
        file: useFile.uri,
        entryPoints: [entrypoint.uri],
        compiler: 'wasm_tools',
      ),
    );

    final abi = ProgramAbi();

    if (linkResult.isFailure) {
      logger.shout('Could not run link hooks: ${linkResult.asFailure.value}');
      return abi;
    }

    final assets = linkResult.asSuccess.value.encodedAssets;
    for (final asset in assets) {
      if (asset.type == hooks.name) {
        readAbi(abi, asset.encoding);
      }
    }

    return abi;
  }

  static Future<PreCompilationBuildResult?> runBuild({
    required File mainFile,
    required Logger logger,
  }) async {
    final mainUri = mainFile.absolute.uri;
    final pkgConfig = await findPackageConfigAndUri(mainUri);
    final mainPackage = pkgConfig?.config.packageOf(mainUri);
    if (pkgConfig == null || mainPackage == null) {
      logger.shout('No package config was found for ${mainFile.path}');
      return null;
    }

    const fs = LocalFileSystem();

    final buildRunner = NativeAssetsBuildRunner(
      logger: logger,
      dartExecutable: File(Platform.resolvedExecutable).uri,
      fileSystem: fs,
      packageLayout: PackageLayout.fromPackageConfig(
        fs,
        pkgConfig.config,
        pkgConfig.file,
        mainPackage.name,
        includeDevDependencies: true,
      ),
    );

    final buildResult = await buildRunner.build(
      extensions: [WasmComponentExtension()],
      linkingEnabled: true,
    );
    if (buildResult.isFailure) {
      final error = buildResult.asFailure.value;
      logger.shout('Invoking build hooks failed: ${error.name}');
      return null;
    }

    return PreCompilationBuildResult._(
      pkgConfig.file.toFilePath(),
      pkgConfig.config,
      buildRunner,
      buildResult.asSuccess.value,
    );
  }
}
