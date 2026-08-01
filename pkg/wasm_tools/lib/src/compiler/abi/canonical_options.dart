import '../components/definition.dart';
import 'linker.dart';

final class CanonicalOptions {
  final bool usesMemory;
  final bool usesString;
  final bool usesRealloc;
  final bool isAsync;
  final bool usesCallback;

  final String? postReturn;

  const new({
    this.usesMemory = false,
    this.usesString = false,
    this.usesRealloc = false,
    this.isAsync = false,
    this.usesCallback = false,
    this.postReturn,
  });

  factory CanonicalOptions.fromJson(Map<String, Object?> json) {
    return CanonicalOptions(
      usesMemory: json['uses_memory'] as bool,
      usesString: json['uses_strings'] as bool,
      usesRealloc: json['uses_realloc'] as bool,
      isAsync: json['is_async'] as bool? ?? false,
      usesCallback: json['uses_callback'] as bool? ?? false,
      postReturn: json['post_return'] as String?,
    );
  }

  void requireDefinitions(Linker linker) {
    if (usesMemory) linker.libcMemory;
    if (usesRealloc) linker.libcRealloc;
    if (usesCallback) linker.programExport('callback');
    if (postReturn case final pr?) linker.programExport(pr);
  }

  void applyTo(Linker linker, CanonicalHasOptions definition) {
    if (usesMemory) definition.memory = linker.libcMemory;
    if (usesRealloc) definition.realloc = linker.libcRealloc;
    if (usesString) definition.stringEncoding = .utf16;
    if (isAsync) definition.async = true;
    if (usesCallback) definition.callback = linker.programExport('callback');
    if (postReturn case final pr?) {
      definition.postReturn = linker.programExport(pr);
    }
  }
}
