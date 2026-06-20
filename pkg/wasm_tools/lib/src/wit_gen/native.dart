import 'dart:ffi';

@Native<Void Function(Pointer<GenerateDartOptions>, Pointer<ExportResult>)>()
// ignore: non_constant_identifier_names
external void wit_bindgen_dart_gen(
  Pointer<GenerateDartOptions> options,
  Pointer<ExportResult> result,
);

@Native<Void Function(Pointer<ExportResult>)>()
// ignore: non_constant_identifier_names
external void wit_bindgen_dart_free(Pointer<ExportResult> result);

final class GenerateDartOptions extends Struct {
  external Pointer<ImportFile> files;
  @Size()
  external int fileCount;
  external Pointer<Uint8> main;
  @Size()
  external int mainLength;
}

final class ImportFile extends Struct {
  external Pointer<Uint8> contents;
  @Size()
  external int contentsLength;
  external Pointer<Uint8> path;
  @Size()
  external int pathLength;
  @Char()
  external int isMain;
}

final class ExportResult extends Struct {
  external Pointer<Uint8> output;
  @Size()
  external int outputLength;
  @Size()
  external int outputCapacity;
  external Pointer<Uint8> abi;
  @Size()
  external int abiLength;
  @Size()
  external int abiCapacity;
  @Char()
  external int isError;
}
