import '../../third_party/wasm_builder/wasm_builder.dart' as w;

extension type const Index(int index) {
  void serialize(w.Serializer serializer) {
    serializer.writeSigned(index);
  }
}

extension type const ComponentFunctionIndex(int index) implements Index {}

extension type const ComponentTypeIndex(int index) implements Index {}

extension type const ComponentInstanceIndex(int index) implements Index {}

extension type const CoreFunctionIndex(int index) implements Index {}

extension type const CoreTypeIndex(int index) implements Index {}

extension type const CoreMemoryIndex(int index) implements Index {}

extension type const CoreModuleIndex(int index) implements Index {}

extension type const CoreInstanceIndex(int index) implements Index {}

enum Sort<I extends Index> {
  componentInstance<ComponentInstanceIndex>(),
  componentFunction<ComponentFunctionIndex>(),
  componentType<ComponentTypeIndex>(),
  coreFunction<CoreFunctionIndex>(),
  coreMemory<CoreMemoryIndex>(),
  coreModule<CoreModuleIndex>(),
  coreInstance<CoreInstanceIndex>();

  void serializeAsSort(w.Serializer s) {
    switch (this) {
      case .coreFunction:
        s.writeByte(0x00);
        s.writeByte(0x00);
      case .coreMemory:
        s.writeByte(0x00);
        s.writeByte(0x02);
      case .coreModule:
        s.writeByte(0x00);
        s.writeByte(0x11);
      case .coreInstance:
        s.writeByte(0x00);
        s.writeByte(0x12);
      case .componentFunction:
        s.writeByte(0x01);
      case .componentType:
        s.writeByte(0x03);
      case .componentInstance:
        s.writeByte(0x05);
    }
  }
}

/// Tracking index counters for elements used in components and modules.
final class IndexSpaceCounters {
  var _componentInstance = 0;
  var _componentFunction = 0;
  var _componentType = 0;

  var _coreMemory = 0;
  var _coreFunction = 0;
  var _coreModule = 0;
  var _coreInstance = 0;

  I increment<I extends Index>(Sort<I> sort) {
    return switch (sort) {
      Sort.componentInstance => incrementComponentInstance(),
      Sort.componentFunction => incrementComponentFunction(),
      Sort.componentType => incrementComponentType(),
      Sort.coreFunction => incrementCoreFunction(),
      Sort.coreMemory => incrementCoreMemory(),
      Sort.coreModule => incrementCoreModule(),
      Sort.coreInstance => incrementCoreInstance(),
    } as I;
  }

  ComponentInstanceIndex incrementComponentInstance() {
    return ComponentInstanceIndex(_componentInstance++);
  }

  ComponentFunctionIndex incrementComponentFunction() {
    return ComponentFunctionIndex(_componentFunction++);
  }

  ComponentTypeIndex incrementComponentType() {
    return ComponentTypeIndex(_componentType++);
  }

  CoreFunctionIndex incrementCoreFunction() {
    return CoreFunctionIndex(_coreFunction++);
  }

  CoreMemoryIndex incrementCoreMemory() {
    return CoreMemoryIndex(_coreMemory++);
  }

  CoreModuleIndex incrementCoreModule() {
    return CoreModuleIndex(_coreModule++);
  }

  CoreInstanceIndex incrementCoreInstance() {
    return CoreInstanceIndex(_coreInstance++);
  }
}
