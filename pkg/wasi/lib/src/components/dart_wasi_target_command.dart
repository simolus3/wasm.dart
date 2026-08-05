// ignore_for_file: type=warning
import r'wasi_cli.dart' as i0;

// ignore: import_internal_library
import r'dart:_wasm' as i1;

import r'package:wasm_components/wasm_components.dart' as i2;

import r'dart:typed_data' as i3;

import r'wasi_clocks.dart' as i4;
import r'wasi_filesystem.dart' as i5;
import r'wasi_sockets.dart' as i6;
import r'wasi_random.dart' as i7;

@pragma("wasm:import", r"component._import0")
external i1.WasmVoid _import0(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import1")
external i1.WasmVoid _import1(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import2")
external i1.WasmVoid _import2(i1.WasmI32 p0);

final class _Imported$11 implements i0.Environment {
  const _Imported$11();
  @override
  List<(String, String)> getEnvironment() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import0(tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp9 = tmp2.toIntUnsigned();
    final tmp8 = List.generate(tmp1.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i1.WasmI32.fromInt(tmp9 + i * 16);
      final tmp3 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 0);
      final tmp4 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 4);
      final tmp5 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 8);
      final tmp6 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 12);
      final tmp7 = (
        i2.AllocatedString.read(tmp3, tmp4),
        i2.AllocatedString.read(tmp5, tmp6),
      );

      return tmp7;
    });

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  List<String> getArguments() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import1(tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp6 = tmp2.toIntUnsigned();
    final tmp5 = List.generate(tmp1.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i1.WasmI32.fromInt(tmp6 + i * 8);
      final tmp3 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 0);
      final tmp4 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 4);

      return i2.AllocatedString.read(tmp3, tmp4);
    });

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp5;
  }

  @override
  i2.Option<String> getInitialCwd() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(12));
    _import2(tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Option<String> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);

      tmp4 = .some(i2.AllocatedString.read(tmp2, tmp3));
    } else {
      tmp4 = .none;
    }

    i2.dartFree(tmp0, const i1.WasmI32(12), const i1.WasmI32(4));
    return tmp4;
  }
}

const i0.Environment importedInstance11 = _Imported$11();
@pragma("wasm:import", r"component._import3")
external i1.WasmVoid _import3(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import4")
external i1.WasmVoid _import4(i1.WasmI32 p0);

final class _Imported$12 implements i0.Exit {
  const _Imported$12();
  @override
  void exit({required i2.Result<void, void> status}) {
    i1.WasmI32 tmp0;
    switch (status) {
      case i2.OkResult(:final value):
        tmp0 = const i1.WasmI32(0);
      case i2.ErrorResult(:final value):
        tmp0 = const i1.WasmI32(1);
    }
    _import3(tmp0);
  }

  @override
  void exitWithCode({required int statusCode}) {
    _import4(i1.WasmI32.uint8FromInt(statusCode));
  }
}

const i0.Exit importedInstance12 = _Imported$12();

final class _Imported$14 implements i0.Types {
  const _Imported$14();
}

const i0.Types importedInstance14 = _Imported$14();

@pragma('wasm:import', 'component.stream89.new')
external i1.WasmI64 _streamNew89();
@pragma('wasm:import', 'component.stream89.read')
external i1.WasmI32 _streamRead89(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream89.write')
external i1.WasmI32 _streamWrite89(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream89.drop-readable')
external i1.WasmVoid _streamDropReadable89(i1.WasmI32 stream);
@pragma('wasm:import', 'component.stream89.drop-writable')
external i1.WasmVoid _streamDropWritable89(i1.WasmI32 stream);

final class _Vtable89 implements i2.StreamVtable<i3.Uint8List> {
  const _Vtable89();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i2
        .mallocAligned(const i1.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    i2.dartFree(
      address.toWasmI32(),
      (totalSize * 1).toWasmI32(),
      const i1.WasmI32(1),
    );
  }

  @override
  void writeToBuffer(int address, i3.Uint8List elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i1.WasmI32.fromInt(address + i);

      i2.memory.storeInt8(
        wasmAddress.toIntUnsigned(),
        i1.WasmI32.uint8FromInt(element),
        offset: 0,
      );
    }
  }

  @override
  i3.Uint8List readFromBuffer(int address, int count) {
    final typedList = i3.Uint8List(count);
    for (var i = 0; i < count; i++) {
      final ptr = i1.WasmI32.fromInt(address + i * 1);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);

      typedList[i] = tmp0.toIntUnsigned();
    }
    return typedList;
  }

  @override
  int newStream() => _streamNew89().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable89(i1.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable89(i1.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead89(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite89(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.future91.new')
external i1.WasmI64 _futureNew91();
@pragma('wasm:import', 'component.future91.write')
external i1.WasmI32 _futureWrite91(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future91.read')
external i1.WasmI32 _futureRead91(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future91.drop-readable')
external i1.WasmVoid _futureDropReadable91(i1.WasmI32 future);
@pragma('wasm:import', 'component.future91.drop-writable')
external i1.WasmVoid _futureDropWritable91(i1.WasmI32 future);

final class _Vtable91
    implements i2.FutureVtable<i2.Result<void, i0.TypesErrorCode>> {
  const _Vtable91();

  @override
  int newFuture() => _futureNew91().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead91(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite91(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable91(i1.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable91(i1.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i2
        .mallocAligned(const i1.WasmI32(1), const i1.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i2.dartFree(address.toWasmI32(), const i1.WasmI32(2), const i1.WasmI32(1));
  }

  @override
  void store(int address, i2.Result<void, i0.TypesErrorCode> value) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    switch (value) {
      case i2.OkResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );

      case i2.ErrorResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i2.Result<void, i0.TypesErrorCode> load(int address) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    final tmp0 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i2.Result<void, i0.TypesErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.TypesErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import15")
external i1.WasmVoid _import15(i1.WasmI32 p0);

final class _Imported$15 implements i0.Stdin {
  const _Imported$15();
  @override
  (Stream<i3.Uint8List>, Future<i2.Result<void, i0.TypesErrorCode>>)
  readViaStream() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import15(tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.ReadableStream(tmp1.toIntUnsigned(), const _Vtable89());
    final tmp3 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
    final tmp4 = i2.readFuture(const _Vtable91(), tmp3.toIntUnsigned());
    final tmp5 = (tmp2, tmp4);
    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp5;
  }
}

const i0.Stdin importedInstance15 = _Imported$15();

@pragma('wasm:import', 'component.future95.new')
external i1.WasmI64 _futureNew95();
@pragma('wasm:import', 'component.future95.write')
external i1.WasmI32 _futureWrite95(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future95.read')
external i1.WasmI32 _futureRead95(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future95.drop-readable')
external i1.WasmVoid _futureDropReadable95(i1.WasmI32 future);
@pragma('wasm:import', 'component.future95.drop-writable')
external i1.WasmVoid _futureDropWritable95(i1.WasmI32 future);

final class _Vtable95
    implements i2.FutureVtable<i2.Result<void, i0.TypesErrorCode>> {
  const _Vtable95();

  @override
  int newFuture() => _futureNew95().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead95(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite95(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable95(i1.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable95(i1.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i2
        .mallocAligned(const i1.WasmI32(1), const i1.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i2.dartFree(address.toWasmI32(), const i1.WasmI32(2), const i1.WasmI32(1));
  }

  @override
  void store(int address, i2.Result<void, i0.TypesErrorCode> value) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    switch (value) {
      case i2.OkResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );

      case i2.ErrorResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i2.Result<void, i0.TypesErrorCode> load(int address) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    final tmp0 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i2.Result<void, i0.TypesErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.TypesErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import21")
external i1.WasmI32 _import21(i1.WasmI32 p0);

final class _Imported$16 implements i0.Stdout {
  const _Imported$16();
  @override
  Future<i2.Result<void, i0.TypesErrorCode>> writeViaStream({
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i2.newReadableStream(const _Vtable89(), data).toWasmI32();
    final tmp1 = _import21(tmp0);
    final tmp2 = i2.readFuture(const _Vtable95(), tmp1.toIntUnsigned());
    return tmp2;
  }
}

const i0.Stdout importedInstance16 = _Imported$16();

@pragma('wasm:import', 'component.future98.new')
external i1.WasmI64 _futureNew98();
@pragma('wasm:import', 'component.future98.write')
external i1.WasmI32 _futureWrite98(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future98.read')
external i1.WasmI32 _futureRead98(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future98.drop-readable')
external i1.WasmVoid _futureDropReadable98(i1.WasmI32 future);
@pragma('wasm:import', 'component.future98.drop-writable')
external i1.WasmVoid _futureDropWritable98(i1.WasmI32 future);

final class _Vtable98
    implements i2.FutureVtable<i2.Result<void, i0.TypesErrorCode>> {
  const _Vtable98();

  @override
  int newFuture() => _futureNew98().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead98(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite98(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable98(i1.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable98(i1.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i2
        .mallocAligned(const i1.WasmI32(1), const i1.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i2.dartFree(address.toWasmI32(), const i1.WasmI32(2), const i1.WasmI32(1));
  }

  @override
  void store(int address, i2.Result<void, i0.TypesErrorCode> value) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    switch (value) {
      case i2.OkResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );

      case i2.ErrorResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i2.Result<void, i0.TypesErrorCode> load(int address) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    final tmp0 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i2.Result<void, i0.TypesErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.TypesErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import27")
external i1.WasmI32 _import27(i1.WasmI32 p0);

final class _Imported$17 implements i0.Stderr {
  const _Imported$17();
  @override
  Future<i2.Result<void, i0.TypesErrorCode>> writeViaStream({
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i2.newReadableStream(const _Vtable89(), data).toWasmI32();
    final tmp1 = _import27(tmp0);
    final tmp2 = i2.readFuture(const _Vtable98(), tmp1.toIntUnsigned());
    return tmp2;
  }
}

const i0.Stderr importedInstance17 = _Imported$17();

final class _Imported$18 implements i0.TerminalInput {
  const _Imported$18();
}

const i0.TerminalInput importedInstance18 = _Imported$18();

final class _Imported$19 implements i0.TerminalOutput {
  const _Imported$19();
}

const i0.TerminalOutput importedInstance19 = _Imported$19();
@pragma("wasm:import", r"component._import28")
external i1.WasmVoid _import28(i1.WasmI32 p0);

final class _Imported$20 implements i0.TerminalStdin {
  const _Imported$20();
  @override
  i2.Option<i2.Owned<i0.TerminalInputTerminalInput>> getTerminalStdin() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import28(tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Option<i2.Owned<i0.TerminalInputTerminalInput>> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.Owned<i0.TerminalInputTerminalInput>(
        tmp2.toIntUnsigned(),
      );
      tmp4 = .some(tmp3);
    } else {
      tmp4 = .none;
    }

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp4;
  }
}

const i0.TerminalStdin importedInstance20 = _Imported$20();
@pragma("wasm:import", r"component._import29")
external i1.WasmVoid _import29(i1.WasmI32 p0);

final class _Imported$21 implements i0.TerminalStdout {
  const _Imported$21();
  @override
  i2.Option<i2.Owned<i0.TerminalOutputTerminalOutput>> getTerminalStdout() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import29(tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Option<i2.Owned<i0.TerminalOutputTerminalOutput>> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.Owned<i0.TerminalOutputTerminalOutput>(
        tmp2.toIntUnsigned(),
      );
      tmp4 = .some(tmp3);
    } else {
      tmp4 = .none;
    }

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp4;
  }
}

const i0.TerminalStdout importedInstance21 = _Imported$21();
@pragma("wasm:import", r"component._import30")
external i1.WasmVoid _import30(i1.WasmI32 p0);

final class _Imported$22 implements i0.TerminalStderr {
  const _Imported$22();
  @override
  i2.Option<i2.Owned<i0.TerminalOutputTerminalOutput>> getTerminalStderr() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import30(tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Option<i2.Owned<i0.TerminalOutputTerminalOutput>> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.Owned<i0.TerminalOutputTerminalOutput>(
        tmp2.toIntUnsigned(),
      );
      tmp4 = .some(tmp3);
    } else {
      tmp4 = .none;
    }

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp4;
  }
}

const i0.TerminalStderr importedInstance22 = _Imported$22();

final class _Imported$0 implements i4.Types {
  const _Imported$0();
}

const i4.Types importedInstance0 = _Imported$0();
@pragma("wasm:import", r"component._import31")
external i1.WasmI64 _import31();
@pragma("wasm:import", r"component._import32")
external i1.WasmI64 _import32();
@pragma("wasm:import", r"component._import33")
external i1.WasmI32 _import33(i1.WasmI64 p0);
@pragma("wasm:import", r"component._import34")
external i1.WasmI32 _import34(i1.WasmI64 p0);

final class _Imported$1 implements i4.MonotonicClock {
  const _Imported$1();
  @override
  int now() {
    final tmp0 = _import31();
    return tmp0.toInt();
  }

  @override
  int getResolution() {
    final tmp0 = _import32();
    return tmp0.toInt();
  }

  @override
  Future<void> waitUntil({required int when}) async {
    await i2.createSubtask(_import33(i1.WasmI64.fromInt(when))).completion;
  }

  @override
  Future<void> waitFor({required int howLong}) async {
    await i2.createSubtask(_import34(i1.WasmI64.fromInt(howLong))).completion;
  }
}

const i4.MonotonicClock importedInstance1 = _Imported$1();
@pragma("wasm:import", r"component._import35")
external i1.WasmVoid _import35(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import36")
external i1.WasmI64 _import36();

final class _Imported$2 implements i4.SystemClock {
  const _Imported$2();
  @override
  ({int seconds, int nanoseconds}) now() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(16));
    _import35(tmp0);
    final tmp1 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);
    final tmp3 = (seconds: tmp1.toInt(), nanoseconds: tmp2.toIntUnsigned());
    i2.dartFree(tmp0, const i1.WasmI32(16), const i1.WasmI32(8));
    return tmp3;
  }

  @override
  int getResolution() {
    final tmp0 = _import36();
    return tmp0.toInt();
  }
}

const i4.SystemClock importedInstance2 = _Imported$2();

@pragma('wasm:import', 'component.stream25.new')
external i1.WasmI64 _streamNew25();
@pragma('wasm:import', 'component.stream25.read')
external i1.WasmI32 _streamRead25(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream25.write')
external i1.WasmI32 _streamWrite25(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream25.drop-readable')
external i1.WasmVoid _streamDropReadable25(i1.WasmI32 stream);
@pragma('wasm:import', 'component.stream25.drop-writable')
external i1.WasmVoid _streamDropWritable25(i1.WasmI32 stream);

final class _Vtable25 implements i2.StreamVtable<i3.Uint8List> {
  const _Vtable25();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i2
        .mallocAligned(const i1.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    i2.dartFree(
      address.toWasmI32(),
      (totalSize * 1).toWasmI32(),
      const i1.WasmI32(1),
    );
  }

  @override
  void writeToBuffer(int address, i3.Uint8List elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i1.WasmI32.fromInt(address + i);

      i2.memory.storeInt8(
        wasmAddress.toIntUnsigned(),
        i1.WasmI32.uint8FromInt(element),
        offset: 0,
      );
    }
  }

  @override
  i3.Uint8List readFromBuffer(int address, int count) {
    final typedList = i3.Uint8List(count);
    for (var i = 0; i < count; i++) {
      final ptr = i1.WasmI32.fromInt(address + i * 1);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);

      typedList[i] = tmp0.toIntUnsigned();
    }
    return typedList;
  }

  @override
  int newStream() => _streamNew25().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable25(i1.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable25(i1.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead25(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite25(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.future27.new')
external i1.WasmI64 _futureNew27();
@pragma('wasm:import', 'component.future27.write')
external i1.WasmI32 _futureWrite27(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future27.read')
external i1.WasmI32 _futureRead27(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future27.drop-readable')
external i1.WasmVoid _futureDropReadable27(i1.WasmI32 future);
@pragma('wasm:import', 'component.future27.drop-writable')
external i1.WasmVoid _futureDropWritable27(i1.WasmI32 future);

final class _Vtable27
    implements i2.FutureVtable<i2.Result<void, i5.TypesErrorCode>> {
  const _Vtable27();

  @override
  int newFuture() => _futureNew27().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead27(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite27(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable27(i1.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable27(i1.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i2
        .mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    if (containsValue) {
      final ptr = i1.WasmI32.fromInt(address);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);
      switch (tmp0) {
        case 0:
          break;
        case 1:
          final tmp1 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 4);
          switch (tmp1) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
            case 5:
              break;
            case 6:
              break;
            case 7:
              break;
            case 8:
              break;
            case 9:
              break;
            case 10:
              break;
            case 11:
              break;
            case 12:
              break;
            case 13:
              break;
            case 14:
              break;
            case 15:
              break;
            case 16:
              break;
            case 17:
              break;
            case 18:
              break;
            case 19:
              break;
            case 20:
              break;
            case 21:
              break;
            case 22:
              break;
            case 23:
              break;
            case 24:
              break;
            case 25:
              break;
            case 26:
              break;
            case 27:
              break;
            case 28:
              break;
            case 29:
              break;
            case 30:
              break;
            case 31:
              break;
            case 32:
              break;
            case 33:
              break;
            case 34:
              break;
            case 35:
              break;
            case 36:
              final tmp2 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 8);
              switch (tmp2) {
                case 0:
                  break;
                case 1:
                  final tmp3 = i2.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 12,
                  );
                  final tmp4 = i2.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 16,
                  );
                  i2.AllocatedString(tmp3, tmp4).free();
                  break;
              }
              break;
          }
          break;
      }
    }
    i2.dartFree(address.toWasmI32(), const i1.WasmI32(20), const i1.WasmI32(4));
  }

  @override
  void store(int address, i2.Result<void, i5.TypesErrorCode> value) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    switch (value) {
      case i2.OkResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );

      case i2.ErrorResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        switch (value) {
          case i5.TypesErrorCodeAccess():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(0),
              offset: 4,
            );
          case i5.TypesErrorCodeAlready():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(1),
              offset: 4,
            );
          case i5.TypesErrorCodeBadDescriptor():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(2),
              offset: 4,
            );
          case i5.TypesErrorCodeBusy():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(3),
              offset: 4,
            );
          case i5.TypesErrorCodeDeadlock():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(4),
              offset: 4,
            );
          case i5.TypesErrorCodeQuota():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(5),
              offset: 4,
            );
          case i5.TypesErrorCodeExist():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(6),
              offset: 4,
            );
          case i5.TypesErrorCodeFileTooLarge():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(7),
              offset: 4,
            );
          case i5.TypesErrorCodeIllegalByteSequence():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(8),
              offset: 4,
            );
          case i5.TypesErrorCodeInProgress():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(9),
              offset: 4,
            );
          case i5.TypesErrorCodeInterrupted():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(10),
              offset: 4,
            );
          case i5.TypesErrorCodeInvalid():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(11),
              offset: 4,
            );
          case i5.TypesErrorCodeIo():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(12),
              offset: 4,
            );
          case i5.TypesErrorCodeIsDirectory():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(13),
              offset: 4,
            );
          case i5.TypesErrorCodeLoop():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(14),
              offset: 4,
            );
          case i5.TypesErrorCodeTooManyLinks():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(15),
              offset: 4,
            );
          case i5.TypesErrorCodeMessageSize():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(16),
              offset: 4,
            );
          case i5.TypesErrorCodeNameTooLong():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(17),
              offset: 4,
            );
          case i5.TypesErrorCodeNoDevice():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(18),
              offset: 4,
            );
          case i5.TypesErrorCodeNoEntry():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(19),
              offset: 4,
            );
          case i5.TypesErrorCodeNoLock():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(20),
              offset: 4,
            );
          case i5.TypesErrorCodeInsufficientMemory():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(21),
              offset: 4,
            );
          case i5.TypesErrorCodeInsufficientSpace():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(22),
              offset: 4,
            );
          case i5.TypesErrorCodeNotDirectory():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(23),
              offset: 4,
            );
          case i5.TypesErrorCodeNotEmpty():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(24),
              offset: 4,
            );
          case i5.TypesErrorCodeNotRecoverable():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(25),
              offset: 4,
            );
          case i5.TypesErrorCodeUnsupported():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(26),
              offset: 4,
            );
          case i5.TypesErrorCodeNoTty():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(27),
              offset: 4,
            );
          case i5.TypesErrorCodeNoSuchDevice():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(28),
              offset: 4,
            );
          case i5.TypesErrorCodeOverflow():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(29),
              offset: 4,
            );
          case i5.TypesErrorCodeNotPermitted():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(30),
              offset: 4,
            );
          case i5.TypesErrorCodePipe():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(31),
              offset: 4,
            );
          case i5.TypesErrorCodeReadOnly():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(32),
              offset: 4,
            );
          case i5.TypesErrorCodeInvalidSeek():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(33),
              offset: 4,
            );
          case i5.TypesErrorCodeTextFileBusy():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(34),
              offset: 4,
            );
          case i5.TypesErrorCodeCrossDevice():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(35),
              offset: 4,
            );
          case i5.TypesErrorCodeOther(payload: final value):
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(36),
              offset: 4,
            );
            final tmp1 = value;
            if (tmp1.hasValue) {
              final value = tmp1.requireValue();
              i2.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i1.WasmI32(1),
                offset: 8,
              );
              final tmp0 = i2.AllocatedString.allocateUtf16(value);
              i2.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp0.packedLength,
                offset: 16,
              );
              i2.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp0.ptr,
                offset: 12,
              );
            } else {
              i2.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i1.WasmI32(0),
                offset: 8,
              );
            }
        }
    }
  }

  @override
  i2.Result<void, i5.TypesErrorCode> load(int address) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    final tmp0 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp7;
    if (tmp0.toBool()) {
      final tmp1 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp6;
      switch (tmp1.toIntUnsigned()) {
        case 0:
          tmp6 = i5.TypesErrorCodeAccess();
        case 1:
          tmp6 = i5.TypesErrorCodeAlready();
        case 2:
          tmp6 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp6 = i5.TypesErrorCodeBusy();
        case 4:
          tmp6 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp6 = i5.TypesErrorCodeQuota();
        case 6:
          tmp6 = i5.TypesErrorCodeExist();
        case 7:
          tmp6 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp6 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp6 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp6 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp6 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp6 = i5.TypesErrorCodeIo();
        case 13:
          tmp6 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp6 = i5.TypesErrorCodeLoop();
        case 15:
          tmp6 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp6 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp6 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp6 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp6 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp6 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp6 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp6 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp6 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp6 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp6 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp6 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp6 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp6 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp6 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp6 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp6 = i5.TypesErrorCodePipe();
        case 32:
          tmp6 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp6 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp6 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp6 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp2 = i2.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 8,
          );
          final i2.Option<String> tmp5;
          if (tmp2.toBool()) {
            final tmp3 = i2.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 12,
            );
            final tmp4 = i2.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 16,
            );

            tmp5 = .some(i2.AllocatedString.read(tmp3, tmp4));
          } else {
            tmp5 = .none;
          }

          tmp6 = i5.TypesErrorCodeOther(tmp5);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp7 = .error(tmp6);
    } else {
      tmp7 = .ok(null);
    }

    return tmp7;
  }
}

