/// The readable end of a future.
extension type RawFutureReadableEnd(int handle) {}

/// The writable end of a future.
extension type RawFutureWritableEnd(int handle) {}

(RawFutureReadableEnd, RawFutureWritableEnd) extractFutureHandlesFromPackedCode(
  int code,
) {
  final readableEnd = code.toUnsigned(32);
  final writableEnd = code >>> 32;

  return (RawFutureReadableEnd(readableEnd), RawFutureWritableEnd(writableEnd));
}

enum CopyResult { completed, dropped, cancelled }
