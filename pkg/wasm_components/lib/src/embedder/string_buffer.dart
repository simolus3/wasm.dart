// ignore: import_internal_library
import 'dart:_wasm';

import 'string.dart';
import 'utils.dart';

final class WasmStringBuffer {
  _StringBuffer? _state;
  int _length = 0;

  int get length => _length;

  void writeCharCode(int charCode) {
    final isLatin1 = charCode <= 0xFF;

    if (isLatin1) {
      (_state ??= _Latin1Buffer()).writeLatin1CharCode(_length, charCode);
    } else {
      _ensureUtf16().writeCharCode(_length, charCode);
    }
    _length++;
  }

  void writeString(WasmStringImplementation string) {
    switch (string) {
      case Latin1String():
        (_state ??= _Latin1Buffer()).writeLatin1String(length, string);
        _length += string.length;
      case Utf16String():
        _ensureUtf16().writeUtf16String(length, string);
        _length += string.length;
    }
  }

  _Utf16Buffer _ensureUtf16() {
    return switch (_state) {
      null => (_state = _Utf16Buffer()),
      final _Latin1Buffer buffer => _state = buffer._toUtf16(),
      final _Utf16Buffer buffer => buffer,
    };
  }

  void clear() {
    _state = null;
    _length = 0;
  }

  WasmStringImplementation renderToString() {
    return switch (_state) {
      null => Latin1String.empty,
      final _Latin1Buffer buffer => Latin1String.fromAsciiBytes(
        buffer.buffer,
        const WasmI32(0),
        length.toWasmI32(),
      ),
      final _Utf16Buffer buffer => Utf16String.fromCharCodes(
        buffer.buffer,
        const WasmI32(0),
        length.toWasmI32(),
      ),
    };
  }
}

sealed class _StringBuffer {
  void writeLatin1String(int length, Latin1String string);
  void writeLatin1CharCode(int length, int charCode);
}

final class _Latin1Buffer extends _StringBuffer {
  WasmArray<WasmI8> buffer = WasmArray(_defaultBufferSize);

  _Utf16Buffer _toUtf16() {
    final length = buffer.length;
    final newBuffer = WasmArray<WasmI16>(length);
    _copyLatin1StringToUtf16(newBuffer, buffer, 0, 0, length);
    return _Utf16Buffer.custom(newBuffer);
  }

  @override
  void writeLatin1CharCode(int length, int charCode) {
    ensureCapacity(length, 1);
    buffer.write(length, charCode);
  }

  @override
  void writeLatin1String(int length, Latin1String string) {
    ensureCapacity(length, string.length);
    buffer.copyTyped(length, string.codeUnits, 0, string.length);
  }

  void ensureCapacity(int length, int additionalCapacity) {
    final currentCapacity = buffer.length;
    if (length + additionalCapacity <= currentCapacity) {
      return;
    }

    final newCapacity = 1 << (currentCapacity + additionalCapacity).bitLength;
    final newBuffer = WasmArray<WasmI8>(newCapacity);
    newBuffer.copyTyped(0, buffer, 0, length);
    buffer = newBuffer;
  }
}

final class _Utf16Buffer extends _StringBuffer {
  WasmArray<WasmI16> buffer;

  _Utf16Buffer() : buffer = WasmArray(_defaultBufferSize);

  _Utf16Buffer.custom(this.buffer);

  @override
  void writeLatin1CharCode(int length, int charCode) {
    writeCharCode(length, charCode);
  }

  @override
  void writeLatin1String(int length, Latin1String string) {
    ensureCapacity(length, string.length);
    _copyLatin1StringToUtf16(
      buffer,
      string.codeUnits,
      length,
      0,
      string.length,
    );
  }

  void writeCharCode(int length, int charCode) {
    ensureCapacity(length, 1);
    buffer.write(length, charCode);
  }

  void writeUtf16String(int length, Utf16String string) {
    ensureCapacity(length, string.length);
    buffer.copyTyped(length, string.codeUnits, 0, string.length);
  }

  void ensureCapacity(int length, int additionalCapacity) {
    final currentCapacity = buffer.length;
    if (length + additionalCapacity <= currentCapacity) {
      return;
    }

    final newCapacity = 1 << (currentCapacity + additionalCapacity).bitLength;
    final newBuffer = WasmArray<WasmI16>(newCapacity);
    newBuffer.copyTyped(0, buffer, 0, length);
    buffer = newBuffer;
  }
}

const _defaultBufferSize = 64;

void _copyLatin1StringToUtf16(
  WasmArray<WasmI16> target,
  WasmArray<WasmI8> source,
  int targetOffset,
  int sourceOffset,
  int length,
) {
  for (var i = 0; i < length; i++) {
    target.write(targetOffset + i, source.readUnsigned(sourceOffset + i));
  }
}
