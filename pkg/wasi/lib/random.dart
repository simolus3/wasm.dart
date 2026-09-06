/// Interfaces and type definitions for `wasi:cli`.
///
/// To actually use these interfaces, define a component for a world importing
/// them (e.g. with [commandComponent] for `wasi:cli/command` exposing them
/// via [CommandImports]).
/// @docImport 'src/components/wasi_cli_command.dart';
library;

export 'src/components/wasi_random.dart';