@pragma('wasm:import', 'component.stream31.new')
external i1.WasmI64 _streamNew31();
@pragma('wasm:import', 'component.stream31.read')
external i1.WasmI32 _streamRead31(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream31.write')
external i1.WasmI32 _streamWrite31(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream31.drop-readable')
external i1.WasmVoid _streamDropReadable31(i1.WasmI32 stream);
@pragma('wasm:import', 'component.stream31.drop-writable')
external i1.WasmVoid _streamDropWritable31(i1.WasmI32 stream);

final class _Vtable31
    implements
        i2.StreamVtable<List<({i5.TypesDescriptorType type, String name})>> {
  const _Vtable31();

  @override
  int get elementSize => 24;
  @override
  int allocateBuffer(int size) {
    return i2
        .mallocAligned(const i1.WasmI32(4), (size * 24).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    for (var i = start; i < end; i++) {
      final ptr = i1.WasmI32.fromInt(address + i * 24);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);
      switch (tmp0) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 4:
          break;
        case 5:
          break;
        case 6:
          break;
        case 7:
          final tmp1 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 4);
          switch (tmp1) {
            case 0:
              break;
            case 1:
              final tmp2 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 8);
              final tmp3 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 12);
              i2.AllocatedString(tmp2, tmp3).free();
              break;
          }
          break;
      }
      final tmp4 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 16);
      final tmp5 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 20);
      i2.AllocatedString(tmp4, tmp5).free();
    }

    i2.dartFree(
      address.toWasmI32(),
      (totalSize * 24).toWasmI32(),
      const i1.WasmI32(4),
    );
  }

  @override
  void writeToBuffer(
    int address,
    List<({i5.TypesDescriptorType type, String name})> elements,
  ) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i1.WasmI32.fromInt(address + i);

      switch (element.type) {
        case i5.TypesDescriptorTypeBlockDevice():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(0),
            offset: 0,
          );
        case i5.TypesDescriptorTypeCharacterDevice():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(1),
            offset: 0,
          );
        case i5.TypesDescriptorTypeDirectory():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(2),
            offset: 0,
          );
        case i5.TypesDescriptorTypeFifo():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(3),
            offset: 0,
          );
        case i5.TypesDescriptorTypeSymbolicLink():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(4),
            offset: 0,
          );
        case i5.TypesDescriptorTypeRegularFile():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(5),
            offset: 0,
          );
        case i5.TypesDescriptorTypeSocket():
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(6),
            offset: 0,
          );
        case i5.TypesDescriptorTypeOther(payload: final value):
          i2.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i1.WasmI32(7),
            offset: 0,
          );
          final tmp1 = value;
          if (tmp1.hasValue) {
            final value = tmp1.requireValue();
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(1),
              offset: 4,
            );
            final tmp0 = i2.AllocatedString.allocateUtf16(value);
            i2.memory.storeInt32(
              wasmAddress.toIntUnsigned(),
              tmp0.packedLength,
              offset: 12,
            );
            i2.memory.storeInt32(
              wasmAddress.toIntUnsigned(),
              tmp0.ptr,
              offset: 8,
            );
          } else {
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(0),
              offset: 4,
            );
          }
      }
      final tmp2 = i2.AllocatedString.allocateUtf16(element.name);
      i2.memory.storeInt32(
        wasmAddress.toIntUnsigned(),
        tmp2.packedLength,
        offset: 20,
      );
      i2.memory.storeInt32(wasmAddress.toIntUnsigned(), tmp2.ptr, offset: 16);
    }
  }

  @override
  List<({i5.TypesDescriptorType type, String name})> readFromBuffer(
    int address,
    int count,
  ) {
    return List.generate(count, (i) {
      final ptr = i1.WasmI32.fromInt(address + i * 24);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);
      final i5.TypesDescriptorType tmp5;
      switch (tmp0.toIntUnsigned()) {
        case 0:
          tmp5 = i5.TypesDescriptorTypeBlockDevice();
        case 1:
          tmp5 = i5.TypesDescriptorTypeCharacterDevice();
        case 2:
          tmp5 = i5.TypesDescriptorTypeDirectory();
        case 3:
          tmp5 = i5.TypesDescriptorTypeFifo();
        case 4:
          tmp5 = i5.TypesDescriptorTypeSymbolicLink();
        case 5:
          tmp5 = i5.TypesDescriptorTypeRegularFile();
        case 6:
          tmp5 = i5.TypesDescriptorTypeSocket();
        case 7:
          final tmp1 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 4);
          final i2.Option<String> tmp4;
          if (tmp1.toBool()) {
            final tmp2 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 8);
            final tmp3 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 12);

            tmp4 = .some(i2.AllocatedString.read(tmp2, tmp3));
          } else {
            tmp4 = .none;
          }

          tmp5 = i5.TypesDescriptorTypeOther(tmp4);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }
      final tmp6 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 16);
      final tmp7 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 20);
      final tmp8 = (type: tmp5, name: i2.AllocatedString.read(tmp6, tmp7));

      return tmp8;
    });
  }

  @override
  int newStream() => _streamNew31().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable31(i1.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable31(i1.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead31(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite31(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma("wasm:import", r"component._import52")
external i1.WasmVoid _import52(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import53")
external i1.WasmI32 _import53(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI64 p2);
@pragma("wasm:import", r"component._import54")
external i1.WasmI32 _import54(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import55")
external i1.WasmI32 _import55(
  i1.WasmI32 p0,
  i1.WasmI64 p1,
  i1.WasmI64 p2,
  i1.WasmI32 p3,
  i1.WasmI32 p4,
);
@pragma("wasm:import", r"component._import56")
external i1.WasmI32 _import56(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import57")
external i1.WasmI32 _import57(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import58")
external i1.WasmI32 _import58(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import59")
external i1.WasmI32 _import59(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import60")
external i1.WasmI32 _import60(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import61")
external i1.WasmVoid _import61(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import62")
external i1.WasmI32 _import62(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import63")
external i1.WasmI32 _import63(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
);
@pragma("wasm:import", r"component._import64")
external i1.WasmI32 _import64(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import65")
external i1.WasmI32 _import65(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
  i1.WasmI32 p4,
);
@pragma("wasm:import", r"component._import66")
external i1.WasmI32 _import66(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import67")
external i1.WasmI32 _import67(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import68")
external i1.WasmI32 _import68(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import69")
external i1.WasmI32 _import69(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
);
@pragma("wasm:import", r"component._import70")
external i1.WasmI32 _import70(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
);
@pragma("wasm:import", r"component._import71")
external i1.WasmI32 _import71(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import72")
external i1.WasmI32 _import72(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import73")
external i1.WasmI32 _import73(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
);
@pragma("wasm:import", r"component._import74")
external i1.WasmI32 _import74(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import75")
external i1.WasmI32 _import75(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import76")
external i1.WasmI32 _import76(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
  i1.WasmI32 p4,
);

final class _Imported$4 implements i5.Types {
  const _Imported$4();
  @override
  (Stream<i3.Uint8List>, Future<i2.Result<void, i5.TypesErrorCode>>)
  methodDescriptorReadViaStream({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required int offset,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import52(self.handle.toWasmI32(), i1.WasmI64.fromInt(offset), tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.ReadableStream(tmp1.toIntUnsigned(), const _Vtable25());
    final tmp3 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
    final tmp4 = i2.readFuture(const _Vtable27(), tmp3.toIntUnsigned());
    final tmp5 = (tmp2, tmp4);
    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp5;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorWriteViaStream({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required Stream<i3.Uint8List> data,
    required int offset,
  }) {
    final tmp0 = i2.newReadableStream(const _Vtable25(), data).toWasmI32();
    final tmp1 = _import53(
      self.handle.toWasmI32(),
      tmp0,
      i1.WasmI64.fromInt(offset),
    );
    final tmp2 = i2.readFuture(const _Vtable27(), tmp1.toIntUnsigned());
    return tmp2;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorAppendViaStream({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i2.newReadableStream(const _Vtable25(), data).toWasmI32();
    final tmp1 = _import54(self.handle.toWasmI32(), tmp0);
    final tmp2 = i2.readFuture(const _Vtable27(), tmp1.toIntUnsigned());
    return tmp2;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorAdvise({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required int offset,
    required int length,
    required i5.TypesAdvice advice,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(
          _import55(
            self.handle.toWasmI32(),
            i1.WasmI64.fromInt(offset),
            i1.WasmI64.fromInt(length),
            advice.index.toWasmI32(),
            tmp0,
          ),
        )
        .completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i5.TypesErrorCodeAccess();
        case 1:
          tmp7 = i5.TypesErrorCodeAlready();
        case 2:
          tmp7 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp7 = i5.TypesErrorCodeBusy();
        case 4:
          tmp7 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp7 = i5.TypesErrorCodeQuota();
        case 6:
          tmp7 = i5.TypesErrorCodeExist();
        case 7:
          tmp7 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp7 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp7 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp7 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp7 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp7 = i5.TypesErrorCodeIo();
        case 13:
          tmp7 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp7 = i5.TypesErrorCodeLoop();
        case 15:
          tmp7 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp7 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp7 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp7 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp7 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp7 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp7 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp7 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp7 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp7 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp7 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp7 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp7 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp7 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp7 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp7 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp7 = i5.TypesErrorCodePipe();
        case 32:
          tmp7 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp7 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp7 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp7 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i5.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorSyncData({
    required i2.Borrowed<i5.TypesDescriptor> self,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import56(self.handle.toWasmI32(), tmp0)).completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i5.TypesErrorCodeAccess();
        case 1:
          tmp7 = i5.TypesErrorCodeAlready();
        case 2:
          tmp7 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp7 = i5.TypesErrorCodeBusy();
        case 4:
          tmp7 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp7 = i5.TypesErrorCodeQuota();
        case 6:
          tmp7 = i5.TypesErrorCodeExist();
        case 7:
          tmp7 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp7 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp7 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp7 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp7 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp7 = i5.TypesErrorCodeIo();
        case 13:
          tmp7 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp7 = i5.TypesErrorCodeLoop();
        case 15:
          tmp7 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp7 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp7 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp7 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp7 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp7 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp7 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp7 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp7 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp7 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp7 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp7 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp7 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp7 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp7 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp7 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp7 = i5.TypesErrorCodePipe();
        case 32:
          tmp7 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp7 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp7 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp7 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i5.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  Future<i2.Result<i5.TypesDescriptorFlags, i5.TypesErrorCode>>
  methodDescriptorGetFlags({
    required i2.Borrowed<i5.TypesDescriptor> self,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import57(self.handle.toWasmI32(), tmp0)).completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i5.TypesDescriptorFlags, i5.TypesErrorCode> tmp10;
    if (tmp1.toBool()) {
      final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp9;
      switch (tmp4.toIntUnsigned()) {
        case 0:
          tmp9 = i5.TypesErrorCodeAccess();
        case 1:
          tmp9 = i5.TypesErrorCodeAlready();
        case 2:
          tmp9 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp9 = i5.TypesErrorCodeBusy();
        case 4:
          tmp9 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp9 = i5.TypesErrorCodeQuota();
        case 6:
          tmp9 = i5.TypesErrorCodeExist();
        case 7:
          tmp9 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp9 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp9 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp9 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp9 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp9 = i5.TypesErrorCodeIo();
        case 13:
          tmp9 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp9 = i5.TypesErrorCodeLoop();
        case 15:
          tmp9 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp9 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp9 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp9 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp9 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp9 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp9 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp9 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp9 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp9 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp9 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp9 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp9 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp9 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp9 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp9 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp9 = i5.TypesErrorCodePipe();
        case 32:
          tmp9 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp9 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp9 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp9 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp8;
          if (tmp5.toBool()) {
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp7 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp8 = .some(i2.AllocatedString.read(tmp6, tmp7));
          } else {
            tmp8 = .none;
          }

          tmp9 = i5.TypesErrorCodeOther(tmp8);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp10 = .error(tmp9);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i5.TypesDescriptorFlags(tmp2.toIntUnsigned());

      tmp10 = .ok(tmp3);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp10;
  }

  @override
  Future<i2.Result<i5.TypesDescriptorType, i5.TypesErrorCode>>
  methodDescriptorGetType({
    required i2.Borrowed<i5.TypesDescriptor> self,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import58(self.handle.toWasmI32(), tmp0)).completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i5.TypesDescriptorType, i5.TypesErrorCode> tmp14;
    if (tmp1.toBool()) {
      final tmp8 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp13;
      switch (tmp8.toIntUnsigned()) {
        case 0:
          tmp13 = i5.TypesErrorCodeAccess();
        case 1:
          tmp13 = i5.TypesErrorCodeAlready();
        case 2:
          tmp13 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp13 = i5.TypesErrorCodeBusy();
        case 4:
          tmp13 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp13 = i5.TypesErrorCodeQuota();
        case 6:
          tmp13 = i5.TypesErrorCodeExist();
        case 7:
          tmp13 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp13 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp13 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp13 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp13 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp13 = i5.TypesErrorCodeIo();
        case 13:
          tmp13 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp13 = i5.TypesErrorCodeLoop();
        case 15:
          tmp13 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp13 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp13 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp13 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp13 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp13 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp13 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp13 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp13 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp13 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp13 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp13 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp13 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp13 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp13 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp13 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp13 = i5.TypesErrorCodePipe();
        case 32:
          tmp13 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp13 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp13 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp13 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp9 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp12;
          if (tmp9.toBool()) {
            final tmp10 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp11 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp12 = .some(i2.AllocatedString.read(tmp10, tmp11));
          } else {
            tmp12 = .none;
          }

          tmp13 = i5.TypesErrorCodeOther(tmp12);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp14 = .error(tmp13);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesDescriptorType tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i5.TypesDescriptorTypeBlockDevice();
        case 1:
          tmp7 = i5.TypesDescriptorTypeCharacterDevice();
        case 2:
          tmp7 = i5.TypesDescriptorTypeDirectory();
        case 3:
          tmp7 = i5.TypesDescriptorTypeFifo();
        case 4:
          tmp7 = i5.TypesDescriptorTypeSymbolicLink();
        case 5:
          tmp7 = i5.TypesDescriptorTypeRegularFile();
        case 6:
          tmp7 = i5.TypesDescriptorTypeSocket();
        case 7:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i5.TypesDescriptorTypeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp14 = .ok(tmp7);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp14;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorSetSize({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required int size,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(
          _import59(self.handle.toWasmI32(), i1.WasmI64.fromInt(size), tmp0),
        )
        .completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i5.TypesErrorCodeAccess();
        case 1:
          tmp7 = i5.TypesErrorCodeAlready();
        case 2:
          tmp7 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp7 = i5.TypesErrorCodeBusy();
        case 4:
          tmp7 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp7 = i5.TypesErrorCodeQuota();
        case 6:
          tmp7 = i5.TypesErrorCodeExist();
        case 7:
          tmp7 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp7 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp7 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp7 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp7 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp7 = i5.TypesErrorCodeIo();
        case 13:
          tmp7 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp7 = i5.TypesErrorCodeLoop();
        case 15:
          tmp7 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp7 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp7 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp7 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp7 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp7 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp7 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp7 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp7 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp7 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp7 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp7 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp7 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp7 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp7 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp7 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp7 = i5.TypesErrorCodePipe();
        case 32:
          tmp7 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp7 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp7 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp7 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i5.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorSetTimes({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i5.TypesNewTimestamp dataAccessTimestamp,
    required i5.TypesNewTimestamp dataModificationTimestamp,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(56));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    switch (dataAccessTimestamp) {
      case i5.TypesNewTimestampNoChange():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );
      case i5.TypesNewTimestampNow():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
      case i5.TypesNewTimestampTimestamp(payload: final value):
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
          const i1.WasmI32(2),
          offset: 0,
        );
        i2.memory.storeInt64(
          (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
          i1.WasmI64.fromInt(value.seconds),
          offset: 8,
        );
        i2.memory.storeInt32(
          (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
          i1.WasmI32.fromInt(value.nanoseconds),
          offset: 16,
        );
    }
    switch (dataModificationTimestamp) {
      case i5.TypesNewTimestampNoChange():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(32)).toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );
      case i5.TypesNewTimestampNow():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(32)).toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
      case i5.TypesNewTimestampTimestamp(payload: final value):
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(32)).toIntUnsigned(),
          const i1.WasmI32(2),
          offset: 0,
        );
        i2.memory.storeInt64(
          (tmp0 + const i1.WasmI32(32)).toIntUnsigned(),
          i1.WasmI64.fromInt(value.seconds),
          offset: 8,
        );
        i2.memory.storeInt32(
          (tmp0 + const i1.WasmI32(32)).toIntUnsigned(),
          i1.WasmI32.fromInt(value.nanoseconds),
          offset: 16,
        );
    }
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import60(tmp0, tmp1)).completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp9;
    if (tmp2.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i5.TypesErrorCodeAccess();
        case 1:
          tmp8 = i5.TypesErrorCodeAlready();
        case 2:
          tmp8 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp8 = i5.TypesErrorCodeBusy();
        case 4:
          tmp8 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp8 = i5.TypesErrorCodeQuota();
        case 6:
          tmp8 = i5.TypesErrorCodeExist();
        case 7:
          tmp8 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp8 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp8 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp8 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp8 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp8 = i5.TypesErrorCodeIo();
        case 13:
          tmp8 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp8 = i5.TypesErrorCodeLoop();
        case 15:
          tmp8 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp8 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp8 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp8 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp8 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp8 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp8 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp8 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp8 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp8 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp8 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp8 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp8 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp8 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp8 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp8 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp8 = i5.TypesErrorCodePipe();
        case 32:
          tmp8 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp8 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp8 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp8 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp4 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i5.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      tmp9 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(56), const i1.WasmI32(8));
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  (
    Stream<List<({i5.TypesDescriptorType type, String name})>>,
    Future<i2.Result<void, i5.TypesErrorCode>>,
  )
  methodDescriptorReadDirectory({
    required i2.Borrowed<i5.TypesDescriptor> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import61(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.ReadableStream(tmp1.toIntUnsigned(), const _Vtable31());
    final tmp3 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
    final tmp4 = i2.readFuture(const _Vtable27(), tmp3.toIntUnsigned());
    final tmp5 = (tmp2, tmp4);
    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp5;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorSync({
    required i2.Borrowed<i5.TypesDescriptor> self,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import62(self.handle.toWasmI32(), tmp0)).completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i5.TypesErrorCodeAccess();
        case 1:
          tmp7 = i5.TypesErrorCodeAlready();
        case 2:
          tmp7 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp7 = i5.TypesErrorCodeBusy();
        case 4:
          tmp7 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp7 = i5.TypesErrorCodeQuota();
        case 6:
          tmp7 = i5.TypesErrorCodeExist();
        case 7:
          tmp7 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp7 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp7 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp7 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp7 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp7 = i5.TypesErrorCodeIo();
        case 13:
          tmp7 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp7 = i5.TypesErrorCodeLoop();
        case 15:
          tmp7 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp7 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp7 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp7 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp7 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp7 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp7 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp7 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp7 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp7 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp7 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp7 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp7 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp7 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp7 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp7 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp7 = i5.TypesErrorCodePipe();
        case 32:
          tmp7 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp7 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp7 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp7 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i5.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorCreateDirectoryAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required String path,
  }) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(path);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(
          _import63(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1),
        )
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp9;
    if (tmp2.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i5.TypesErrorCodeAccess();
        case 1:
          tmp8 = i5.TypesErrorCodeAlready();
        case 2:
          tmp8 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp8 = i5.TypesErrorCodeBusy();
        case 4:
          tmp8 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp8 = i5.TypesErrorCodeQuota();
        case 6:
          tmp8 = i5.TypesErrorCodeExist();
        case 7:
          tmp8 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp8 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp8 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp8 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp8 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp8 = i5.TypesErrorCodeIo();
        case 13:
          tmp8 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp8 = i5.TypesErrorCodeLoop();
        case 15:
          tmp8 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp8 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp8 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp8 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp8 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp8 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp8 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp8 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp8 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp8 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp8 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp8 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp8 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp8 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp8 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp8 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp8 = i5.TypesErrorCodePipe();
        case 32:
          tmp8 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp8 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp8 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp8 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp4 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i5.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      tmp9 = .ok(null);
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  Future<
    i2.Result<
      ({
        i5.TypesDescriptorType type,
        int linkCount,
        int size,
        i2.Option<({int seconds, int nanoseconds})> dataAccessTimestamp,
        i2.Option<({int seconds, int nanoseconds})> dataModificationTimestamp,
        i2.Option<({int seconds, int nanoseconds})> statusChangeTimestamp,
      }),
      i5.TypesErrorCode
    >
  >
  methodDescriptorStat({required i2.Borrowed<i5.TypesDescriptor> self}) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(112));
    await i2.createSubtask(_import64(self.handle.toWasmI32(), tmp0)).completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<
      ({
        i5.TypesDescriptorType type,
        int linkCount,
        int size,
        i2.Option<({int seconds, int nanoseconds})> dataAccessTimestamp,
        i2.Option<({int seconds, int nanoseconds})> dataModificationTimestamp,
        i2.Option<({int seconds, int nanoseconds})> statusChangeTimestamp,
      }),
      i5.TypesErrorCode
    >
    tmp32;
    if (tmp1.toBool()) {
      final tmp26 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp31;
      switch (tmp26.toIntUnsigned()) {
        case 0:
          tmp31 = i5.TypesErrorCodeAccess();
        case 1:
          tmp31 = i5.TypesErrorCodeAlready();
        case 2:
          tmp31 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp31 = i5.TypesErrorCodeBusy();
        case 4:
          tmp31 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp31 = i5.TypesErrorCodeQuota();
        case 6:
          tmp31 = i5.TypesErrorCodeExist();
        case 7:
          tmp31 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp31 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp31 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp31 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp31 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp31 = i5.TypesErrorCodeIo();
        case 13:
          tmp31 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp31 = i5.TypesErrorCodeLoop();
        case 15:
          tmp31 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp31 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp31 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp31 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp31 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp31 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp31 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp31 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp31 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp31 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp31 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp31 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp31 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp31 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp31 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp31 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp31 = i5.TypesErrorCodePipe();
        case 32:
          tmp31 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp31 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp31 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp31 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp27 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp30;
          if (tmp27.toBool()) {
            final tmp28 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp29 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp30 = .some(i2.AllocatedString.read(tmp28, tmp29));
          } else {
            tmp30 = .none;
          }

          tmp31 = i5.TypesErrorCodeOther(tmp30);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp32 = .error(tmp31);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i5.TypesDescriptorType tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i5.TypesDescriptorTypeBlockDevice();
        case 1:
          tmp7 = i5.TypesDescriptorTypeCharacterDevice();
        case 2:
          tmp7 = i5.TypesDescriptorTypeDirectory();
        case 3:
          tmp7 = i5.TypesDescriptorTypeFifo();
        case 4:
          tmp7 = i5.TypesDescriptorTypeSymbolicLink();
        case 5:
          tmp7 = i5.TypesDescriptorTypeRegularFile();
        case 6:
          tmp7 = i5.TypesDescriptorTypeSocket();
        case 7:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i5.TypesDescriptorTypeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }
      final tmp8 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 24);
      final tmp9 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 32);
      final tmp10 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 40);
      final i2.Option<({int seconds, int nanoseconds})> tmp14;
      if (tmp10.toBool()) {
        final tmp11 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 48);
        final tmp12 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 56);
        final tmp13 = (
          seconds: tmp11.toInt(),
          nanoseconds: tmp12.toIntUnsigned(),
        );

        tmp14 = .some(tmp13);
      } else {
        tmp14 = .none;
      }

      final tmp15 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 64);
      final i2.Option<({int seconds, int nanoseconds})> tmp19;
      if (tmp15.toBool()) {
        final tmp16 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 72);
        final tmp17 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 80);
        final tmp18 = (
          seconds: tmp16.toInt(),
          nanoseconds: tmp17.toIntUnsigned(),
        );

        tmp19 = .some(tmp18);
      } else {
        tmp19 = .none;
      }

      final tmp20 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 88);
      final i2.Option<({int seconds, int nanoseconds})> tmp24;
      if (tmp20.toBool()) {
        final tmp21 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 96);
        final tmp22 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 104);
        final tmp23 = (
          seconds: tmp21.toInt(),
          nanoseconds: tmp22.toIntUnsigned(),
        );

        tmp24 = .some(tmp23);
      } else {
        tmp24 = .none;
      }

      final tmp25 = (
        type: tmp7,
        linkCount: tmp8.toInt(),
        size: tmp9.toInt(),
        dataAccessTimestamp: tmp14,
        dataModificationTimestamp: tmp19,
        statusChangeTimestamp: tmp24,
      );

      tmp32 = .ok(tmp25);
    }

    i2.dartFree(tmp0, const i1.WasmI32(112), const i1.WasmI32(8));
    return tmp32;
  }

  @override
  Future<
    i2.Result<
      ({
        i5.TypesDescriptorType type,
        int linkCount,
        int size,
        i2.Option<({int seconds, int nanoseconds})> dataAccessTimestamp,
        i2.Option<({int seconds, int nanoseconds})> dataModificationTimestamp,
        i2.Option<({int seconds, int nanoseconds})> statusChangeTimestamp,
      }),
      i5.TypesErrorCode
    >
  >
  methodDescriptorStatAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i5.TypesPathFlags pathFlags,
    required String path,
  }) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(path);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(112));
    await i2
        .createSubtask(
          _import65(
            self.handle.toWasmI32(),
            pathFlags.toWasmI32(),
            tmp0.ptr,
            tmp0.packedLength,
            tmp1,
          ),
        )
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<
      ({
        i5.TypesDescriptorType type,
        int linkCount,
        int size,
        i2.Option<({int seconds, int nanoseconds})> dataAccessTimestamp,
        i2.Option<({int seconds, int nanoseconds})> dataModificationTimestamp,
        i2.Option<({int seconds, int nanoseconds})> statusChangeTimestamp,
      }),
      i5.TypesErrorCode
    >
    tmp33;
    if (tmp2.toBool()) {
      final tmp27 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp32;
      switch (tmp27.toIntUnsigned()) {
        case 0:
          tmp32 = i5.TypesErrorCodeAccess();
        case 1:
          tmp32 = i5.TypesErrorCodeAlready();
        case 2:
          tmp32 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp32 = i5.TypesErrorCodeBusy();
        case 4:
          tmp32 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp32 = i5.TypesErrorCodeQuota();
        case 6:
          tmp32 = i5.TypesErrorCodeExist();
        case 7:
          tmp32 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp32 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp32 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp32 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp32 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp32 = i5.TypesErrorCodeIo();
        case 13:
          tmp32 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp32 = i5.TypesErrorCodeLoop();
        case 15:
          tmp32 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp32 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp32 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp32 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp32 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp32 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp32 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp32 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp32 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp32 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp32 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp32 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp32 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp32 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp32 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp32 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp32 = i5.TypesErrorCodePipe();
        case 32:
          tmp32 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp32 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp32 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp32 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp28 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp31;
          if (tmp28.toBool()) {
            final tmp29 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);
            final tmp30 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 20);

            tmp31 = .some(i2.AllocatedString.read(tmp29, tmp30));
          } else {
            tmp31 = .none;
          }

          tmp32 = i5.TypesErrorCodeOther(tmp31);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp33 = .error(tmp32);
    } else {
      final tmp3 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
      final i5.TypesDescriptorType tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i5.TypesDescriptorTypeBlockDevice();
        case 1:
          tmp8 = i5.TypesDescriptorTypeCharacterDevice();
        case 2:
          tmp8 = i5.TypesDescriptorTypeDirectory();
        case 3:
          tmp8 = i5.TypesDescriptorTypeFifo();
        case 4:
          tmp8 = i5.TypesDescriptorTypeSymbolicLink();
        case 5:
          tmp8 = i5.TypesDescriptorTypeRegularFile();
        case 6:
          tmp8 = i5.TypesDescriptorTypeSocket();
        case 7:
          final tmp4 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i5.TypesDescriptorTypeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }
      final tmp9 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 24);
      final tmp10 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 32);
      final tmp11 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 40);
      final i2.Option<({int seconds, int nanoseconds})> tmp15;
      if (tmp11.toBool()) {
        final tmp12 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 48);
        final tmp13 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 56);
        final tmp14 = (
          seconds: tmp12.toInt(),
          nanoseconds: tmp13.toIntUnsigned(),
        );

        tmp15 = .some(tmp14);
      } else {
        tmp15 = .none;
      }

      final tmp16 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 64);
      final i2.Option<({int seconds, int nanoseconds})> tmp20;
      if (tmp16.toBool()) {
        final tmp17 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 72);
        final tmp18 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 80);
        final tmp19 = (
          seconds: tmp17.toInt(),
          nanoseconds: tmp18.toIntUnsigned(),
        );

        tmp20 = .some(tmp19);
      } else {
        tmp20 = .none;
      }

      final tmp21 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 88);
      final i2.Option<({int seconds, int nanoseconds})> tmp25;
      if (tmp21.toBool()) {
        final tmp22 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 96);
        final tmp23 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 104);
        final tmp24 = (
          seconds: tmp22.toInt(),
          nanoseconds: tmp23.toIntUnsigned(),
        );

        tmp25 = .some(tmp24);
      } else {
        tmp25 = .none;
      }

      final tmp26 = (
        type: tmp8,
        linkCount: tmp9.toInt(),
        size: tmp10.toInt(),
        dataAccessTimestamp: tmp15,
        dataModificationTimestamp: tmp20,
        statusChangeTimestamp: tmp25,
      );

      tmp33 = .ok(tmp26);
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(112), const i1.WasmI32(8));
    return tmp33;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorSetTimesAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i5.TypesPathFlags pathFlags,
    required String path,
    required i5.TypesNewTimestamp dataAccessTimestamp,
    required i5.TypesNewTimestamp dataModificationTimestamp,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(64));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    i2.memory.storeInt8(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      pathFlags.toWasmI32(),
      offset: 0,
    );
    final tmp1 = i2.AllocatedString.allocateUtf16(path);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
      tmp1.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
      tmp1.ptr,
      offset: 0,
    );
    switch (dataAccessTimestamp) {
      case i5.TypesNewTimestampNoChange():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );
      case i5.TypesNewTimestampNow():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
      case i5.TypesNewTimestampTimestamp(payload: final value):
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
          const i1.WasmI32(2),
          offset: 0,
        );
        i2.memory.storeInt64(
          (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
          i1.WasmI64.fromInt(value.seconds),
          offset: 8,
        );
        i2.memory.storeInt32(
          (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
          i1.WasmI32.fromInt(value.nanoseconds),
          offset: 16,
        );
    }
    switch (dataModificationTimestamp) {
      case i5.TypesNewTimestampNoChange():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(40)).toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );
      case i5.TypesNewTimestampNow():
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(40)).toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
      case i5.TypesNewTimestampTimestamp(payload: final value):
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(40)).toIntUnsigned(),
          const i1.WasmI32(2),
          offset: 0,
        );
        i2.memory.storeInt64(
          (tmp0 + const i1.WasmI32(40)).toIntUnsigned(),
          i1.WasmI64.fromInt(value.seconds),
          offset: 8,
        );
        i2.memory.storeInt32(
          (tmp0 + const i1.WasmI32(40)).toIntUnsigned(),
          i1.WasmI32.fromInt(value.nanoseconds),
          offset: 16,
        );
    }
    var tmp2 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import66(tmp0, tmp2)).completion;
    final tmp3 = i2.memory.loadUint8(tmp2.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp10;
    if (tmp3.toBool()) {
      final tmp4 = i2.memory.loadUint8(tmp2.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp9;
      switch (tmp4.toIntUnsigned()) {
        case 0:
          tmp9 = i5.TypesErrorCodeAccess();
        case 1:
          tmp9 = i5.TypesErrorCodeAlready();
        case 2:
          tmp9 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp9 = i5.TypesErrorCodeBusy();
        case 4:
          tmp9 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp9 = i5.TypesErrorCodeQuota();
        case 6:
          tmp9 = i5.TypesErrorCodeExist();
        case 7:
          tmp9 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp9 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp9 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp9 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp9 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp9 = i5.TypesErrorCodeIo();
        case 13:
          tmp9 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp9 = i5.TypesErrorCodeLoop();
        case 15:
          tmp9 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp9 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp9 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp9 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp9 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp9 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp9 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp9 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp9 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp9 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp9 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp9 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp9 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp9 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp9 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp9 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp9 = i5.TypesErrorCodePipe();
        case 32:
          tmp9 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp9 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp9 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp9 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp5 = i2.memory.loadUint8(tmp2.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp8;
          if (tmp5.toBool()) {
            final tmp6 = i2.memory.loadInt32(tmp2.toIntUnsigned(), offset: 12);
            final tmp7 = i2.memory.loadInt32(tmp2.toIntUnsigned(), offset: 16);

            tmp8 = .some(i2.AllocatedString.read(tmp6, tmp7));
          } else {
            tmp8 = .none;
          }

          tmp9 = i5.TypesErrorCodeOther(tmp8);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp10 = .error(tmp9);
    } else {
      tmp10 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(64), const i1.WasmI32(8));
    tmp1.free();
    i2.dartFree(tmp2, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp10;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorLinkAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i5.TypesPathFlags oldPathFlags,
    required String oldPath,
    required i2.Borrowed<i5.TypesDescriptor> newDescriptor,
    required String newPath,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(28));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    i2.memory.storeInt8(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      oldPathFlags.toWasmI32(),
      offset: 0,
    );
    final tmp1 = i2.AllocatedString.allocateUtf16(oldPath);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
      tmp1.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
      tmp1.ptr,
      offset: 0,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
      newDescriptor.handle.toWasmI32(),
      offset: 0,
    );
    final tmp2 = i2.AllocatedString.allocateUtf16(newPath);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(20)).toIntUnsigned(),
      tmp2.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(20)).toIntUnsigned(),
      tmp2.ptr,
      offset: 0,
    );
    var tmp3 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import67(tmp0, tmp3)).completion;
    final tmp4 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp11;
    if (tmp4.toBool()) {
      final tmp5 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesErrorCodeAccess();
        case 1:
          tmp10 = i5.TypesErrorCodeAlready();
        case 2:
          tmp10 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp10 = i5.TypesErrorCodeBusy();
        case 4:
          tmp10 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp10 = i5.TypesErrorCodeQuota();
        case 6:
          tmp10 = i5.TypesErrorCodeExist();
        case 7:
          tmp10 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp10 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp10 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp10 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp10 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp10 = i5.TypesErrorCodeIo();
        case 13:
          tmp10 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp10 = i5.TypesErrorCodeLoop();
        case 15:
          tmp10 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp10 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp10 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp10 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp10 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp10 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp10 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp10 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp10 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp10 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp10 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp10 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp10 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp10 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp10 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp10 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp10 = i5.TypesErrorCodePipe();
        case 32:
          tmp10 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp10 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp10 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp10 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp6 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i2.memory.loadInt32(tmp3.toIntUnsigned(), offset: 12);
            final tmp8 = i2.memory.loadInt32(tmp3.toIntUnsigned(), offset: 16);

            tmp9 = .some(i2.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesErrorCodeOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      tmp11 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(28), const i1.WasmI32(4));
    tmp1.free();
    tmp2.free();
    i2.dartFree(tmp3, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp11;
  }

  @override
  Future<i2.Result<i2.Owned<i5.TypesDescriptor>, i5.TypesErrorCode>>
  methodDescriptorOpenAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i5.TypesPathFlags pathFlags,
    required String path,
    required i5.TypesOpenFlags openFlags,
    required i5.TypesDescriptorFlags flags,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    i2.memory.storeInt8(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      pathFlags.toWasmI32(),
      offset: 0,
    );
    final tmp1 = i2.AllocatedString.allocateUtf16(path);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
      tmp1.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(8)).toIntUnsigned(),
      tmp1.ptr,
      offset: 0,
    );
    i2.memory.storeInt8(
      (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
      openFlags.toWasmI32(),
      offset: 0,
    );
    i2.memory.storeInt8(
      (tmp0 + const i1.WasmI32(17)).toIntUnsigned(),
      flags.toWasmI32(),
      offset: 0,
    );
    var tmp2 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import68(tmp0, tmp2)).completion;
    final tmp3 = i2.memory.loadUint8(tmp2.toIntUnsigned(), offset: 0);
    final i2.Result<i2.Owned<i5.TypesDescriptor>, i5.TypesErrorCode> tmp12;
    if (tmp3.toBool()) {
      final tmp6 = i2.memory.loadUint8(tmp2.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp11;
      switch (tmp6.toIntUnsigned()) {
        case 0:
          tmp11 = i5.TypesErrorCodeAccess();
        case 1:
          tmp11 = i5.TypesErrorCodeAlready();
        case 2:
          tmp11 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp11 = i5.TypesErrorCodeBusy();
        case 4:
          tmp11 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp11 = i5.TypesErrorCodeQuota();
        case 6:
          tmp11 = i5.TypesErrorCodeExist();
        case 7:
          tmp11 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp11 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp11 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp11 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp11 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp11 = i5.TypesErrorCodeIo();
        case 13:
          tmp11 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp11 = i5.TypesErrorCodeLoop();
        case 15:
          tmp11 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp11 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp11 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp11 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp11 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp11 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp11 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp11 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp11 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp11 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp11 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp11 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp11 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp11 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp11 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp11 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp11 = i5.TypesErrorCodePipe();
        case 32:
          tmp11 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp11 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp11 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp11 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp7 = i2.memory.loadUint8(tmp2.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp10;
          if (tmp7.toBool()) {
            final tmp8 = i2.memory.loadInt32(tmp2.toIntUnsigned(), offset: 12);
            final tmp9 = i2.memory.loadInt32(tmp2.toIntUnsigned(), offset: 16);

            tmp10 = .some(i2.AllocatedString.read(tmp8, tmp9));
          } else {
            tmp10 = .none;
          }

          tmp11 = i5.TypesErrorCodeOther(tmp10);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp12 = .error(tmp11);
    } else {
      final tmp4 = i2.memory.loadInt32(tmp2.toIntUnsigned(), offset: 4);
      final tmp5 = i2.Owned<i5.TypesDescriptor>(tmp4.toIntUnsigned());
      tmp12 = .ok(tmp5);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    tmp1.free();
    i2.dartFree(tmp2, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp12;
  }

  @override
  Future<i2.Result<String, i5.TypesErrorCode>> methodDescriptorReadlinkAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required String path,
  }) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(path);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(
          _import69(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1),
        )
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<String, i5.TypesErrorCode> tmp11;
    if (tmp2.toBool()) {
      final tmp5 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesErrorCodeAccess();
        case 1:
          tmp10 = i5.TypesErrorCodeAlready();
        case 2:
          tmp10 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp10 = i5.TypesErrorCodeBusy();
        case 4:
          tmp10 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp10 = i5.TypesErrorCodeQuota();
        case 6:
          tmp10 = i5.TypesErrorCodeExist();
        case 7:
          tmp10 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp10 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp10 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp10 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp10 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp10 = i5.TypesErrorCodeIo();
        case 13:
          tmp10 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp10 = i5.TypesErrorCodeLoop();
        case 15:
          tmp10 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp10 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp10 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp10 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp10 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp10 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp10 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp10 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp10 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp10 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp10 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp10 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp10 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp10 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp10 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp10 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp10 = i5.TypesErrorCodePipe();
        case 32:
          tmp10 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp10 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp10 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp10 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp6 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp8 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp9 = .some(i2.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesErrorCodeOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      final tmp3 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 4);
      final tmp4 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 8);

      tmp11 = .ok(i2.AllocatedString.read(tmp3, tmp4));
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp11;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorRemoveDirectoryAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required String path,
  }) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(path);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(
          _import70(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1),
        )
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp9;
    if (tmp2.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i5.TypesErrorCodeAccess();
        case 1:
          tmp8 = i5.TypesErrorCodeAlready();
        case 2:
          tmp8 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp8 = i5.TypesErrorCodeBusy();
        case 4:
          tmp8 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp8 = i5.TypesErrorCodeQuota();
        case 6:
          tmp8 = i5.TypesErrorCodeExist();
        case 7:
          tmp8 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp8 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp8 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp8 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp8 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp8 = i5.TypesErrorCodeIo();
        case 13:
          tmp8 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp8 = i5.TypesErrorCodeLoop();
        case 15:
          tmp8 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp8 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp8 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp8 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp8 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp8 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp8 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp8 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp8 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp8 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp8 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp8 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp8 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp8 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp8 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp8 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp8 = i5.TypesErrorCodePipe();
        case 32:
          tmp8 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp8 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp8 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp8 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp4 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i5.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      tmp9 = .ok(null);
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorRenameAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required String oldPath,
    required i2.Borrowed<i5.TypesDescriptor> newDescriptor,
    required String newPath,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(24));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    final tmp1 = i2.AllocatedString.allocateUtf16(oldPath);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      tmp1.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      tmp1.ptr,
      offset: 0,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
      newDescriptor.handle.toWasmI32(),
      offset: 0,
    );
    final tmp2 = i2.AllocatedString.allocateUtf16(newPath);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
      tmp2.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(16)).toIntUnsigned(),
      tmp2.ptr,
      offset: 0,
    );
    var tmp3 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import71(tmp0, tmp3)).completion;
    final tmp4 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp11;
    if (tmp4.toBool()) {
      final tmp5 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesErrorCodeAccess();
        case 1:
          tmp10 = i5.TypesErrorCodeAlready();
        case 2:
          tmp10 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp10 = i5.TypesErrorCodeBusy();
        case 4:
          tmp10 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp10 = i5.TypesErrorCodeQuota();
        case 6:
          tmp10 = i5.TypesErrorCodeExist();
        case 7:
          tmp10 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp10 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp10 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp10 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp10 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp10 = i5.TypesErrorCodeIo();
        case 13:
          tmp10 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp10 = i5.TypesErrorCodeLoop();
        case 15:
          tmp10 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp10 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp10 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp10 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp10 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp10 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp10 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp10 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp10 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp10 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp10 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp10 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp10 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp10 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp10 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp10 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp10 = i5.TypesErrorCodePipe();
        case 32:
          tmp10 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp10 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp10 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp10 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp6 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i2.memory.loadInt32(tmp3.toIntUnsigned(), offset: 12);
            final tmp8 = i2.memory.loadInt32(tmp3.toIntUnsigned(), offset: 16);

            tmp9 = .some(i2.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesErrorCodeOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      tmp11 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(4));
    tmp1.free();
    tmp2.free();
    i2.dartFree(tmp3, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp11;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorSymlinkAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required String oldPath,
    required String newPath,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    final tmp1 = i2.AllocatedString.allocateUtf16(oldPath);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      tmp1.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      tmp1.ptr,
      offset: 0,
    );
    final tmp2 = i2.AllocatedString.allocateUtf16(newPath);
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
      tmp2.packedLength,
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
      tmp2.ptr,
      offset: 0,
    );
    var tmp3 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import72(tmp0, tmp3)).completion;
    final tmp4 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp11;
    if (tmp4.toBool()) {
      final tmp5 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesErrorCodeAccess();
        case 1:
          tmp10 = i5.TypesErrorCodeAlready();
        case 2:
          tmp10 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp10 = i5.TypesErrorCodeBusy();
        case 4:
          tmp10 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp10 = i5.TypesErrorCodeQuota();
        case 6:
          tmp10 = i5.TypesErrorCodeExist();
        case 7:
          tmp10 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp10 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp10 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp10 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp10 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp10 = i5.TypesErrorCodeIo();
        case 13:
          tmp10 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp10 = i5.TypesErrorCodeLoop();
        case 15:
          tmp10 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp10 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp10 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp10 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp10 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp10 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp10 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp10 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp10 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp10 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp10 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp10 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp10 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp10 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp10 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp10 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp10 = i5.TypesErrorCodePipe();
        case 32:
          tmp10 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp10 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp10 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp10 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp6 = i2.memory.loadUint8(tmp3.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i2.memory.loadInt32(tmp3.toIntUnsigned(), offset: 12);
            final tmp8 = i2.memory.loadInt32(tmp3.toIntUnsigned(), offset: 16);

            tmp9 = .some(i2.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesErrorCodeOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      tmp11 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    tmp1.free();
    tmp2.free();
    i2.dartFree(tmp3, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp11;
  }

  @override
  Future<i2.Result<void, i5.TypesErrorCode>> methodDescriptorUnlinkFileAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required String path,
  }) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(path);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(
          _import73(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1),
        )
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<void, i5.TypesErrorCode> tmp9;
    if (tmp2.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i5.TypesErrorCodeAccess();
        case 1:
          tmp8 = i5.TypesErrorCodeAlready();
        case 2:
          tmp8 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp8 = i5.TypesErrorCodeBusy();
        case 4:
          tmp8 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp8 = i5.TypesErrorCodeQuota();
        case 6:
          tmp8 = i5.TypesErrorCodeExist();
        case 7:
          tmp8 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp8 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp8 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp8 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp8 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp8 = i5.TypesErrorCodeIo();
        case 13:
          tmp8 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp8 = i5.TypesErrorCodeLoop();
        case 15:
          tmp8 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp8 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp8 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp8 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp8 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp8 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp8 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp8 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp8 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp8 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp8 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp8 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp8 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp8 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp8 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp8 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp8 = i5.TypesErrorCodePipe();
        case 32:
          tmp8 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp8 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp8 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp8 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp4 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i5.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      tmp9 = .ok(null);
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  Future<bool> methodDescriptorIsSameObject({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i2.Borrowed<i5.TypesDescriptor> other,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(1), const i1.WasmI32(1));
    await i2
        .createSubtask(
          _import74(self.handle.toWasmI32(), other.handle.toWasmI32(), tmp0),
        )
        .completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    i2.dartFree(tmp0, const i1.WasmI32(1), const i1.WasmI32(1));
    return tmp1.toBool();
  }

  @override
  Future<i2.Result<({int lower, int upper}), i5.TypesErrorCode>>
  methodDescriptorMetadataHash({
    required i2.Borrowed<i5.TypesDescriptor> self,
  }) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    await i2.createSubtask(_import75(self.handle.toWasmI32(), tmp0)).completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<({int lower, int upper}), i5.TypesErrorCode> tmp11;
    if (tmp1.toBool()) {
      final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesErrorCodeAccess();
        case 1:
          tmp10 = i5.TypesErrorCodeAlready();
        case 2:
          tmp10 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp10 = i5.TypesErrorCodeBusy();
        case 4:
          tmp10 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp10 = i5.TypesErrorCodeQuota();
        case 6:
          tmp10 = i5.TypesErrorCodeExist();
        case 7:
          tmp10 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp10 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp10 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp10 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp10 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp10 = i5.TypesErrorCodeIo();
        case 13:
          tmp10 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp10 = i5.TypesErrorCodeLoop();
        case 15:
          tmp10 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp10 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp10 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp10 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp10 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp10 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp10 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp10 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp10 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp10 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp10 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp10 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp10 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp10 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp10 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp10 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp10 = i5.TypesErrorCodePipe();
        case 32:
          tmp10 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp10 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp10 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp10 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp6 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp8 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp9 = .some(i2.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesErrorCodeOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);
      final tmp3 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 16);
      final tmp4 = (lower: tmp2.toInt(), upper: tmp3.toInt());

      tmp11 = .ok(tmp4);
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp11;
  }

  @override
  Future<i2.Result<({int lower, int upper}), i5.TypesErrorCode>>
  methodDescriptorMetadataHashAt({
    required i2.Borrowed<i5.TypesDescriptor> self,
    required i5.TypesPathFlags pathFlags,
    required String path,
  }) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(path);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    await i2
        .createSubtask(
          _import76(
            self.handle.toWasmI32(),
            pathFlags.toWasmI32(),
            tmp0.ptr,
            tmp0.packedLength,
            tmp1,
          ),
        )
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<({int lower, int upper}), i5.TypesErrorCode> tmp12;
    if (tmp2.toBool()) {
      final tmp6 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp11;
      switch (tmp6.toIntUnsigned()) {
        case 0:
          tmp11 = i5.TypesErrorCodeAccess();
        case 1:
          tmp11 = i5.TypesErrorCodeAlready();
        case 2:
          tmp11 = i5.TypesErrorCodeBadDescriptor();
        case 3:
          tmp11 = i5.TypesErrorCodeBusy();
        case 4:
          tmp11 = i5.TypesErrorCodeDeadlock();
        case 5:
          tmp11 = i5.TypesErrorCodeQuota();
        case 6:
          tmp11 = i5.TypesErrorCodeExist();
        case 7:
          tmp11 = i5.TypesErrorCodeFileTooLarge();
        case 8:
          tmp11 = i5.TypesErrorCodeIllegalByteSequence();
        case 9:
          tmp11 = i5.TypesErrorCodeInProgress();
        case 10:
          tmp11 = i5.TypesErrorCodeInterrupted();
        case 11:
          tmp11 = i5.TypesErrorCodeInvalid();
        case 12:
          tmp11 = i5.TypesErrorCodeIo();
        case 13:
          tmp11 = i5.TypesErrorCodeIsDirectory();
        case 14:
          tmp11 = i5.TypesErrorCodeLoop();
        case 15:
          tmp11 = i5.TypesErrorCodeTooManyLinks();
        case 16:
          tmp11 = i5.TypesErrorCodeMessageSize();
        case 17:
          tmp11 = i5.TypesErrorCodeNameTooLong();
        case 18:
          tmp11 = i5.TypesErrorCodeNoDevice();
        case 19:
          tmp11 = i5.TypesErrorCodeNoEntry();
        case 20:
          tmp11 = i5.TypesErrorCodeNoLock();
        case 21:
          tmp11 = i5.TypesErrorCodeInsufficientMemory();
        case 22:
          tmp11 = i5.TypesErrorCodeInsufficientSpace();
        case 23:
          tmp11 = i5.TypesErrorCodeNotDirectory();
        case 24:
          tmp11 = i5.TypesErrorCodeNotEmpty();
        case 25:
          tmp11 = i5.TypesErrorCodeNotRecoverable();
        case 26:
          tmp11 = i5.TypesErrorCodeUnsupported();
        case 27:
          tmp11 = i5.TypesErrorCodeNoTty();
        case 28:
          tmp11 = i5.TypesErrorCodeNoSuchDevice();
        case 29:
          tmp11 = i5.TypesErrorCodeOverflow();
        case 30:
          tmp11 = i5.TypesErrorCodeNotPermitted();
        case 31:
          tmp11 = i5.TypesErrorCodePipe();
        case 32:
          tmp11 = i5.TypesErrorCodeReadOnly();
        case 33:
          tmp11 = i5.TypesErrorCodeInvalidSeek();
        case 34:
          tmp11 = i5.TypesErrorCodeTextFileBusy();
        case 35:
          tmp11 = i5.TypesErrorCodeCrossDevice();
        case 36:
          final tmp7 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp10;
          if (tmp7.toBool()) {
            final tmp8 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);
            final tmp9 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 20);

            tmp10 = .some(i2.AllocatedString.read(tmp8, tmp9));
          } else {
            tmp10 = .none;
          }

          tmp11 = i5.TypesErrorCodeOther(tmp10);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp12 = .error(tmp11);
    } else {
      final tmp3 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 8);
      final tmp4 = i2.memory.loadInt64(tmp1.toIntUnsigned(), offset: 16);
      final tmp5 = (lower: tmp3.toInt(), upper: tmp4.toInt());

      tmp12 = .ok(tmp5);
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp12;
  }
}

