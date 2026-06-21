import 'type.dart';

final class ResolvedWitDefinitions {
  final List<ValueType> types = [];

  void readTypes(List<Object?> types) {
    for (final entry in types.cast<Map<String, Object?>>()) {
      this.types.add(readType(entry));
    }
  }

  ValueType readType(Object type) {
    switch (type) {
      case final int index:
        return types[index];
      case 'string':
        return StringType();
      case 'u8':
        return PrimitiveType.u8;
      case 'u16':
        return PrimitiveType.u8;
      case 'u32':
        return PrimitiveType.u32;
      case 'u64':
        return PrimitiveType.u64;
      case 's8':
        return PrimitiveType.s8;
      case 's16':
        return PrimitiveType.s8;
      case 's32':
        return PrimitiveType.s32;
      case 's64':
        return PrimitiveType.s64;
      case 'f32':
        return PrimitiveType.f32;
      case 'f64':
        return PrimitiveType.f64;
      case {'kind': final kind}:
        switch (kind) {
          case 'string':
            return StringType();
          case {'result': final result}:
            final ok = readOptionalType((result as Map<String, Object?>)['ok']);
            final err = readOptionalType(result['err']);

            return ResultType(ok: ok, error: err);
        }
    }

    throw ArgumentError('Unsupported type: $type');
  }

  ValueType? readOptionalType(Object? type) {
    return switch (type) {
      null => null,
      final type => readType(type),
    };
  }
}
