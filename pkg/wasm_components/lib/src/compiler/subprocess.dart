import 'dart:io';

Future<void> runSubprocess(
  String executable,
  List<String> args, {
  String? workingDirectory,
  Map<String, String>? env,
}) async {
  final process = await Process.start(
    executable,
    args,
    workingDirectory: workingDirectory,
    environment: env,
    mode: .inheritStdio,
  );
  final resultCode = await process.exitCode;
  if (resultCode != 0) {
    throw ProcessException(executable, args, '', resultCode);
  }
}

enum LibcVariant { standalone, wasip1 }

Future<void> compileLibc(LibcVariant variant) async {
  switch (variant) {
    case LibcVariant.standalone:
      await runSubprocess('cargo', [
        '+nightly',
        'build',
        '--release',
        '-Zbuild-std=core,alloc,panic_abort',
        '-Zbuild-std-features=',
        '--target',
        'wasm32-unknown-unknown',
        '-p',
        'libc_standalone',
      ]);
    case LibcVariant.wasip1:
      await runSubprocess('cargo', [
        'build',
        '--release',
        '--target',
        'wasm32-wasip1',
        '-p',
        'libc_wasip1',
      ]);
  }
}
