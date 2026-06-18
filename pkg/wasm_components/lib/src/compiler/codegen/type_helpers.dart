import 'dart:math';

import '../components/type.dart';

/// A visitor implementing the [despecialize](https://github.com/WebAssembly/component-model/blob/main/design/mvp/CanonicalABI.md#despecialization)
/// algorithm.
final class Despecializer extends ValueTypeVisitor<void, ValueType> {
  const Despecializer();

  @override
  ValueType defaultType(ValueType type, void arg) {
    return type;
  }

  @override
  ValueType visitTupleType(TupleType type, void arg) {
    return RecordType([
      for (final (i, t) in type.elements.indexed)
        .new(label: i.toString(), type: t),
    ]);
  }

  @override
  ValueType visitEnumType(EnumType type, void arg) {
    return VariantType([
      for (final label in type.enumNames) .new(label: label, type: null),
    ]);
  }

  @override
  ValueType visitOptionType(OptionType type, void arg) {
    return VariantType([
      .new(label: 'none', type: null),
      .new(label: 'some', type: type.inner),
    ]);
  }

  @override
  ValueType visitResultType(ResultType type, void arg) {
    return VariantType([
      .new(label: 'ok', type: type.ok),
      .new(label: 'error', type: type.error),
    ]);
  }

  // We don't currently support maps.
}

extension SizeAndAlignment on ValueType {
  /// Computes the [alignment](https://github.com/WebAssembly/component-model/blob/main/design/mvp/CanonicalABI.md#alignment)
  /// of a despecialized value type.
  int alignment({bool memory64 = false}) {
    final ptrSize = memory64 ? 8 : 4;
    return switch (this) {
      PrimitiveType.bool => 1,
      PrimitiveType.s8 || PrimitiveType.u8 => 1,
      PrimitiveType.s16 || PrimitiveType.u16 => 2,
      PrimitiveType.s32 || PrimitiveType.u32 => 4,
      PrimitiveType.s64 || PrimitiveType.u64 => 8,
      PrimitiveType.f32 => 4,
      PrimitiveType.f64 => 8,
      PrimitiveType.char => 4,
      StringType() => ptrSize,
      // Error context type not currently supported.
      VariableLengthListType() => ptrSize,
      FixedLengthListType(:final elementType) => elementType.alignment(
        memory64: memory64,
      ),
      RecordType(:final fields) => fields.fold(
        1,
        (acc, f) => max(acc, f.type.alignment(memory64: memory64)),
      ),
      VariantType(:final discriminantWidth, :final fields) => max(
        discriminantWidth ~/ 8,
        _maxCaseAlignment(fields, memory64),
      ),
      FlagsType(:final flagNames) => switch (flagNames.length) {
        <= 8 => 1,
        <= 16 => 2,
        _ => 4,
      },
      OwnType() || BorrowType() || StreamType() || FutureType() => 4,
      TupleType() ||
      EnumType() ||
      OptionType() ||
      ResultType() => visit(despecializer, null).alignment(memory64: memory64),
      ValueTypeReference(:final resolvedType) => resolvedType.alignment(
        memory64: memory64,
      ),
    };
  }

  int elementSize({bool memory64 = false}) {
    final ptrSize = memory64 ? 8 : 4;

    return switch (this) {
      PrimitiveType.bool => 1,
      PrimitiveType.s8 || PrimitiveType.u8 => 1,
      PrimitiveType.s16 || PrimitiveType.u16 => 2,
      PrimitiveType.s32 || PrimitiveType.u32 => 4,
      PrimitiveType.s64 || PrimitiveType.u64 => 8,
      PrimitiveType.f32 => 4,
      PrimitiveType.f64 => 8,
      PrimitiveType.char => 4,
      StringType() => 2 * ptrSize,
      // Error context type not currently supported.
      FixedLengthListType(:final length, :final elementType) =>
        length * elementType.elementSize(memory64: memory64),
      VariableLengthListType() => 2 * ptrSize,
      final RecordType record => _elementSizeRecord(record, memory64),
      final VariantType variant => _elementSizeVariant(variant, memory64),
      FlagsType(:final flagNames) => switch (flagNames.length) {
        <= 8 => 1,
        <= 16 => 2,
        _ => 4,
      },
      OwnType() || BorrowType() || StreamType() || FutureType() => 4,
      TupleType() || EnumType() || OptionType() || ResultType() => visit(
        despecializer,
        null,
      ).elementSize(memory64: memory64),
      ValueTypeReference(:final resolvedType) => resolvedType.elementSize(
        memory64: memory64,
      ),
    };
  }

  static int _maxCaseAlignment(List<VariantField> fields, bool memory64) {
    return fields.fold(
      1,
      (acc, f) => max(acc, f.type?.alignment(memory64: memory64) ?? 0),
    );
  }

  static int _elementSizeRecord(RecordType type, bool memory64) {
    var s = 0;
    for (final field in type.fields) {
      s = alignTo(s, field.type.alignment(memory64: memory64));
      s += field.type.elementSize(memory64: memory64);
    }
    assert(s > 0);
    return alignTo(s, type.alignment(memory64: memory64));
  }

  static int _elementSizeVariant(VariantType type, bool memory64) {
    var s = type.discriminantWidth ~/ 8;
    s = alignTo(s, _maxCaseAlignment(type.fields, memory64));
    var cs = 0;
    for (final field in type.fields) {
      if (field.type case final type?) {
        cs = max(cs, type.elementSize(memory64: memory64));
      }
    }
    s += cs;
    return alignTo(s, type.alignment(memory64: memory64));
  }

  static int alignTo(int a, int alignment) {
    if (a % alignment == 0) {
      return (a ~/ alignment) * alignment;
    }

    return (1 + a ~/ alignment) * alignment;
  }

  static const despecializer = Despecializer();
}
