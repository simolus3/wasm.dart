import 'dart:ffi';

@Native<Void Function(Size, Pointer<Uint8>, Pointer<RawExportResult>)>(
  isLeaf: true,
)
// ignore: non_constant_identifier_names
external void wit_bindgen_dart_gen(
  int length,
  Pointer<Uint8> bytes,
  Pointer<RawExportResult> result,
);

@Native<Void Function(Pointer<RawExportResult>)>(isLeaf: true)
// ignore: non_constant_identifier_names
external void wit_bindgen_dart_free(Pointer<RawExportResult> result);

final class RawExportResult extends Struct {
  external Pointer<Uint8> start;
  @Size()
  external int length;
  @Size()
  external int capacity;
}
