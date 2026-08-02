// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

import r'dart:typed_data' as i1;

abstract interface class Environment {
  /// Get the POSIX-style environment variables.
  ///
  /// Each environment variable is provided as a pair of string variable names
  /// and string value.
  ///
  /// Morally, these are a value import, but until value imports are available
  /// in the component model, this import function should return the same
  /// values each time it is called.
  List<(String, String)> getEnvironment();

  /// Get the POSIX-style arguments to the program.
  List<String> getArguments();

  /// Return a path that programs should use as their initial current working
  /// directory, interpreting `.` as shorthand for this.
  i0.Option<String> getInitialCwd();
}

abstract interface class Exit {
  /// Exit the current instance and any linked instances.
  void exit({required i0.Result<void, void> status});

  /// Exit the current instance and any linked instances, reporting the
  /// specified status code to the host.
  ///
  /// The meaning of the code depends on the context, with 0 usually meaning
  /// "success", and other values indicating various types of failure.
  ///
  /// This function does not return; the effect is analogous to a trap, but
  /// without the connotation that something bad has happened.
  void exitWithCode({required int statusCode});
}

abstract interface class Run {
  /// Run the program.
  Future<i0.Result<void, void>> run();
}

abstract interface class Types {}

enum TypesErrorCode {
  /// Input/output error
  io,

  /// Invalid or incomplete multibyte or wide character
  illegalByteSequence,

  /// Broken pipe
  pipe,
}

abstract interface class Stdin {
  /// Return a stream for reading from stdin.
  ///
  /// This function returns a stream which provides data read from stdin,
  /// and a future to signal read results.
  ///
  /// If the stream's readable end is dropped the future will resolve to success.
  ///
  /// If the stream's writable end is dropped the future will either resolve to
  /// success if stdin was closed by the writer or to an error-code if reading
  /// failed for some other reason.
  ///
  /// Multiple streams may be active at the same time. The behavior of concurrent
  /// reads is implementation-specific.
  (Stream<i1.Uint8List>, Future<i0.Result<void, TypesErrorCode>>)
  readViaStream();
}

abstract interface class Stdout {
  /// Write the given stream to stdout.
  ///
  /// If the stream's writable end is dropped this function will either return
  /// success once the entire contents of the stream have been written or an
  /// error-code representing a failure.
  ///
  /// Otherwise if there is an error the readable end of the stream will be
  /// dropped and this function will return an error-code.
  Future<i0.Result<void, TypesErrorCode>> writeViaStream({
    required Stream<i1.Uint8List> data,
  });
}

abstract interface class Stderr {
  /// Write the given stream to stderr.
  ///
  /// If the stream's writable end is dropped this function will either return
  /// success once the entire contents of the stream have been written or an
  /// error-code representing a failure.
  ///
  /// Otherwise if there is an error the readable end of the stream will be
  /// dropped and this function will return an error-code.
  Future<i0.Result<void, TypesErrorCode>> writeViaStream({
    required Stream<i1.Uint8List> data,
  });
}

/// Terminal input.
///
/// In the future, this may include functions for disabling echoing,
/// disabling input buffering so that keyboard events are sent through
/// immediately, querying supported features, and so on.
abstract interface class TerminalInput {}

/// Terminal output.
///
/// In the future, this may include functions for querying the terminal
/// size, being notified of terminal size changes, querying supported
/// features, and so on.
abstract interface class TerminalOutput {}

/// The input side of a terminal.
final class TerminalInputTerminalInput {}

/// An interface providing an optional `terminal-input` for stdin as a
/// link-time authority.
abstract interface class TerminalStdin {
  /// If stdin is connected to a terminal, return a `terminal-input` handle
  /// allowing further interaction with it.
  i0.Option<i0.Owned<TerminalInputTerminalInput>> getTerminalStdin();
}

/// The output side of a terminal.
final class TerminalOutputTerminalOutput {}

/// An interface providing an optional `terminal-output` for stdout as a
/// link-time authority.
abstract interface class TerminalStdout {
  /// If stdout is connected to a terminal, return a `terminal-output` handle
  /// allowing further interaction with it.
  i0.Option<i0.Owned<TerminalOutputTerminalOutput>> getTerminalStdout();
}

/// An interface providing an optional `terminal-output` for stderr as a
/// link-time authority.
abstract interface class TerminalStderr {
  /// If stderr is connected to a terminal, return a `terminal-output` handle
  /// allowing further interaction with it.
  i0.Option<i0.Owned<TerminalOutputTerminalOutput>> getTerminalStderr();
}
