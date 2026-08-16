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

  @override
  void setupLinkInput(LinkInputBuilder input) {
    input.config.addBuildAssetTypes(const [name]);
  }
}

extension HookConfigWasm on HookConfig {
  /// Whether WebAssembly components can be used by the Dart app being built.
  bool get buildWasmComponent => buildAssetTypes.contains(name);
}

/// Extension on [LinkOutputAssetsBuilder] to add [WasmComponentAsset]s.
extension LinkOutputAssetsBuilderWasm on LinkOutputAssetsBuilder {
  /// Provides access to emitting code assets.
  ///
  /// Should only be used if [HookConfigWasm.buildWasmComponent] is true.
  LinkOutputWasmComponentAssetBuilder get webAssemblyComponents {
    return LinkOutputWasmComponentAssetBuilder._(this);
  }
}

/// Extension on [LinkOutputAssetsBuilder] to add [WasmComponentAsset]s.
final class LinkOutputWasmComponentAssetBuilder {
  final LinkOutputAssetsBuilder _output;

  LinkOutputWasmComponentAssetBuilder._(this._output);

  void add(WasmComponentAsset asset) {
    _output.addEncodedAsset(asset.encode());
  }
}

final class WasmComponentAsset {
  /// The WIT context, as serialized by `dart run wasm_tools witgen`.
  final Map<String, Object?> encoded;

  const WasmComponentAsset({required this.encoded});

  /// Encodes this into an [EncodedAsset] that can be added to
  /// [BuildOutputAssetsBuilder].
  EncodedAsset encode() {
    return EncodedAsset(name, encoded);
  }
}
