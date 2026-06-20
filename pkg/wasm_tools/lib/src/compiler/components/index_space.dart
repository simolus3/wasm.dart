import '../../third_party/wasm_builder/wasm_builder.dart' as w;

extension type const Index(int index) {}

extension type const ComponentFunctionIndex(int index) implements Index {}
extension type const ComponentTypeIndex(int index) implements Index {}
extension type const ComponentInstanceIndex(int index) implements Index {}
extension type const CoreFunctionIndex(int index) implements Index {}
extension type const CoreTypeIndex(int index) implements Index {}
extension type const CoreMemoryIndex(int index) implements Index {}
extension type const ModuleIndex(int index) implements Index {}
extension type const ModuleInstanceIndex(int index) implements Index {}

enum Sort<I extends Index> {
  componentInstance<ComponentInstanceIndex>(),
  componentFunction<ComponentFunctionIndex>(),
  coreFunction<CoreFunctionIndex>(),
  coreMemory<CoreMemoryIndex>();

  void serializeAsSort(w.Serializer s) {
    switch (this) {
      case .coreFunction:
        s.writeByte(0x00);
        s.writeByte(0x00);
      case .coreMemory:
        s.writeByte(0x00);
        s.writeByte(0x02);
      case .componentFunction:
        s.writeByte(0x01);
      case .componentInstance:
        s.writeByte(0x05);
    }
  }
}

/// Tracking index counters for elements used in components and modules.
///
/// Some index spaces, e.g. the [ComponentTypeIndex], are implicitly tracked on
/// component builders and don't require an explicit counter.
final class IndexSpaceCounters {
  var _componentInstance = 0;
  var _componentFunction = 0;

  var _coreMemory = 0;
  var _coreFunction = 0;
  var _coreInstance = 0;

  I increment<I extends Index>(Sort<I> sort) {
    return switch (sort) {
          Sort.componentInstance => incrementComponentInstance(),
          Sort.componentFunction => incrementComponentFunction(),
          Sort.coreFunction => incrementCoreFunction(),
          Sort.coreMemory => incrementCoreMemory(),
        }
        as I;
  }

  ComponentInstanceIndex incrementComponentInstance() {
    return ComponentInstanceIndex(_componentInstance++);
  }

  ComponentFunctionIndex incrementComponentFunction() {
    return ComponentFunctionIndex(_componentFunction++);
  }

  CoreFunctionIndex incrementCoreFunction() {
    return CoreFunctionIndex(_coreFunction++);
  }

  CoreMemoryIndex incrementCoreMemory() {
    return CoreMemoryIndex(_coreMemory++);
  }

  ModuleInstanceIndex incrementCoreInstance() {
    return ModuleInstanceIndex(_coreInstance++);
  }
}
