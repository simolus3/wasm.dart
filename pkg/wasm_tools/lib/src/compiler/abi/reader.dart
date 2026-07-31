import 'abi.dart';

typedef _JsonObject = Map<String, Object?>;

void readAbi(ProgramAbi abi, Map<String, Object?> encoded) {
  final rawAbi = _WasmAbi(encoded);
  final world = rawAbi.world;
  final packages = world.packages
      .map((e) => Package.parse(e['name'] as String))
      .toList();
  final interfaces = <AbiInterface>[];
  // For interfaces that don't already exist in JSON, a map from interface to
  // its definition.
  final pendingInterfaces = <AbiInterface, _JsonObject>{};
  final types = <AbiType>[];

  for (final rawInterface in world.interfaces) {
    final package = packages[rawInterface['package'] as int];
    final name = package.fullInterfaceName(rawInterface['name'] as String);

    if (abi.interfaces[name] case final existing?) {
      interfaces.add(existing);
    } else {
      final interface = AbiInterface(name);
      interfaces.add(interface);
      pendingInterfaces[interface] = rawInterface;
    }
  }

  // Unlike interfaces, types are sorted in dependency order!
  for (final rawType in world.types) {
    final name = rawType['name'] as String?;
    final ownerIdx = (rawType['owner'] as _JsonObject?)?['interface'] as int?;
    final owner = ownerIdx != null ? interfaces[ownerIdx] : null;

    final MapEntry(key: kind, value: definition) =
        (rawType['kind'] as _JsonObject).entries.single;
    switch (kind) {
      case 'record':
        throw UnimplementedError('record');
      case 'resource':
        throw UnimplementedError('resource');
      case 'handle':
        throw UnimplementedError('handle');
      case 'flags':
        throw UnimplementedError('flags');
      case 'tuple':
        throw UnimplementedError('tuple');
      case 'variant':
        throw UnimplementedError('variant');
      case 'enum':
        final cases = ((definition as _JsonObject)['cases'] as List)
            .cast<_JsonObject>()
            .map((caseDef) => caseDef['name'] as String)
            .toList();
        types.add(EnumAbiType(cases, owner: owner));
      case 'option':
        throw UnimplementedError('option');
      case 'result':
        definition as _JsonObject;

        types.add(
          ResultAbiType(
            ok: _deserializeNullableType(types, definition['ok']),
            error: _deserializeNullableType(types, definition['err']),
            owner: owner,
          ),
        );
      case 'list':
        throw UnimplementedError('list');
      case 'map':
        throw UnimplementedError('map');
      case 'fixed-length-list':
        throw UnimplementedError('fixed-length-list');
      case 'future':
        types.add(FutureAbiType(_deserializeType(types, definition)));
      case 'stream':
        types.add(StreamAbiType(_deserializeType(types, definition)));
      case 'type':
        final resolved = types[definition as int];
        final originalOwner = resolved.owner;
        if (originalOwner == null || resolved.owner == owner) {
          types.add(resolved);
          break;
        }

        types.add(
          ImportedAbiType(
            originalOwner,
            ArgumentError.checkNotNull(name, 'name'),
            owner: owner,
          ),
        );
      default:
        throw ArgumentError.value(kind, 'kind', 'Unknown type kind');
    }
  }

  for (final MapEntry(:key, :value) in pendingInterfaces.entries) {
    for (final MapEntry(key: name, value: index as int)
        in (value['types'] as _JsonObject).entries) {
      key.exportedTypes[name] = types[index];
    }

    for (final MapEntry(key: name, value: definition as _JsonObject)
        in (value['functions'] as _JsonObject).entries) {
      key.exportedFunctions[name] = AbiFunction(
        [
          for (final {'name': paramName as String, 'type': type}
              in (definition['params'] as List).cast<_JsonObject>())
            (paramName, _deserializeType(types, type)),
        ],
        _deserializeNullableType(types, definition['result']),
        (definition['kind'] as String).startsWith('async-'),
      );
    }
  }

  // Commit pending interfaces to abi
  for (final added in pendingInterfaces.keys) {
    abi.interfaces[added.fullName] = added;
  }
}

AbiType? _deserializeNullableType(List<AbiType> existing, Object? type) {
  return type == null ? null : _deserializeType(existing, type);
}

AbiType _deserializeType(List<AbiType> existing, Object? type) {
  // https://github.com/bytecodealliance/wasm-tools/blob/dce7a7a0e265983145f2ec1bf1ec6b1092211ad4/crates/wit-parser/src/serde_.rs#L69-L92
  return switch (type) {
    'bool' => const SimpleAbiType.primitive(.bool),
    'u8' => const SimpleAbiType.primitive(.u8),
    'u16' => const SimpleAbiType.primitive(.u16),
    'u32' => const SimpleAbiType.primitive(.u32),
    'u64' => const SimpleAbiType.primitive(.u64),
    's8' => const SimpleAbiType.primitive(.s8),
    's16' => const SimpleAbiType.primitive(.s16),
    's32' => const SimpleAbiType.primitive(.s32),
    's64' => const SimpleAbiType.primitive(.s64),
    'f32' => const SimpleAbiType.primitive(.f32),
    'f64' => const SimpleAbiType.primitive(.f64),
    'char' => const SimpleAbiType.primitive(.char),
    'string' => const SimpleAbiType.string(),
    final int typeIdx => existing[typeIdx],
    _ => throw ArgumentError.value(type, 'type'),
  };
}

extension type _WasmAbi(_JsonObject json) implements _JsonObject {
  _SerializedWorld get world => json['world'] as _SerializedWorld;
}

extension type _SerializedWorld(_JsonObject json) implements _JsonObject {
  List<_JsonObject> get types => (json['types'] as List).cast();
  List<_JsonObject> get packages => (json['packages'] as List).cast();
  List<_JsonObject> get interfaces => (json['interfaces'] as List).cast();
}

final class Package {
  /// The name of the WIT package, e.g `wasi:cli`.
  final String name;

  /// The optional version of the package, e.g. `0.3.0`.
  final String? version;

  new(this.name, [this.version]);

  String fullInterfaceName(String nonqualified) {
    final buffer = StringBuffer(name)
      ..write('/')
      ..write(nonqualified);
    if (version case final version?) {
      buffer
        ..write('@')
        ..write(version);
    }

    return buffer.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Package && other.name == name && other.version == version;

  @override
  int get hashCode => Object.hash(name, version);

  static Package parse(String name) {
    final split = name.split('@');
    return switch (split) {
      [final name] => Package(name),
      [final name, final version] => Package(name, version),
      _ => throw ArgumentError.value(name, 'name', 'Invalid package name'),
    };
  }
}