const i5.Types importedInstance4 = _Imported$4();
@pragma("wasm:import", r"component._import77")
external i1.WasmVoid _import77(i1.WasmI32 p0);

final class _Imported$5 implements i5.Preopens {
  const _Imported$5();
  @override
  List<(i2.Owned<i5.TypesDescriptor>, String)> getDirectories() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import77(tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp9 = tmp2.toIntUnsigned();
    final tmp8 = List.generate(tmp1.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i1.WasmI32.fromInt(tmp9 + i * 12);
      final tmp3 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 0);
      final tmp4 = i2.Owned<i5.TypesDescriptor>(tmp3.toIntUnsigned());
      final tmp5 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 4);
      final tmp6 = i2.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 8);
      final tmp7 = (tmp4, i2.AllocatedString.read(tmp5, tmp6));

      return tmp7;
    });

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp8;
  }
}

const i5.Preopens importedInstance5 = _Imported$5();

@pragma('wasm:import', 'component.stream58.new')
external i1.WasmI64 _streamNew58();
@pragma('wasm:import', 'component.stream58.read')
external i1.WasmI32 _streamRead58(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream58.write')
external i1.WasmI32 _streamWrite58(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream58.drop-readable')
external i1.WasmVoid _streamDropReadable58(i1.WasmI32 stream);
@pragma('wasm:import', 'component.stream58.drop-writable')
external i1.WasmVoid _streamDropWritable58(i1.WasmI32 stream);

final class _Vtable58
    implements i2.StreamVtable<List<i2.Owned<i6.TypesTcpSocket>>> {
  const _Vtable58();

  @override
  int get elementSize => 4;
  @override
  int allocateBuffer(int size) {
    return i2
        .mallocAligned(const i1.WasmI32(4), (size * 4).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    for (var i = start; i < end; i++) {
      final ptr = i1.WasmI32.fromInt(address + i * 4);
      final tmp0 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 0);
      final tmp1 = i2.Owned<i6.TypesTcpSocket>(
        tmp0.toIntUnsigned(),
      ); // TODO: i6.TypesTcpSocket.drop(tmp1);
    }

    i2.dartFree(
      address.toWasmI32(),
      (totalSize * 4).toWasmI32(),
      const i1.WasmI32(4),
    );
  }

  @override
  void writeToBuffer(int address, List<i2.Owned<i6.TypesTcpSocket>> elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i1.WasmI32.fromInt(address + i);

      i2.memory.storeInt32(
        wasmAddress.toIntUnsigned(),
        element.handle.toWasmI32(),
        offset: 0,
      );
    }
  }

  @override
  List<i2.Owned<i6.TypesTcpSocket>> readFromBuffer(int address, int count) {
    return List.generate(count, (i) {
      final ptr = i1.WasmI32.fromInt(address + i * 4);
      final tmp0 = i2.memory.loadInt32(ptr.toIntUnsigned(), offset: 0);
      final tmp1 = i2.Owned<i6.TypesTcpSocket>(tmp0.toIntUnsigned());
      return tmp1;
    });
  }

  @override
  int newStream() => _streamNew58().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable58(i1.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable58(i1.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead58(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite58(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.stream60.new')
external i1.WasmI64 _streamNew60();
@pragma('wasm:import', 'component.stream60.read')
external i1.WasmI32 _streamRead60(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream60.write')
external i1.WasmI32 _streamWrite60(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream60.drop-readable')
external i1.WasmVoid _streamDropReadable60(i1.WasmI32 stream);
@pragma('wasm:import', 'component.stream60.drop-writable')
external i1.WasmVoid _streamDropWritable60(i1.WasmI32 stream);

final class _Vtable60 implements i2.StreamVtable<i3.Uint8List> {
  const _Vtable60();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i2
        .mallocAligned(const i1.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    i2.dartFree(
      address.toWasmI32(),
      (totalSize * 1).toWasmI32(),
      const i1.WasmI32(1),
    );
  }

  @override
  void writeToBuffer(int address, i3.Uint8List elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i1.WasmI32.fromInt(address + i);

      i2.memory.storeInt8(
        wasmAddress.toIntUnsigned(),
        i1.WasmI32.uint8FromInt(element),
        offset: 0,
      );
    }
  }

  @override
  i3.Uint8List readFromBuffer(int address, int count) {
    final typedList = i3.Uint8List(count);
    for (var i = 0; i < count; i++) {
      final ptr = i1.WasmI32.fromInt(address + i * 1);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);

      typedList[i] = tmp0.toIntUnsigned();
    }
    return typedList;
  }

  @override
  int newStream() => _streamNew60().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable60(i1.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable60(i1.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead60(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite60(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.future61.new')
external i1.WasmI64 _futureNew61();
@pragma('wasm:import', 'component.future61.write')
external i1.WasmI32 _futureWrite61(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future61.read')
external i1.WasmI32 _futureRead61(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future61.drop-readable')
external i1.WasmVoid _futureDropReadable61(i1.WasmI32 future);
@pragma('wasm:import', 'component.future61.drop-writable')
external i1.WasmVoid _futureDropWritable61(i1.WasmI32 future);

final class _Vtable61
    implements i2.FutureVtable<i2.Result<void, i6.TypesErrorCode>> {
  const _Vtable61();

  @override
  int newFuture() => _futureNew61().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead61(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite61(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable61(i1.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable61(i1.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i2
        .mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    if (containsValue) {
      final ptr = i1.WasmI32.fromInt(address);
      final tmp0 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);
      switch (tmp0) {
        case 0:
          break;
        case 1:
          final tmp1 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 4);
          switch (tmp1) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              break;
            case 5:
              break;
            case 6:
              break;
            case 7:
              break;
            case 8:
              break;
            case 9:
              break;
            case 10:
              break;
            case 11:
              break;
            case 12:
              break;
            case 13:
              break;
            case 14:
              final tmp2 = i2.memory.loadUint8(ptr.toIntUnsigned(), offset: 8);
              switch (tmp2) {
                case 0:
                  break;
                case 1:
                  final tmp3 = i2.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 12,
                  );
                  final tmp4 = i2.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 16,
                  );
                  i2.AllocatedString(tmp3, tmp4).free();
                  break;
              }
              break;
          }
          break;
      }
    }
    i2.dartFree(address.toWasmI32(), const i1.WasmI32(20), const i1.WasmI32(4));
  }

  @override
  void store(int address, i2.Result<void, i6.TypesErrorCode> value) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    switch (value) {
      case i2.OkResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );

      case i2.ErrorResult(:final value):
        i2.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        switch (value) {
          case i6.TypesErrorCodeAccessDenied():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(0),
              offset: 4,
            );
          case i6.TypesErrorCodeNotSupported():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(1),
              offset: 4,
            );
          case i6.TypesErrorCodeInvalidArgument():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(2),
              offset: 4,
            );
          case i6.TypesErrorCodeOutOfMemory():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(3),
              offset: 4,
            );
          case i6.TypesErrorCodeTimeout():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(4),
              offset: 4,
            );
          case i6.TypesErrorCodeInvalidState():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(5),
              offset: 4,
            );
          case i6.TypesErrorCodeAddressNotBindable():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(6),
              offset: 4,
            );
          case i6.TypesErrorCodeAddressInUse():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(7),
              offset: 4,
            );
          case i6.TypesErrorCodeRemoteUnreachable():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(8),
              offset: 4,
            );
          case i6.TypesErrorCodeConnectionRefused():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(9),
              offset: 4,
            );
          case i6.TypesErrorCodeConnectionBroken():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(10),
              offset: 4,
            );
          case i6.TypesErrorCodeConnectionReset():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(11),
              offset: 4,
            );
          case i6.TypesErrorCodeConnectionAborted():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(12),
              offset: 4,
            );
          case i6.TypesErrorCodeDatagramTooLarge():
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(13),
              offset: 4,
            );
          case i6.TypesErrorCodeOther(payload: final value):
            i2.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i1.WasmI32(14),
              offset: 4,
            );
            final tmp1 = value;
            if (tmp1.hasValue) {
              final value = tmp1.requireValue();
              i2.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i1.WasmI32(1),
                offset: 8,
              );
              final tmp0 = i2.AllocatedString.allocateUtf16(value);
              i2.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp0.packedLength,
                offset: 16,
              );
              i2.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp0.ptr,
                offset: 12,
              );
            } else {
              i2.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i1.WasmI32(0),
                offset: 8,
              );
            }
        }
    }
  }

  @override
  i2.Result<void, i6.TypesErrorCode> load(int address) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    final tmp0 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp7;
    if (tmp0.toBool()) {
      final tmp1 = i2.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp6;
      switch (tmp1.toIntUnsigned()) {
        case 0:
          tmp6 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp6 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp6 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp6 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp6 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp6 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp6 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp6 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp6 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp6 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp6 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp6 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp6 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp6 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp2 = i2.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 8,
          );
          final i2.Option<String> tmp5;
          if (tmp2.toBool()) {
            final tmp3 = i2.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 12,
            );
            final tmp4 = i2.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 16,
            );

            tmp5 = .some(i2.AllocatedString.read(tmp3, tmp4));
          } else {
            tmp5 = .none;
          }

          tmp6 = i6.TypesErrorCodeOther(tmp5);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp7 = .error(tmp6);
    } else {
      tmp7 = .ok(null);
    }

    return tmp7;
  }
}

