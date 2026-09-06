/// Interfaces and type definitions for `wasi:http`.
///
/// To actually use these interfaces, define a component for a world importing
/// them (e.g. with [serviceComponent] for `wasi:cli/command` exposing them
/// via [ServiceImports]).
/// @docImport 'src/components/wasi_http_service.dart';
library;

export 'src/components/wasi_http.dart' hide Types;
