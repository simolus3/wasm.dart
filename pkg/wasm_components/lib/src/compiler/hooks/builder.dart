import 'dart:io';

import 'package:file/local.dart';
import 'package:hooks_runner/hooks_runner.dart';
import 'package:logging/logging.dart';
import 'package:package_config/package_config.dart';

import '../abi.dart';
import 'extension.dart';
import 'extension.dart' as hooks;

Future<DartProgramAbi?> resolveProgramAbi({
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
      includeDevDependencies: false,
    ),
  );

  final buildResult = await buildRunner.build(
    extensions: [WasmComponentExtension()],
    linkingEnabled: false,
  );
  if (buildResult.isFailure) {
    final error = buildResult.asFailure.value;
    logger.shout('Invoking build hooks failed: ${error.name}');
    return null;
  }

  final abi = DartProgramAbi();
  final assets = buildResult.asSuccess.value.encodedAssets;
  for (final asset in assets) {
    if (asset.type == hooks.name) {
      abi.includeAsset(logger, asset);
    }
  }

  return abi;
}