@pragma("wasm:import", r"component._import93")
external i1.WasmVoid _import93(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import94")
external i1.WasmVoid _import94(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
  i1.WasmI32 p4,
  i1.WasmI32 p5,
  i1.WasmI32 p6,
  i1.WasmI32 p7,
  i1.WasmI32 p8,
  i1.WasmI32 p9,
  i1.WasmI32 p10,
  i1.WasmI32 p11,
  i1.WasmI32 p12,
  i1.WasmI32 p13,
);
@pragma("wasm:import", r"component._import95")
external i1.WasmI32 _import95(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import96")
external i1.WasmVoid _import96(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import97")
external i1.WasmI32 _import97(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import98")
external i1.WasmVoid _import98(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import99")
external i1.WasmVoid _import99(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import100")
external i1.WasmVoid _import100(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import101")
external i1.WasmI32 _import101(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import102")
external i1.WasmI32 _import102(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import103")
external i1.WasmVoid _import103(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import104")
external i1.WasmVoid _import104(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import105")
external i1.WasmVoid _import105(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import106")
external i1.WasmVoid _import106(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import107")
external i1.WasmVoid _import107(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import108")
external i1.WasmVoid _import108(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import109")
external i1.WasmVoid _import109(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import110")
external i1.WasmVoid _import110(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import111")
external i1.WasmVoid _import111(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import112")
external i1.WasmVoid _import112(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import113")
external i1.WasmVoid _import113(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import114")
external i1.WasmVoid _import114(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import115")
external i1.WasmVoid _import115(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import116")
external i1.WasmVoid _import116(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import117")
external i1.WasmVoid _import117(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import118")
external i1.WasmVoid _import118(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import119")
external i1.WasmVoid _import119(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
  i1.WasmI32 p4,
  i1.WasmI32 p5,
  i1.WasmI32 p6,
  i1.WasmI32 p7,
  i1.WasmI32 p8,
  i1.WasmI32 p9,
  i1.WasmI32 p10,
  i1.WasmI32 p11,
  i1.WasmI32 p12,
  i1.WasmI32 p13,
);
@pragma("wasm:import", r"component._import120")
external i1.WasmVoid _import120(
  i1.WasmI32 p0,
  i1.WasmI32 p1,
  i1.WasmI32 p2,
  i1.WasmI32 p3,
  i1.WasmI32 p4,
  i1.WasmI32 p5,
  i1.WasmI32 p6,
  i1.WasmI32 p7,
  i1.WasmI32 p8,
  i1.WasmI32 p9,
  i1.WasmI32 p10,
  i1.WasmI32 p11,
  i1.WasmI32 p12,
  i1.WasmI32 p13,
);
@pragma("wasm:import", r"component._import121")
external i1.WasmVoid _import121(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import122")
external i1.WasmI32 _import122(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import123")
external i1.WasmI32 _import123(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import124")
external i1.WasmVoid _import124(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import125")
external i1.WasmVoid _import125(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import126")
external i1.WasmI32 _import126(i1.WasmI32 p0);
@pragma("wasm:import", r"component._import127")
external i1.WasmVoid _import127(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import128")
external i1.WasmVoid _import128(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import129")
external i1.WasmVoid _import129(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import130")
external i1.WasmVoid _import130(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);
@pragma("wasm:import", r"component._import131")
external i1.WasmVoid _import131(i1.WasmI32 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import132")
external i1.WasmVoid _import132(i1.WasmI32 p0, i1.WasmI64 p1, i1.WasmI32 p2);

final class _Imported$6 implements i6.Types {
  const _Imported$6();
  @override
  i2.Result<i2.Owned<i6.TypesTcpSocket>, i6.TypesErrorCode>
  staticTcpSocketCreate({required i6.TypesIpAddressFamily addressFamily}) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import93(addressFamily.index.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i2.Owned<i6.TypesTcpSocket>, i6.TypesErrorCode> tmp10;
    if (tmp1.toBool()) {
      final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp9;
      switch (tmp4.toIntUnsigned()) {
        case 0:
          tmp9 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp9 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp9 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp9 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp9 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp9 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp9 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp9 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp9 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp9 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp9 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp9 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp9 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp9 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp8;
          if (tmp5.toBool()) {
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp7 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp8 = .some(i2.AllocatedString.read(tmp6, tmp7));
          } else {
            tmp8 = .none;
          }

          tmp9 = i6.TypesErrorCodeOther(tmp8);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp10 = .error(tmp9);
    } else {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.Owned<i6.TypesTcpSocket>(tmp2.toIntUnsigned());
      tmp10 = .ok(tmp3);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp10;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketBind({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required i6.TypesIpSocketAddress localAddress,
  }) {
    i1.WasmI32 tmp0;
    i1.WasmI32 tmp1;
    i1.WasmI32 tmp2;
    i1.WasmI32 tmp3;
    i1.WasmI32 tmp4;
    i1.WasmI32 tmp5;
    i1.WasmI32 tmp6;
    i1.WasmI32 tmp7;
    i1.WasmI32 tmp8;
    i1.WasmI32 tmp9;
    i1.WasmI32 tmp10;
    i1.WasmI32 tmp11;
    switch (localAddress) {
      case i6.TypesIpSocketAddressIpv4(payload: final value):
        tmp0 = const i1.WasmI32(0);
        tmp1 = i1.WasmI32.uint16FromInt(value.port);
        tmp2 = i1.WasmI32.uint8FromInt(value.address.$1);
        tmp3 = i1.WasmI32.uint8FromInt(value.address.$2);
        tmp4 = i1.WasmI32.uint8FromInt(value.address.$3);
        tmp5 = i1.WasmI32.uint8FromInt(value.address.$4);
        tmp6 = const i1.WasmI32(0);
        tmp7 = const i1.WasmI32(0);
        tmp8 = const i1.WasmI32(0);
        tmp9 = const i1.WasmI32(0);
        tmp10 = const i1.WasmI32(0);
        tmp11 = const i1.WasmI32(0);
      case i6.TypesIpSocketAddressIpv6(payload: final value):
        tmp0 = const i1.WasmI32(1);
        tmp1 = i1.WasmI32.uint16FromInt(value.port);
        tmp2 = i1.WasmI32.fromInt(value.flowInfo);
        tmp3 = i1.WasmI32.uint16FromInt(value.address.$1);
        tmp4 = i1.WasmI32.uint16FromInt(value.address.$2);
        tmp5 = i1.WasmI32.uint16FromInt(value.address.$3);
        tmp6 = i1.WasmI32.uint16FromInt(value.address.$4);
        tmp7 = i1.WasmI32.uint16FromInt(value.address.$5);
        tmp8 = i1.WasmI32.uint16FromInt(value.address.$6);
        tmp9 = i1.WasmI32.uint16FromInt(value.address.$7);
        tmp10 = i1.WasmI32.uint16FromInt(value.address.$8);
        tmp11 = i1.WasmI32.fromInt(value.scopeId);
    }
    var tmp12 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import94(
      self.handle.toWasmI32(),
      tmp0,
      tmp1,
      tmp2,
      tmp3,
      tmp4,
      tmp5,
      tmp6,
      tmp7,
      tmp8,
      tmp9,
      tmp10,
      tmp11,
      tmp12,
    );
    final tmp13 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp20;
    if (tmp13.toBool()) {
      final tmp14 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp19;
      switch (tmp14.toIntUnsigned()) {
        case 0:
          tmp19 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp19 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp19 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp19 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp19 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp19 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp19 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp19 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp19 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp19 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp19 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp19 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp19 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp19 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp15 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp18;
          if (tmp15.toBool()) {
            final tmp16 = i2.memory.loadInt32(
              tmp12.toIntUnsigned(),
              offset: 12,
            );
            final tmp17 = i2.memory.loadInt32(
              tmp12.toIntUnsigned(),
              offset: 16,
            );

            tmp18 = .some(i2.AllocatedString.read(tmp16, tmp17));
          } else {
            tmp18 = .none;
          }

          tmp19 = i6.TypesErrorCodeOther(tmp18);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp20 = .error(tmp19);
    } else {
      tmp20 = .ok(null);
    }

    i2.dartFree(tmp12, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp20;
  }

  @override
  Future<i2.Result<void, i6.TypesErrorCode>> methodTcpSocketConnect({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required i6.TypesIpSocketAddress remoteAddress,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(36));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );
    switch (remoteAddress) {
      case i6.TypesIpSocketAddressIpv4(payload: final value):
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.port),
          offset: 4,
        );
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint8FromInt(value.address.$1),
          offset: 6,
        );
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint8FromInt(value.address.$2),
          offset: 7,
        );
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint8FromInt(value.address.$3),
          offset: 8,
        );
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint8FromInt(value.address.$4),
          offset: 9,
        );
      case i6.TypesIpSocketAddressIpv6(payload: final value):
        i2.memory.storeInt8(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.port),
          offset: 4,
        );
        i2.memory.storeInt32(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.fromInt(value.flowInfo),
          offset: 8,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$1),
          offset: 12,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$2),
          offset: 14,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$3),
          offset: 16,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$4),
          offset: 18,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$5),
          offset: 20,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$6),
          offset: 22,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$7),
          offset: 24,
        );
        i2.memory.storeInt16(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.uint16FromInt(value.address.$8),
          offset: 26,
        );
        i2.memory.storeInt32(
          (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
          i1.WasmI32.fromInt(value.scopeId),
          offset: 28,
        );
    }
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import95(tmp0, tmp1)).completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp9;
    if (tmp2.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      tmp9 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(36), const i1.WasmI32(4));
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  i2.Result<Stream<List<i2.Owned<i6.TypesTcpSocket>>>, i6.TypesErrorCode>
  methodTcpSocketListen({required i2.Borrowed<i6.TypesTcpSocket> self}) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import96(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<
      Stream<List<i2.Owned<i6.TypesTcpSocket>>>,
      i6.TypesErrorCode
    >
    tmp10;
    if (tmp1.toBool()) {
      final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp9;
      switch (tmp4.toIntUnsigned()) {
        case 0:
          tmp9 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp9 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp9 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp9 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp9 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp9 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp9 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp9 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp9 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp9 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp9 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp9 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp9 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp9 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp8;
          if (tmp5.toBool()) {
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp7 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp8 = .some(i2.AllocatedString.read(tmp6, tmp7));
          } else {
            tmp8 = .none;
          }

          tmp9 = i6.TypesErrorCodeOther(tmp8);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp10 = .error(tmp9);
    } else {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.ReadableStream(tmp2.toIntUnsigned(), const _Vtable58());

      tmp10 = .ok(tmp3);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp10;
  }

  @override
  Future<i2.Result<void, i6.TypesErrorCode>> methodTcpSocketSend({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i2.newReadableStream(const _Vtable60(), data).toWasmI32();
    final tmp1 = _import97(self.handle.toWasmI32(), tmp0);
    final tmp2 = i2.readFuture(const _Vtable61(), tmp1.toIntUnsigned());
    return tmp2;
  }

  @override
  (Stream<i3.Uint8List>, Future<i2.Result<void, i6.TypesErrorCode>>)
  methodTcpSocketReceive({required i2.Borrowed<i6.TypesTcpSocket> self}) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import98(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.ReadableStream(tmp1.toIntUnsigned(), const _Vtable60());
    final tmp3 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
    final tmp4 = i2.readFuture(const _Vtable61(), tmp3.toIntUnsigned());
    final tmp5 = (tmp2, tmp4);
    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp5;
  }

  @override
  i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode>
  methodTcpSocketGetLocalAddress({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(36));
    _import99(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode> tmp30;
    if (tmp1.toBool()) {
      final tmp24 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp29;
      switch (tmp24.toIntUnsigned()) {
        case 0:
          tmp29 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp29 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp29 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp29 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp29 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp29 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp29 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp29 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp29 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp29 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp29 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp29 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp29 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp29 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp25 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp28;
          if (tmp25.toBool()) {
            final tmp26 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp27 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp28 = .some(i2.AllocatedString.read(tmp26, tmp27));
          } else {
            tmp28 = .none;
          }

          tmp29 = i6.TypesErrorCodeOther(tmp28);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .error(tmp29);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesIpSocketAddress tmp23;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          final tmp3 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 10);
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 11);
          final tmp6 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final tmp7 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 13);
          final tmp8 = (
            tmp4.toIntUnsigned(),
            tmp5.toIntUnsigned(),
            tmp6.toIntUnsigned(),
            tmp7.toIntUnsigned(),
          );
          final tmp9 = (port: tmp3.toIntUnsigned(), address: tmp8);

          tmp23 = i6.TypesIpSocketAddressIpv4(tmp9);
        case 1:
          final tmp10 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp11 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
          final tmp12 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 16);
          final tmp13 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 18);
          final tmp14 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 20);
          final tmp15 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 22);
          final tmp16 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 24);
          final tmp17 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 26);
          final tmp18 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 28);
          final tmp19 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 30);
          final tmp20 = (
            tmp12.toIntUnsigned(),
            tmp13.toIntUnsigned(),
            tmp14.toIntUnsigned(),
            tmp15.toIntUnsigned(),
            tmp16.toIntUnsigned(),
            tmp17.toIntUnsigned(),
            tmp18.toIntUnsigned(),
            tmp19.toIntUnsigned(),
          );
          final tmp21 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);
          final tmp22 = (
            port: tmp10.toIntUnsigned(),
            flowInfo: tmp11.toIntUnsigned(),
            address: tmp20,
            scopeId: tmp21.toIntUnsigned(),
          );

          tmp23 = i6.TypesIpSocketAddressIpv6(tmp22);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .ok(tmp23);
    }

    i2.dartFree(tmp0, const i1.WasmI32(36), const i1.WasmI32(4));
    return tmp30;
  }

  @override
  i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode>
  methodTcpSocketGetRemoteAddress({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(36));
    _import100(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode> tmp30;
    if (tmp1.toBool()) {
      final tmp24 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp29;
      switch (tmp24.toIntUnsigned()) {
        case 0:
          tmp29 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp29 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp29 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp29 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp29 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp29 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp29 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp29 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp29 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp29 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp29 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp29 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp29 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp29 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp25 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp28;
          if (tmp25.toBool()) {
            final tmp26 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp27 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp28 = .some(i2.AllocatedString.read(tmp26, tmp27));
          } else {
            tmp28 = .none;
          }

          tmp29 = i6.TypesErrorCodeOther(tmp28);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .error(tmp29);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesIpSocketAddress tmp23;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          final tmp3 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 10);
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 11);
          final tmp6 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final tmp7 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 13);
          final tmp8 = (
            tmp4.toIntUnsigned(),
            tmp5.toIntUnsigned(),
            tmp6.toIntUnsigned(),
            tmp7.toIntUnsigned(),
          );
          final tmp9 = (port: tmp3.toIntUnsigned(), address: tmp8);

          tmp23 = i6.TypesIpSocketAddressIpv4(tmp9);
        case 1:
          final tmp10 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp11 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
          final tmp12 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 16);
          final tmp13 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 18);
          final tmp14 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 20);
          final tmp15 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 22);
          final tmp16 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 24);
          final tmp17 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 26);
          final tmp18 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 28);
          final tmp19 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 30);
          final tmp20 = (
            tmp12.toIntUnsigned(),
            tmp13.toIntUnsigned(),
            tmp14.toIntUnsigned(),
            tmp15.toIntUnsigned(),
            tmp16.toIntUnsigned(),
            tmp17.toIntUnsigned(),
            tmp18.toIntUnsigned(),
            tmp19.toIntUnsigned(),
          );
          final tmp21 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);
          final tmp22 = (
            port: tmp10.toIntUnsigned(),
            flowInfo: tmp11.toIntUnsigned(),
            address: tmp20,
            scopeId: tmp21.toIntUnsigned(),
          );

          tmp23 = i6.TypesIpSocketAddressIpv6(tmp22);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .ok(tmp23);
    }

    i2.dartFree(tmp0, const i1.WasmI32(36), const i1.WasmI32(4));
    return tmp30;
  }

  @override
  bool methodTcpSocketGetIsListening({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    final tmp0 = _import101(self.handle.toWasmI32());
    return tmp0.toBool();
  }

  @override
  i6.TypesIpAddressFamily methodTcpSocketGetAddressFamily({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    final tmp0 = _import102(self.handle.toWasmI32());
    return i6.TypesIpAddressFamily.values[tmp0.toIntUnsigned()];
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetListenBacklogSize({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import103(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<bool, i6.TypesErrorCode> methodTcpSocketGetKeepAliveEnabled({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import104(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<bool, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);

      tmp9 = .ok(tmp2.toBool());
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetKeepAliveEnabled({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required bool value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import105(self.handle.toWasmI32(), i1.WasmI32.fromBool(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodTcpSocketGetKeepAliveIdleTime({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    _import106(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp9 = .ok(tmp2.toInt());
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetKeepAliveIdleTime({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import107(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodTcpSocketGetKeepAliveInterval({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    _import108(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp9 = .ok(tmp2.toInt());
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetKeepAliveInterval({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import109(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodTcpSocketGetKeepAliveCount({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import110(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

      tmp9 = .ok(tmp2.toIntUnsigned());
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetKeepAliveCount({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import111(self.handle.toWasmI32(), i1.WasmI32.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodTcpSocketGetHopLimit({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import112(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);

      tmp9 = .ok(tmp2.toIntUnsigned());
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetHopLimit({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import113(self.handle.toWasmI32(), i1.WasmI32.uint8FromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodTcpSocketGetReceiveBufferSize({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    _import114(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp9 = .ok(tmp2.toInt());
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetReceiveBufferSize({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import115(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodTcpSocketGetSendBufferSize({
    required i2.Borrowed<i6.TypesTcpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    _import116(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp9 = .ok(tmp2.toInt());
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodTcpSocketSetSendBufferSize({
    required i2.Borrowed<i6.TypesTcpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import117(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<i2.Owned<i6.TypesUdpSocket>, i6.TypesErrorCode>
  staticUdpSocketCreate({required i6.TypesIpAddressFamily addressFamily}) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import118(addressFamily.index.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i2.Owned<i6.TypesUdpSocket>, i6.TypesErrorCode> tmp10;
    if (tmp1.toBool()) {
      final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp9;
      switch (tmp4.toIntUnsigned()) {
        case 0:
          tmp9 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp9 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp9 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp9 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp9 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp9 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp9 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp9 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp9 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp9 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp9 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp9 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp9 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp9 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp8;
          if (tmp5.toBool()) {
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp7 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp8 = .some(i2.AllocatedString.read(tmp6, tmp7));
          } else {
            tmp8 = .none;
          }

          tmp9 = i6.TypesErrorCodeOther(tmp8);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp10 = .error(tmp9);
    } else {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.Owned<i6.TypesUdpSocket>(tmp2.toIntUnsigned());
      tmp10 = .ok(tmp3);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp10;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodUdpSocketBind({
    required i2.Borrowed<i6.TypesUdpSocket> self,
    required i6.TypesIpSocketAddress localAddress,
  }) {
    i1.WasmI32 tmp0;
    i1.WasmI32 tmp1;
    i1.WasmI32 tmp2;
    i1.WasmI32 tmp3;
    i1.WasmI32 tmp4;
    i1.WasmI32 tmp5;
    i1.WasmI32 tmp6;
    i1.WasmI32 tmp7;
    i1.WasmI32 tmp8;
    i1.WasmI32 tmp9;
    i1.WasmI32 tmp10;
    i1.WasmI32 tmp11;
    switch (localAddress) {
      case i6.TypesIpSocketAddressIpv4(payload: final value):
        tmp0 = const i1.WasmI32(0);
        tmp1 = i1.WasmI32.uint16FromInt(value.port);
        tmp2 = i1.WasmI32.uint8FromInt(value.address.$1);
        tmp3 = i1.WasmI32.uint8FromInt(value.address.$2);
        tmp4 = i1.WasmI32.uint8FromInt(value.address.$3);
        tmp5 = i1.WasmI32.uint8FromInt(value.address.$4);
        tmp6 = const i1.WasmI32(0);
        tmp7 = const i1.WasmI32(0);
        tmp8 = const i1.WasmI32(0);
        tmp9 = const i1.WasmI32(0);
        tmp10 = const i1.WasmI32(0);
        tmp11 = const i1.WasmI32(0);
      case i6.TypesIpSocketAddressIpv6(payload: final value):
        tmp0 = const i1.WasmI32(1);
        tmp1 = i1.WasmI32.uint16FromInt(value.port);
        tmp2 = i1.WasmI32.fromInt(value.flowInfo);
        tmp3 = i1.WasmI32.uint16FromInt(value.address.$1);
        tmp4 = i1.WasmI32.uint16FromInt(value.address.$2);
        tmp5 = i1.WasmI32.uint16FromInt(value.address.$3);
        tmp6 = i1.WasmI32.uint16FromInt(value.address.$4);
        tmp7 = i1.WasmI32.uint16FromInt(value.address.$5);
        tmp8 = i1.WasmI32.uint16FromInt(value.address.$6);
        tmp9 = i1.WasmI32.uint16FromInt(value.address.$7);
        tmp10 = i1.WasmI32.uint16FromInt(value.address.$8);
        tmp11 = i1.WasmI32.fromInt(value.scopeId);
    }
    var tmp12 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import119(
      self.handle.toWasmI32(),
      tmp0,
      tmp1,
      tmp2,
      tmp3,
      tmp4,
      tmp5,
      tmp6,
      tmp7,
      tmp8,
      tmp9,
      tmp10,
      tmp11,
      tmp12,
    );
    final tmp13 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp20;
    if (tmp13.toBool()) {
      final tmp14 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp19;
      switch (tmp14.toIntUnsigned()) {
        case 0:
          tmp19 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp19 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp19 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp19 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp19 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp19 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp19 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp19 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp19 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp19 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp19 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp19 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp19 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp19 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp15 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp18;
          if (tmp15.toBool()) {
            final tmp16 = i2.memory.loadInt32(
              tmp12.toIntUnsigned(),
              offset: 12,
            );
            final tmp17 = i2.memory.loadInt32(
              tmp12.toIntUnsigned(),
              offset: 16,
            );

            tmp18 = .some(i2.AllocatedString.read(tmp16, tmp17));
          } else {
            tmp18 = .none;
          }

          tmp19 = i6.TypesErrorCodeOther(tmp18);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp20 = .error(tmp19);
    } else {
      tmp20 = .ok(null);
    }

    i2.dartFree(tmp12, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp20;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodUdpSocketConnect({
    required i2.Borrowed<i6.TypesUdpSocket> self,
    required i6.TypesIpSocketAddress remoteAddress,
  }) {
    i1.WasmI32 tmp0;
    i1.WasmI32 tmp1;
    i1.WasmI32 tmp2;
    i1.WasmI32 tmp3;
    i1.WasmI32 tmp4;
    i1.WasmI32 tmp5;
    i1.WasmI32 tmp6;
    i1.WasmI32 tmp7;
    i1.WasmI32 tmp8;
    i1.WasmI32 tmp9;
    i1.WasmI32 tmp10;
    i1.WasmI32 tmp11;
    switch (remoteAddress) {
      case i6.TypesIpSocketAddressIpv4(payload: final value):
        tmp0 = const i1.WasmI32(0);
        tmp1 = i1.WasmI32.uint16FromInt(value.port);
        tmp2 = i1.WasmI32.uint8FromInt(value.address.$1);
        tmp3 = i1.WasmI32.uint8FromInt(value.address.$2);
        tmp4 = i1.WasmI32.uint8FromInt(value.address.$3);
        tmp5 = i1.WasmI32.uint8FromInt(value.address.$4);
        tmp6 = const i1.WasmI32(0);
        tmp7 = const i1.WasmI32(0);
        tmp8 = const i1.WasmI32(0);
        tmp9 = const i1.WasmI32(0);
        tmp10 = const i1.WasmI32(0);
        tmp11 = const i1.WasmI32(0);
      case i6.TypesIpSocketAddressIpv6(payload: final value):
        tmp0 = const i1.WasmI32(1);
        tmp1 = i1.WasmI32.uint16FromInt(value.port);
        tmp2 = i1.WasmI32.fromInt(value.flowInfo);
        tmp3 = i1.WasmI32.uint16FromInt(value.address.$1);
        tmp4 = i1.WasmI32.uint16FromInt(value.address.$2);
        tmp5 = i1.WasmI32.uint16FromInt(value.address.$3);
        tmp6 = i1.WasmI32.uint16FromInt(value.address.$4);
        tmp7 = i1.WasmI32.uint16FromInt(value.address.$5);
        tmp8 = i1.WasmI32.uint16FromInt(value.address.$6);
        tmp9 = i1.WasmI32.uint16FromInt(value.address.$7);
        tmp10 = i1.WasmI32.uint16FromInt(value.address.$8);
        tmp11 = i1.WasmI32.fromInt(value.scopeId);
    }
    var tmp12 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import120(
      self.handle.toWasmI32(),
      tmp0,
      tmp1,
      tmp2,
      tmp3,
      tmp4,
      tmp5,
      tmp6,
      tmp7,
      tmp8,
      tmp9,
      tmp10,
      tmp11,
      tmp12,
    );
    final tmp13 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp20;
    if (tmp13.toBool()) {
      final tmp14 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp19;
      switch (tmp14.toIntUnsigned()) {
        case 0:
          tmp19 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp19 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp19 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp19 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp19 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp19 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp19 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp19 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp19 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp19 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp19 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp19 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp19 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp19 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp15 = i2.memory.loadUint8(tmp12.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp18;
          if (tmp15.toBool()) {
            final tmp16 = i2.memory.loadInt32(
              tmp12.toIntUnsigned(),
              offset: 12,
            );
            final tmp17 = i2.memory.loadInt32(
              tmp12.toIntUnsigned(),
              offset: 16,
            );

            tmp18 = .some(i2.AllocatedString.read(tmp16, tmp17));
          } else {
            tmp18 = .none;
          }

          tmp19 = i6.TypesErrorCodeOther(tmp18);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp20 = .error(tmp19);
    } else {
      tmp20 = .ok(null);
    }

    i2.dartFree(tmp12, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp20;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodUdpSocketDisconnect({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import121(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  Future<i2.Result<void, i6.TypesErrorCode>> methodUdpSocketSend({
    required i2.Borrowed<i6.TypesUdpSocket> self,
    required List<int> data,
    required i2.Option<i6.TypesIpSocketAddress> remoteAddress,
  }) async {
    final tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(48));
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(0)).toIntUnsigned(),
      self.handle.toWasmI32(),
      offset: 0,
    );

    final tmp1 = i1.WasmI32.fromInt(1 * data.length);
    final tmp2 = i2.mallocAligned(const i1.WasmI32(1), tmp1);
    var tmp3 = tmp2;
    for (final element in data) {
      final elementPtr = tmp3;
      i2.memory.storeInt8(
        elementPtr.toIntUnsigned(),
        i1.WasmI32.uint8FromInt(element),
        offset: 0,
      );

      tmp3 += const i1.WasmI32(1);
    }

    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      i1.WasmI32.fromInt(data.length),
      offset: 4,
    );
    i2.memory.storeInt32(
      (tmp0 + const i1.WasmI32(4)).toIntUnsigned(),
      tmp2,
      offset: 0,
    );
    final tmp4 = remoteAddress;
    if (tmp4.hasValue) {
      final value = tmp4.requireValue();
      i2.memory.storeInt8(
        (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
        const i1.WasmI32(1),
        offset: 0,
      );
      switch (value) {
        case i6.TypesIpSocketAddressIpv4(payload: final value):
          i2.memory.storeInt8(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            const i1.WasmI32(0),
            offset: 4,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.port),
            offset: 8,
          );
          i2.memory.storeInt8(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint8FromInt(value.address.$1),
            offset: 10,
          );
          i2.memory.storeInt8(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint8FromInt(value.address.$2),
            offset: 11,
          );
          i2.memory.storeInt8(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint8FromInt(value.address.$3),
            offset: 12,
          );
          i2.memory.storeInt8(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint8FromInt(value.address.$4),
            offset: 13,
          );
        case i6.TypesIpSocketAddressIpv6(payload: final value):
          i2.memory.storeInt8(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            const i1.WasmI32(1),
            offset: 4,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.port),
            offset: 8,
          );
          i2.memory.storeInt32(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.fromInt(value.flowInfo),
            offset: 12,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$1),
            offset: 16,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$2),
            offset: 18,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$3),
            offset: 20,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$4),
            offset: 22,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$5),
            offset: 24,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$6),
            offset: 26,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$7),
            offset: 28,
          );
          i2.memory.storeInt16(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.uint16FromInt(value.address.$8),
            offset: 30,
          );
          i2.memory.storeInt32(
            (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
            i1.WasmI32.fromInt(value.scopeId),
            offset: 32,
          );
      }
    } else {
      i2.memory.storeInt8(
        (tmp0 + const i1.WasmI32(12)).toIntUnsigned(),
        const i1.WasmI32(0),
        offset: 0,
      );
    }
    var tmp5 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2.createSubtask(_import122(tmp0, tmp5)).completion;
    final tmp6 = i2.memory.loadUint8(tmp5.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp13;
    if (tmp6.toBool()) {
      final tmp7 = i2.memory.loadUint8(tmp5.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp12;
      switch (tmp7.toIntUnsigned()) {
        case 0:
          tmp12 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp12 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp12 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp12 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp12 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp12 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp12 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp12 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp12 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp12 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp12 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp12 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp12 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp12 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp8 = i2.memory.loadUint8(tmp5.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp11;
          if (tmp8.toBool()) {
            final tmp9 = i2.memory.loadInt32(tmp5.toIntUnsigned(), offset: 12);
            final tmp10 = i2.memory.loadInt32(tmp5.toIntUnsigned(), offset: 16);

            tmp11 = .some(i2.AllocatedString.read(tmp9, tmp10));
          } else {
            tmp11 = .none;
          }

          tmp12 = i6.TypesErrorCodeOther(tmp11);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp13 = .error(tmp12);
    } else {
      tmp13 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(48), const i1.WasmI32(4));
    i2.dartFree(tmp2, tmp1, const i1.WasmI32(1));
    i2.dartFree(tmp5, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp13;
  }

  @override
  Future<i2.Result<(List<int>, i6.TypesIpSocketAddress), i6.TypesErrorCode>>
  methodUdpSocketReceive({required i2.Borrowed<i6.TypesUdpSocket> self}) async {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(44));
    await i2
        .createSubtask(_import123(self.handle.toWasmI32(), tmp0))
        .completion;
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<(List<int>, i6.TypesIpSocketAddress), i6.TypesErrorCode>
    tmp36;
    if (tmp1.toBool()) {
      final tmp30 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp35;
      switch (tmp30.toIntUnsigned()) {
        case 0:
          tmp35 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp35 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp35 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp35 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp35 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp35 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp35 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp35 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp35 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp35 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp35 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp35 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp35 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp35 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp31 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp34;
          if (tmp31.toBool()) {
            final tmp32 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp33 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp34 = .some(i2.AllocatedString.read(tmp32, tmp33));
          } else {
            tmp34 = .none;
          }

          tmp35 = i6.TypesErrorCodeOther(tmp34);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp36 = .error(tmp35);
    } else {
      final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);

      final tmp6 = tmp3.toIntUnsigned();
      final tmp5 = List.generate(tmp2.toIntUnsigned(), growable: false, (i) {
        final elementPtr = i1.WasmI32.fromInt(tmp6 + i * 1);
        final tmp4 = i2.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

        return tmp4.toIntUnsigned();
      });

      final tmp7 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
      final i6.TypesIpSocketAddress tmp28;
      switch (tmp7.toIntUnsigned()) {
        case 0:
          final tmp8 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 16);
          final tmp9 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 18);
          final tmp10 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 19);
          final tmp11 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 20);
          final tmp12 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 21);
          final tmp13 = (
            tmp9.toIntUnsigned(),
            tmp10.toIntUnsigned(),
            tmp11.toIntUnsigned(),
            tmp12.toIntUnsigned(),
          );
          final tmp14 = (port: tmp8.toIntUnsigned(), address: tmp13);

          tmp28 = i6.TypesIpSocketAddressIpv4(tmp14);
        case 1:
          final tmp15 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 16);
          final tmp16 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
          final tmp17 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 24);
          final tmp18 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 26);
          final tmp19 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 28);
          final tmp20 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 30);
          final tmp21 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 32);
          final tmp22 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 34);
          final tmp23 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 36);
          final tmp24 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 38);
          final tmp25 = (
            tmp17.toIntUnsigned(),
            tmp18.toIntUnsigned(),
            tmp19.toIntUnsigned(),
            tmp20.toIntUnsigned(),
            tmp21.toIntUnsigned(),
            tmp22.toIntUnsigned(),
            tmp23.toIntUnsigned(),
            tmp24.toIntUnsigned(),
          );
          final tmp26 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 40);
          final tmp27 = (
            port: tmp15.toIntUnsigned(),
            flowInfo: tmp16.toIntUnsigned(),
            address: tmp25,
            scopeId: tmp26.toIntUnsigned(),
          );

          tmp28 = i6.TypesIpSocketAddressIpv6(tmp27);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }
      final tmp29 = (tmp5, tmp28);

      tmp36 = .ok(tmp29);
    }

    i2.dartFree(tmp0, const i1.WasmI32(44), const i1.WasmI32(4));
    return tmp36;
  }

  @override
  i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode>
  methodUdpSocketGetLocalAddress({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(36));
    _import124(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode> tmp30;
    if (tmp1.toBool()) {
      final tmp24 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp29;
      switch (tmp24.toIntUnsigned()) {
        case 0:
          tmp29 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp29 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp29 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp29 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp29 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp29 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp29 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp29 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp29 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp29 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp29 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp29 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp29 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp29 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp25 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp28;
          if (tmp25.toBool()) {
            final tmp26 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp27 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp28 = .some(i2.AllocatedString.read(tmp26, tmp27));
          } else {
            tmp28 = .none;
          }

          tmp29 = i6.TypesErrorCodeOther(tmp28);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .error(tmp29);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesIpSocketAddress tmp23;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          final tmp3 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 10);
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 11);
          final tmp6 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final tmp7 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 13);
          final tmp8 = (
            tmp4.toIntUnsigned(),
            tmp5.toIntUnsigned(),
            tmp6.toIntUnsigned(),
            tmp7.toIntUnsigned(),
          );
          final tmp9 = (port: tmp3.toIntUnsigned(), address: tmp8);

          tmp23 = i6.TypesIpSocketAddressIpv4(tmp9);
        case 1:
          final tmp10 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp11 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
          final tmp12 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 16);
          final tmp13 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 18);
          final tmp14 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 20);
          final tmp15 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 22);
          final tmp16 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 24);
          final tmp17 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 26);
          final tmp18 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 28);
          final tmp19 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 30);
          final tmp20 = (
            tmp12.toIntUnsigned(),
            tmp13.toIntUnsigned(),
            tmp14.toIntUnsigned(),
            tmp15.toIntUnsigned(),
            tmp16.toIntUnsigned(),
            tmp17.toIntUnsigned(),
            tmp18.toIntUnsigned(),
            tmp19.toIntUnsigned(),
          );
          final tmp21 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);
          final tmp22 = (
            port: tmp10.toIntUnsigned(),
            flowInfo: tmp11.toIntUnsigned(),
            address: tmp20,
            scopeId: tmp21.toIntUnsigned(),
          );

          tmp23 = i6.TypesIpSocketAddressIpv6(tmp22);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .ok(tmp23);
    }

    i2.dartFree(tmp0, const i1.WasmI32(36), const i1.WasmI32(4));
    return tmp30;
  }

  @override
  i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode>
  methodUdpSocketGetRemoteAddress({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(36));
    _import125(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<i6.TypesIpSocketAddress, i6.TypesErrorCode> tmp30;
    if (tmp1.toBool()) {
      final tmp24 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp29;
      switch (tmp24.toIntUnsigned()) {
        case 0:
          tmp29 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp29 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp29 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp29 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp29 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp29 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp29 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp29 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp29 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp29 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp29 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp29 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp29 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp29 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp25 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp28;
          if (tmp25.toBool()) {
            final tmp26 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp27 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp28 = .some(i2.AllocatedString.read(tmp26, tmp27));
          } else {
            tmp28 = .none;
          }

          tmp29 = i6.TypesErrorCodeOther(tmp28);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .error(tmp29);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesIpSocketAddress tmp23;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          final tmp3 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 10);
          final tmp5 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 11);
          final tmp6 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final tmp7 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 13);
          final tmp8 = (
            tmp4.toIntUnsigned(),
            tmp5.toIntUnsigned(),
            tmp6.toIntUnsigned(),
            tmp7.toIntUnsigned(),
          );
          final tmp9 = (port: tmp3.toIntUnsigned(), address: tmp8);

          tmp23 = i6.TypesIpSocketAddressIpv4(tmp9);
        case 1:
          final tmp10 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 8);
          final tmp11 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
          final tmp12 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 16);
          final tmp13 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 18);
          final tmp14 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 20);
          final tmp15 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 22);
          final tmp16 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 24);
          final tmp17 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 26);
          final tmp18 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 28);
          final tmp19 = i2.memory.loadUint16(tmp0.toIntUnsigned(), offset: 30);
          final tmp20 = (
            tmp12.toIntUnsigned(),
            tmp13.toIntUnsigned(),
            tmp14.toIntUnsigned(),
            tmp15.toIntUnsigned(),
            tmp16.toIntUnsigned(),
            tmp17.toIntUnsigned(),
            tmp18.toIntUnsigned(),
            tmp19.toIntUnsigned(),
          );
          final tmp21 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);
          final tmp22 = (
            port: tmp10.toIntUnsigned(),
            flowInfo: tmp11.toIntUnsigned(),
            address: tmp20,
            scopeId: tmp21.toIntUnsigned(),
          );

          tmp23 = i6.TypesIpSocketAddressIpv6(tmp22);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp30 = .ok(tmp23);
    }

    i2.dartFree(tmp0, const i1.WasmI32(36), const i1.WasmI32(4));
    return tmp30;
  }

  @override
  i6.TypesIpAddressFamily methodUdpSocketGetAddressFamily({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    final tmp0 = _import126(self.handle.toWasmI32());
    return i6.TypesIpAddressFamily.values[tmp0.toIntUnsigned()];
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodUdpSocketGetUnicastHopLimit({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import127(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);

      tmp9 = .ok(tmp2.toIntUnsigned());
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodUdpSocketSetUnicastHopLimit({
    required i2.Borrowed<i6.TypesUdpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import128(self.handle.toWasmI32(), i1.WasmI32.uint8FromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodUdpSocketGetReceiveBufferSize({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    _import129(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp9 = .ok(tmp2.toInt());
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodUdpSocketSetReceiveBufferSize({
    required i2.Borrowed<i6.TypesUdpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import130(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }

  @override
  i2.Result<int, i6.TypesErrorCode> methodUdpSocketGetSendBufferSize({
    required i2.Borrowed<i6.TypesUdpSocket> self,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(24));
    _import131(self.handle.toWasmI32(), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<int, i6.TypesErrorCode> tmp9;
    if (tmp1.toBool()) {
      final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i6.TypesErrorCode tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp8 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp8 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp8 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp8 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp8 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp8 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp8 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp8 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp8 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp8 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp8 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp8 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp8 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp4 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 12);
          final i2.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);
            final tmp6 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp7 = .some(i2.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i6.TypesErrorCodeOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp9 = .ok(tmp2.toInt());
    }

    i2.dartFree(tmp0, const i1.WasmI32(24), const i1.WasmI32(8));
    return tmp9;
  }

  @override
  i2.Result<void, i6.TypesErrorCode> methodUdpSocketSetSendBufferSize({
    required i2.Borrowed<i6.TypesUdpSocket> self,
    required int value,
  }) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    _import132(self.handle.toWasmI32(), i1.WasmI64.fromInt(value), tmp0);
    final tmp1 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i2.Result<void, i6.TypesErrorCode> tmp8;
    if (tmp1.toBool()) {
      final tmp2 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i6.TypesErrorCode tmp7;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp7 = i6.TypesErrorCodeAccessDenied();
        case 1:
          tmp7 = i6.TypesErrorCodeNotSupported();
        case 2:
          tmp7 = i6.TypesErrorCodeInvalidArgument();
        case 3:
          tmp7 = i6.TypesErrorCodeOutOfMemory();
        case 4:
          tmp7 = i6.TypesErrorCodeTimeout();
        case 5:
          tmp7 = i6.TypesErrorCodeInvalidState();
        case 6:
          tmp7 = i6.TypesErrorCodeAddressNotBindable();
        case 7:
          tmp7 = i6.TypesErrorCodeAddressInUse();
        case 8:
          tmp7 = i6.TypesErrorCodeRemoteUnreachable();
        case 9:
          tmp7 = i6.TypesErrorCodeConnectionRefused();
        case 10:
          tmp7 = i6.TypesErrorCodeConnectionBroken();
        case 11:
          tmp7 = i6.TypesErrorCodeConnectionReset();
        case 12:
          tmp7 = i6.TypesErrorCodeConnectionAborted();
        case 13:
          tmp7 = i6.TypesErrorCodeDatagramTooLarge();
        case 14:
          final tmp3 = i2.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp6;
          if (tmp3.toBool()) {
            final tmp4 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);
            final tmp5 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 16);

            tmp6 = .some(i2.AllocatedString.read(tmp4, tmp5));
          } else {
            tmp6 = .none;
          }

          tmp7 = i6.TypesErrorCodeOther(tmp6);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp8 = .error(tmp7);
    } else {
      tmp8 = .ok(null);
    }

    i2.dartFree(tmp0, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp8;
  }
}

const i6.Types importedInstance6 = _Imported$6();
@pragma("wasm:import", r"component._import133")
external i1.WasmI32 _import133(i1.WasmI32 p0, i1.WasmI32 p1, i1.WasmI32 p2);

final class _Imported$7 implements i6.IpNameLookup {
  const _Imported$7();
  @override
  Future<i2.Result<List<i6.TypesIpAddress>, i6.IpNameLookupErrorCode>>
  resolveAddresses({required String name}) async {
    final tmp0 = i2.AllocatedString.allocateUtf16(name);
    var tmp1 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(20));
    await i2
        .createSubtask(_import133(tmp0.ptr, tmp0.packedLength, tmp1))
        .completion;
    final tmp2 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i2.Result<List<i6.TypesIpAddress>, i6.IpNameLookupErrorCode> tmp29;
    if (tmp2.toBool()) {
      final tmp23 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i6.IpNameLookupErrorCode tmp28;
      switch (tmp23.toIntUnsigned()) {
        case 0:
          tmp28 = i6.IpNameLookupErrorCodeAccessDenied();
        case 1:
          tmp28 = i6.IpNameLookupErrorCodeInvalidArgument();
        case 2:
          tmp28 = i6.IpNameLookupErrorCodeNameUnresolvable();
        case 3:
          tmp28 = i6.IpNameLookupErrorCodeTemporaryResolverFailure();
        case 4:
          tmp28 = i6.IpNameLookupErrorCodePermanentResolverFailure();
        case 5:
          final tmp24 = i2.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i2.Option<String> tmp27;
          if (tmp24.toBool()) {
            final tmp25 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp26 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp27 = .some(i2.AllocatedString.read(tmp25, tmp26));
          } else {
            tmp27 = .none;
          }

          tmp28 = i6.IpNameLookupErrorCodeOther(tmp27);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp29 = .error(tmp28);
    } else {
      final tmp3 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 4);
      final tmp4 = i2.memory.loadInt32(tmp1.toIntUnsigned(), offset: 8);

      final tmp22 = tmp4.toIntUnsigned();
      final tmp21 = List.generate(tmp3.toIntUnsigned(), growable: false, (i) {
        final elementPtr = i1.WasmI32.fromInt(tmp22 + i * 18);
        final tmp5 = i2.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);
        final i6.TypesIpAddress tmp20;
        switch (tmp5.toIntUnsigned()) {
          case 0:
            final tmp6 = i2.memory.loadUint8(
              elementPtr.toIntUnsigned(),
              offset: 2,
            );
            final tmp7 = i2.memory.loadUint8(
              elementPtr.toIntUnsigned(),
              offset: 3,
            );
            final tmp8 = i2.memory.loadUint8(
              elementPtr.toIntUnsigned(),
              offset: 4,
            );
            final tmp9 = i2.memory.loadUint8(
              elementPtr.toIntUnsigned(),
              offset: 5,
            );
            final tmp10 = (
              tmp6.toIntUnsigned(),
              tmp7.toIntUnsigned(),
              tmp8.toIntUnsigned(),
              tmp9.toIntUnsigned(),
            );

            tmp20 = i6.TypesIpAddressIpv4(tmp10);
          case 1:
            final tmp11 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 2,
            );
            final tmp12 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 4,
            );
            final tmp13 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 6,
            );
            final tmp14 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 8,
            );
            final tmp15 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 10,
            );
            final tmp16 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 12,
            );
            final tmp17 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 14,
            );
            final tmp18 = i2.memory.loadUint16(
              elementPtr.toIntUnsigned(),
              offset: 16,
            );
            final tmp19 = (
              tmp11.toIntUnsigned(),
              tmp12.toIntUnsigned(),
              tmp13.toIntUnsigned(),
              tmp14.toIntUnsigned(),
              tmp15.toIntUnsigned(),
              tmp16.toIntUnsigned(),
              tmp17.toIntUnsigned(),
              tmp18.toIntUnsigned(),
            );

            tmp20 = i6.TypesIpAddressIpv6(tmp19);

          default:
            throw ArgumentError('Invalid discrimant value for variant');
        }

        return tmp20;
      });

      tmp29 = .ok(tmp21);
    }

    tmp0.free();
    i2.dartFree(tmp1, const i1.WasmI32(20), const i1.WasmI32(4));
    return tmp29;
  }
}

const i6.IpNameLookup importedInstance7 = _Imported$7();
@pragma("wasm:import", r"component._import134")
external i1.WasmVoid _import134(i1.WasmI64 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import135")
external i1.WasmI64 _import135();

final class _Imported$8 implements i7.Random {
  const _Imported$8();
  @override
  List<int> getRandomBytes({required int maxLen}) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import134(i1.WasmI64.fromInt(maxLen), tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp5 = tmp2.toIntUnsigned();
    final tmp4 = List.generate(tmp1.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i1.WasmI32.fromInt(tmp5 + i * 1);
      final tmp3 = i2.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

      return tmp3.toIntUnsigned();
    });

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp4;
  }

  @override
  int getRandomU64() {
    final tmp0 = _import135();
    return tmp0.toInt();
  }
}

const i7.Random importedInstance8 = _Imported$8();
@pragma("wasm:import", r"component._import136")
external i1.WasmVoid _import136(i1.WasmI64 p0, i1.WasmI32 p1);
@pragma("wasm:import", r"component._import137")
external i1.WasmI64 _import137();

final class _Imported$9 implements i7.Insecure {
  const _Imported$9();
  @override
  List<int> getInsecureRandomBytes({required int maxLen}) {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(4), const i1.WasmI32(8));
    _import136(i1.WasmI64.fromInt(maxLen), tmp0);
    final tmp1 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp5 = tmp2.toIntUnsigned();
    final tmp4 = List.generate(tmp1.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i1.WasmI32.fromInt(tmp5 + i * 1);
      final tmp3 = i2.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

      return tmp3.toIntUnsigned();
    });

    i2.dartFree(tmp0, const i1.WasmI32(8), const i1.WasmI32(4));
    return tmp4;
  }

  @override
  int getInsecureRandomU64() {
    final tmp0 = _import137();
    return tmp0.toInt();
  }
}

const i7.Insecure importedInstance9 = _Imported$9();
@pragma("wasm:import", r"component._import138")
external i1.WasmVoid _import138(i1.WasmI32 p0);

final class _Imported$10 implements i7.InsecureSeed {
  const _Imported$10();
  @override
  (int, int) getInsecureSeed() {
    var tmp0 = i2.mallocAligned(const i1.WasmI32(8), const i1.WasmI32(16));
    _import138(tmp0);
    final tmp1 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i2.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);
    final tmp3 = (tmp1.toInt(), tmp2.toInt());
    i2.dartFree(tmp0, const i1.WasmI32(16), const i1.WasmI32(8));
    return tmp3;
  }
}

const i7.InsecureSeed importedInstance10 = _Imported$10();
late i0.Run _unnamedExport13;
void defineInstanceExport({required i0.Run unnamedExport13}) {
  _unnamedExport13 = unnamedExport13;
}

@pragma('wasm:export', r'component_0')
i1.WasmI32 _component_0() {
  final asyncExitCode = i2.spawnTask(
    run: () async {
      final tmp0 = await _unnamedExport13.run();
      i1.WasmI32 tmp1;
      switch (tmp0) {
        case i2.OkResult(:final value):
          tmp1 = const i1.WasmI32(0);
        case i2.ErrorResult(:final value):
          tmp1 = const i1.WasmI32(1);
      }
      _component_0taskReturn(tmp1);
    },
    debugName: 'run',
  );
  return asyncExitCode.toWasmI32();
}

@pragma('wasm:import', 'component._component_0taskReturn')
external i1.WasmVoid _component_0taskReturn(i1.WasmI32 p0);
