import 'package:hooks/hooks.dart';
import 'package:meta/meta.dart';

@internal
const name = 'custom/wasm-component';

/// A protocol extension allowing build hooks in packages to declare
/// dependencies on WebAssembly components and to export Dart methods.
final class WasmComponentExtension extends ProtocolExtension {
  @override
  void setupBuildInput(BuildInputBuilder input) {
    input.config.addBuildAssetTypes(const [name]);
  }
}

extension HookConfigWasm on HookConfig {
  /// Whether WebAssembly components can be used by the Dart app being built.
  bool get buildWasmComponent => buildAssetTypes.contains(name);
}

/// Extension on [BuildOutputAssetsBuilder] to add [WasmComponentAsset]s.
extension BuildOutputAssetsBuilderWasm on BuildOutputAssetsBuilder {
  /// Provides access to emitting code assets.
  ///
  /// Should only be used if [HookConfigWasm.buildWasmComponent] is true.
  BuildOutputWasmComponentAssetBuilder get webAssemblyComponents {
    return BuildOutputWasmComponentAssetBuilder._(this);
  }
}

/// Extension on [BuildOutputAssetsBuilder] to add [WasmComponentAsset]s.
final class BuildOutputWasmComponentAssetBuilder {
  final BuildOutputAssetsBuilder _output;

  BuildOutputWasmComponentAssetBuilder._(this._output);

  void add(WasmComponentAsset asset) {
    _output.addEncodedAsset(asset.encode());
  }
}

final class WasmComponentAsset {
  /// The WIT context, as serialized by `wasm-tools component wit -j`.
  final Map<String, Object?> wit;
  final List<ImportedComponentFunction> imports;
  final List<ExportedInstance> exports;

  const WasmComponentAsset({
    required this.wit,
    required this.imports,
    required this.exports,
  });

  /// Encodes this into an [EncodedAsset] that can be added to
  /// [BuildOutputAssetsBuilder].
  EncodedAsset encode() {
    return EncodedAsset(name, {
      'wit': wit,
      'imports': [for (final import in imports) import.toJson()],
      'exports': [for (final export in exports) export.toJson()],
    });
  }
}

enum StringEncoding { utf8, utf16, latin1OrUtf16 }

final class FunctionOptions {
  final bool useMemory;
  final StringEncoding? stringEncoding;

  const FunctionOptions({this.useMemory = false, this.stringEncoding});

  Map<String, Object?> toJson() {
    return {'useMemory': useMemory, 'stringEncoding': stringEncoding?.name};
  }
}

final class ImportedComponentFunction {
  /// The import name used in source code.
  ///
  /// We use a `@pragma('wasm:import', 'runtime.$importName')` annotation to
  /// identify this import in Dart.
  final String importName;

  /// The imported interface, as an index in [WasmComponentAsset.wit].
  final int interfaceIndex;

  /// The name of the function in the imported interface.
  final String functionName;

  final FunctionOptions functionOptions;

  const ImportedComponentFunction({
    required this.importName,
    required this.interfaceIndex,
    required this.functionName,
    this.functionOptions = const FunctionOptions(),
  });

  Map<String, Object?> toJson() {
    return {
      'import': importName,
      'interfaceIndex': interfaceIndex,
      'functionName': functionName,
      'options': functionOptions.toJson(),
    };
  }
}

/// A component instance, to export via Dart.
final class ExportedInstance {
  /// The name of the exported instance, e.g. `wasi:cli/run@0.3.0`.
  final String name;
  final int interfaceIndex;
  final Map<String, ExportedInstanceFunction> functions;

  const ExportedInstance({
    required this.name,
    required this.interfaceIndex,
    required this.functions,
  });

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'interfaceIndex': interfaceIndex,
      'functions': {
        for (final MapEntry(:key, :value) in functions.entries)
          key: {
            'exportName': value.exportName,
            'options': value.options.toJson(),
          },
      },
    };
  }
}

final class ExportedInstanceFunction {
  /// The name used in a `@pragma('wasm:export', $exportName)` annotation to
  /// identify this export in Dart.
  final String exportName;

  final FunctionOptions options;

  const ExportedInstanceFunction({
    required this.exportName,
    this.options = const FunctionOptions(),
  });
}
