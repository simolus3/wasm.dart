import 'type.dart';

final class WitPackage {
  final String name;
  final String? version;

  WitPackage._(this.name, this.version);

  factory WitPackage(String name) {
    final split = name.split('@');
    if (split.length == 1) {
      return WitPackage._(split[0], null);
    } else {
      return WitPackage._(split[0], split[1]);
    }
  }
}

final class ResolvedInstance {
  final WitPackage package;
  final String name;
  final InstanceType type;

  String get fullName {
    final builder = StringBuffer(package.name)
      ..write('/')
      ..write(name);
    if (package.version case final version?) {
      builder
        ..write('@')
        ..write(version);
    }

    return builder.toString();
  }

  ResolvedInstance(this.package, this.name, this.type);
}

final class ResolvedWitDefinitions {
  final List<WitPackage> packages = [];
  final List<ValueType> _types = [];
  final List<ResolvedInstance> instances = [];

  void readJson(Map<String, Object?> json) {
    if (json['packages'] case final packages?) {
      for (final entry in (packages as List).cast<Map<String, Object?>>()) {
        final name = entry['name'] as String;
        this.packages.add(WitPackage(name));
      }
    }

    if (json['types'] case final types?) {
      for (final entry in (types as List).cast<Map<String, Object?>>()) {
        _types.add(_readType(entry));
      }
    }

    if (json['interfaces'] case final interfaces?) {
      for (final interface
          in (interfaces as List).cast<Map<String, Object?>>()) {
        final package = packages[interface['package'] as int];
        final name = interface['name'] as String;
        final functions = <(String, FunctionType)>[];

        for (final function
            in (interface['functions'] as Map<String, Object?>).entries) {
          final name = function.key;
          final value = function.value as Map<String, Object?>;
          final params = <RecordField>[
            for (final rawParam in value['params'] as List)
              RecordField(
                label: rawParam['name'] as String,
                type: _readType(rawParam['type'] as Object),
              ),
          ];
          final result = _readOptionalType(value['result']);
          final async = (value['kind'] as String).contains('async');

          functions.add((
            name,
            FunctionType(async: async, parameters: params, result: result),
          ));
        }

        instances.add(ResolvedInstance(package, name, InstanceType(functions)));
      }
    }
  }

  ValueType _readType(Object type) {
    switch (type) {
      case final int index:
        return _types[index];
      case final Map<String, Object?> type:
        final MapEntry(:key, :value) =
            (type['kind'] as Map<String, Object?>).entries.single;
        switch (key) {
          case 'result':
            final ok = _readOptionalType((value as Map<String, Object?>)['ok']);
            final err = _readOptionalType(value['err']);

            return ResultType(ok: ok, error: err);
          default:
            throw ArgumentError('Unsupported type kind: $key');
        }
      default:
        throw ArgumentError('Unsupported type: $type');
    }
  }

  ValueType? _readOptionalType(Object? type) {
    return switch (type) {
      null => null,
      final type => _readType(type),
    };
  }
}
