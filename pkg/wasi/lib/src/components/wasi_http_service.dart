// ignore_for_file: type=warning
import r'wasi_cli.dart' as i0;

import r'package:wasm_components/wasm_components.dart' as i1;

// ignore: import_internal_library
import r'dart:_wasm' as i2;
import r'dart:typed_data' as i3;

import r'wasi_clocks.dart' as i4;
import r'wasi_http.dart' as i5;
import r'wasi_random.dart' as i6;

import r'package:meta/meta.dart' as i7;

final class _Imported$14 implements i0.Types {
  const _Imported$14();
}

@pragma('wasm:import', 'component.stream89.new')
external i2.WasmI64 _streamNew89();
@pragma('wasm:import', 'component.stream89.read')
external i2.WasmI32 _streamRead89(
  i2.WasmI32 stream,
  i2.WasmI32 ptr,
  i2.WasmI32 n,
);
@pragma('wasm:import', 'component.stream89.write')
external i2.WasmI32 _streamWrite89(
  i2.WasmI32 stream,
  i2.WasmI32 ptr,
  i2.WasmI32 n,
);
@pragma('wasm:import', 'component.stream89.drop-readable')
external i2.WasmVoid _streamDropReadable89(i2.WasmI32 stream);
@pragma('wasm:import', 'component.stream89.drop-writable')
external i2.WasmVoid _streamDropWritable89(i2.WasmI32 stream);

final class _Vtable89 implements i1.StreamVtable<i3.Uint8List> {
  const _Vtable89();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i1
        .mallocAligned(const i2.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    i1.dartFree(
      address.toWasmI32(),
      (totalSize * 1).toWasmI32(),
      const i2.WasmI32(1),
    );
  }

  @override
  void writeToBuffer(int address, i3.Uint8List elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i2.WasmI32.fromInt(address + i);

      i1.memory.storeInt8(
        wasmAddress.toIntUnsigned(),
        i2.WasmI32.uint8FromInt(element),
        offset: 0,
      );
    }
  }

  @override
  i3.Uint8List readFromBuffer(int address, int count) {
    final typedList = i3.Uint8List(count);
    for (var i = 0; i < count; i++) {
      final ptr = i2.WasmI32.fromInt(address + i * 1);
      final tmp0 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);

      typedList[i] = tmp0.toIntUnsigned();
    }
    return typedList;
  }

  @override
  int newStream() => _streamNew89().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable89(i2.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable89(i2.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead89(
      i2.WasmI32.fromInt(stream),
      i2.WasmI32.fromInt(ptr),
      i2.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite89(
      i2.WasmI32.fromInt(stream),
      i2.WasmI32.fromInt(ptr),
      i2.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.future95.new')
external i2.WasmI64 _futureNew95();
@pragma('wasm:import', 'component.future95.write')
external i2.WasmI32 _futureWrite95(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future95.read')
external i2.WasmI32 _futureRead95(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future95.drop-readable')
external i2.WasmVoid _futureDropReadable95(i2.WasmI32 future);
@pragma('wasm:import', 'component.future95.drop-writable')
external i2.WasmVoid _futureDropWritable95(i2.WasmI32 future);

final class _Vtable95
    implements i1.FutureVtable<i1.Result<void, i0.TypesErrorCode>> {
  const _Vtable95();

  @override
  int newFuture() => _futureNew95().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead95(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite95(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable95(i2.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable95(i2.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i1
        .mallocAligned(const i2.WasmI32(1), const i2.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i1.dartFree(address.toWasmI32(), const i2.WasmI32(2), const i2.WasmI32(1));
  }

  @override
  void store(int address, i1.Result<void, i0.TypesErrorCode> value) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    switch (value) {
      case i1.OkResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(0),
          offset: 0,
        );

      case i1.ErrorResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(1),
          offset: 0,
        );
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i1.Result<void, i0.TypesErrorCode> load(int address) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    final tmp0 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i1.Result<void, i0.TypesErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.TypesErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import10")
external i2.WasmI32 _import10(i2.WasmI32 p0);

final class _Imported$16 implements i0.Stdout {
  const _Imported$16();
  @override
  Future<i1.Result<void, i0.TypesErrorCode>> writeViaStream({
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i1.newReadableStream(const _Vtable89(), data).toWasmI32();
    final tmp1 = _import10(tmp0);
    final tmp2 = i1.readFuture(const _Vtable95(), tmp1.toIntUnsigned());
    return tmp2;
  }
}

@pragma('wasm:import', 'component.future98.new')
external i2.WasmI64 _futureNew98();
@pragma('wasm:import', 'component.future98.write')
external i2.WasmI32 _futureWrite98(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future98.read')
external i2.WasmI32 _futureRead98(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future98.drop-readable')
external i2.WasmVoid _futureDropReadable98(i2.WasmI32 future);
@pragma('wasm:import', 'component.future98.drop-writable')
external i2.WasmVoid _futureDropWritable98(i2.WasmI32 future);

final class _Vtable98
    implements i1.FutureVtable<i1.Result<void, i0.TypesErrorCode>> {
  const _Vtable98();

  @override
  int newFuture() => _futureNew98().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead98(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite98(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable98(i2.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable98(i2.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i1
        .mallocAligned(const i2.WasmI32(1), const i2.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i1.dartFree(address.toWasmI32(), const i2.WasmI32(2), const i2.WasmI32(1));
  }

  @override
  void store(int address, i1.Result<void, i0.TypesErrorCode> value) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    switch (value) {
      case i1.OkResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(0),
          offset: 0,
        );

      case i1.ErrorResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(1),
          offset: 0,
        );
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i1.Result<void, i0.TypesErrorCode> load(int address) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    final tmp0 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i1.Result<void, i0.TypesErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.TypesErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import16")
external i2.WasmI32 _import16(i2.WasmI32 p0);

final class _Imported$17 implements i0.Stderr {
  const _Imported$17();
  @override
  Future<i1.Result<void, i0.TypesErrorCode>> writeViaStream({
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i1.newReadableStream(const _Vtable89(), data).toWasmI32();
    final tmp1 = _import16(tmp0);
    final tmp2 = i1.readFuture(const _Vtable98(), tmp1.toIntUnsigned());
    return tmp2;
  }
}

@pragma('wasm:import', 'component.future91.new')
external i2.WasmI64 _futureNew91();
@pragma('wasm:import', 'component.future91.write')
external i2.WasmI32 _futureWrite91(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future91.read')
external i2.WasmI32 _futureRead91(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future91.drop-readable')
external i2.WasmVoid _futureDropReadable91(i2.WasmI32 future);
@pragma('wasm:import', 'component.future91.drop-writable')
external i2.WasmVoid _futureDropWritable91(i2.WasmI32 future);

final class _Vtable91
    implements i1.FutureVtable<i1.Result<void, i0.TypesErrorCode>> {
  const _Vtable91();

  @override
  int newFuture() => _futureNew91().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead91(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite91(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable91(i2.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable91(i2.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i1
        .mallocAligned(const i2.WasmI32(1), const i2.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i1.dartFree(address.toWasmI32(), const i2.WasmI32(2), const i2.WasmI32(1));
  }

  @override
  void store(int address, i1.Result<void, i0.TypesErrorCode> value) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    switch (value) {
      case i1.OkResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(0),
          offset: 0,
        );

      case i1.ErrorResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(1),
          offset: 0,
        );
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i1.Result<void, i0.TypesErrorCode> load(int address) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    final tmp0 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i1.Result<void, i0.TypesErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.TypesErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import22")
external i2.WasmVoid _import22(i2.WasmI32 p0);

final class _Imported$15 implements i0.Stdin {
  const _Imported$15();
  @override
  (Stream<i3.Uint8List>, Future<i1.Result<void, i0.TypesErrorCode>>)
  readViaStream() {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import22(tmp0);
    final tmp1 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i1.ReadableStream(tmp1.toIntUnsigned(), const _Vtable89());
    final tmp3 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
    final tmp4 = i1.readFuture(const _Vtable91(), tmp3.toIntUnsigned());
    final tmp5 = (tmp2, tmp4);
    i1.dartFree(tmp0, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp5;
  }
}

final class _Imported$0 implements i4.Types {
  const _Imported$0();
}

@pragma('wasm:import', 'component.stream142.new')
external i2.WasmI64 _streamNew142();
@pragma('wasm:import', 'component.stream142.read')
external i2.WasmI32 _streamRead142(
  i2.WasmI32 stream,
  i2.WasmI32 ptr,
  i2.WasmI32 n,
);
@pragma('wasm:import', 'component.stream142.write')
external i2.WasmI32 _streamWrite142(
  i2.WasmI32 stream,
  i2.WasmI32 ptr,
  i2.WasmI32 n,
);
@pragma('wasm:import', 'component.stream142.drop-readable')
external i2.WasmVoid _streamDropReadable142(i2.WasmI32 stream);
@pragma('wasm:import', 'component.stream142.drop-writable')
external i2.WasmVoid _streamDropWritable142(i2.WasmI32 stream);

final class _Vtable142 implements i1.StreamVtable<i3.Uint8List> {
  const _Vtable142();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i1
        .mallocAligned(const i2.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    i1.dartFree(
      address.toWasmI32(),
      (totalSize * 1).toWasmI32(),
      const i2.WasmI32(1),
    );
  }

  @override
  void writeToBuffer(int address, i3.Uint8List elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i2.WasmI32.fromInt(address + i);

      i1.memory.storeInt8(
        wasmAddress.toIntUnsigned(),
        i2.WasmI32.uint8FromInt(element),
        offset: 0,
      );
    }
  }

  @override
  i3.Uint8List readFromBuffer(int address, int count) {
    final typedList = i3.Uint8List(count);
    for (var i = 0; i < count; i++) {
      final ptr = i2.WasmI32.fromInt(address + i * 1);
      final tmp0 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);

      typedList[i] = tmp0.toIntUnsigned();
    }
    return typedList;
  }

  @override
  int newStream() => _streamNew142().toInt();
  @override
  void dropReadable(int stream) {
    _streamDropReadable142(i2.WasmI32.fromInt(stream));
  }

  @override
  void dropWritable(int stream) {
    _streamDropWritable142(i2.WasmI32.fromInt(stream));
  }

  @override
  int read(int stream, int ptr, int n) {
    return _streamRead142(
      i2.WasmI32.fromInt(stream),
      i2.WasmI32.fromInt(ptr),
      i2.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite142(
      i2.WasmI32.fromInt(stream),
      i2.WasmI32.fromInt(ptr),
      i2.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', r'component._drop$129')
external i2.WasmVoid _drop$129Raw(i2.WasmI32 handle);

void _drop$129(int handle) {
  _drop$129Raw(i2.WasmI32.fromInt(handle));
}

@pragma('wasm:import', 'component.future147.new')
external i2.WasmI64 _futureNew147();
@pragma('wasm:import', 'component.future147.write')
external i2.WasmI32 _futureWrite147(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future147.read')
external i2.WasmI32 _futureRead147(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future147.drop-readable')
external i2.WasmVoid _futureDropReadable147(i2.WasmI32 future);
@pragma('wasm:import', 'component.future147.drop-writable')
external i2.WasmVoid _futureDropWritable147(i2.WasmI32 future);

final class _Vtable147
    implements
        i1.FutureVtable<
          i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode>
        > {
  const _Vtable147();

  @override
  int newFuture() => _futureNew147().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead147(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite147(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable147(i2.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable147(i2.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i1
        .mallocAligned(const i2.WasmI32(8), const i2.WasmI32(40))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    if (containsValue) {
      final ptr = i2.WasmI32.fromInt(address);
      final tmp0 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);
      switch (tmp0) {
        case 0:
          final tmp1 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 8);
          switch (tmp1) {
            case 0:
              break;
            case 1:
              final tmp2 = i1.memory.loadInt32(ptr.toIntUnsigned(), offset: 12);
              final tmp3 = i1.Owned<i5.TypesFields>(
                tmp2.toIntUnsigned(),
                _drop$129,
              );
              tmp3.drop();
              break;
          }
          break;
        case 1:
          final tmp4 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 8);
          switch (tmp4) {
            case 0:
              break;
            case 1:
              final tmp5 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 16);
              switch (tmp5) {
                case 0:
                  break;
                case 1:
                  final tmp6 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp7 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp6, tmp7).free();
                  break;
              }
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
              final tmp8 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 20);
              switch (tmp8) {
                case 0:
                  break;
                case 1:
                  final tmp9 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  final tmp10 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 28,
                  );
                  i1.AllocatedString(tmp9, tmp10).free();
                  break;
              }
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
              final tmp11 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp11) {
                case 0:
                  break;
                case 1:
                  final tmp12 = i1.memory.loadUint8(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  switch (tmp12) {
                    case 0:
                      break;
                    case 1:
                      final tmp13 = i1.memory.loadInt32(
                        ptr.toIntUnsigned(),
                        offset: 24,
                      );
                      final tmp14 = i1.memory.loadInt32(
                        ptr.toIntUnsigned(),
                        offset: 28,
                      );
                      i1.AllocatedString(tmp13, tmp14).free();
                      break;
                  }
                  break;
              }
              break;
            case 23:
              break;
            case 24:
              final tmp15 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp15) {
                case 0:
                  break;
                case 1:
                  final tmp16 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp17 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp16, tmp17).free();
                  break;
              }
              break;
            case 25:
              break;
            case 26:
              break;
            case 27:
              final tmp18 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp18) {
                case 0:
                  break;
                case 1:
                  final tmp19 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp20 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp19, tmp20).free();
                  break;
              }
              break;
            case 28:
              break;
            case 29:
              break;
            case 30:
              final tmp21 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp21) {
                case 0:
                  break;
                case 1:
                  final tmp22 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp23 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp22, tmp23).free();
                  break;
              }
              break;
            case 31:
              final tmp24 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp24) {
                case 0:
                  break;
                case 1:
                  final tmp25 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp26 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp25, tmp26).free();
                  break;
              }
              break;
            case 32:
              final tmp27 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp27) {
                case 0:
                  break;
                case 1:
                  final tmp28 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp29 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp28, tmp29).free();
                  break;
              }
              break;
            case 33:
              break;
            case 34:
              break;
            case 35:
              break;
            case 36:
              break;
            case 37:
              break;
            case 38:
              final tmp30 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp30) {
                case 0:
                  break;
                case 1:
                  final tmp31 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp32 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp31, tmp32).free();
                  break;
              }
              break;
          }
          break;
      }
    }
    i1.dartFree(address.toWasmI32(), const i2.WasmI32(40), const i2.WasmI32(8));
  }

  @override
  void store(
    int address,
    i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode> value,
  ) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    switch (value) {
      case i1.OkResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(0),
          offset: 0,
        );
        final tmp0 = value;
        if (tmp0.hasValue) {
          final value = tmp0.requireValue();
          i1.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i2.WasmI32(1),
            offset: 8,
          );
          i1.memory.storeInt32(
            wasmAddress.toIntUnsigned(),
            value.handle.toWasmI32(),
            offset: 12,
          );
        } else {
          i1.memory.storeInt8(
            wasmAddress.toIntUnsigned(),
            const i2.WasmI32(0),
            offset: 8,
          );
        }

      case i1.ErrorResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(1),
          offset: 0,
        );
        switch (value) {
          case i5.TypesErrorCodeDnsTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(0),
              offset: 8,
            );

          case i5.TypesErrorCodeDnsError(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(1),
              offset: 8,
            );
            final tmp2 = value.rcode;
            if (tmp2.hasValue) {
              final value = tmp2.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp1 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp1.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp1.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp3 = value.infoCode;
            if (tmp3.hasValue) {
              final value = tmp3.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt16(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.uint16FromInt(value),
                offset: 30,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeDestinationNotFound():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(2),
              offset: 8,
            );

          case i5.TypesErrorCodeDestinationUnavailable():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(3),
              offset: 8,
            );

          case i5.TypesErrorCodeDestinationIpProhibited():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(4),
              offset: 8,
            );

          case i5.TypesErrorCodeDestinationIpUnroutable():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(5),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionRefused():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(6),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionTerminated():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(7),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(8),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionReadTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(9),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionWriteTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(10),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionLimitReached():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(11),
              offset: 8,
            );

          case i5.TypesErrorCodeTlsProtocolError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(12),
              offset: 8,
            );

          case i5.TypesErrorCodeTlsCertificateError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(13),
              offset: 8,
            );

          case i5.TypesErrorCodeTlsAlertReceived(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(14),
              offset: 8,
            );
            final tmp4 = value.alertId;
            if (tmp4.hasValue) {
              final value = tmp4.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.uint8FromInt(value),
                offset: 17,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp6 = value.alertMessage;
            if (tmp6.hasValue) {
              final value = tmp6.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 20,
              );
              final tmp5 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp5.packedLength,
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp5.ptr,
                offset: 24,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 20,
              );
            }

          case i5.TypesErrorCodeHttpRequestDenied():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(15),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestLengthRequired():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(16),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestBodySize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(17),
              offset: 8,
            );
            final tmp7 = value;
            if (tmp7.hasValue) {
              final value = tmp7.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt64(
                wasmAddress.toIntUnsigned(),
                i2.WasmI64.fromInt(value),
                offset: 24,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestMethodInvalid():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(18),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestUriInvalid():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(19),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestUriTooLong():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(20),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestHeaderSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(21),
              offset: 8,
            );
            final tmp8 = value;
            if (tmp8.hasValue) {
              final value = tmp8.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestHeaderSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(22),
              offset: 8,
            );
            final tmp12 = value;
            if (tmp12.hasValue) {
              final value = tmp12.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp10 = value.fieldName;
              if (tmp10.hasValue) {
                final value = tmp10.requireValue();
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(1),
                  offset: 20,
                );
                final tmp9 = i1.AllocatedString.allocateUtf16(value);
                i1.memory.storeInt32(
                  wasmAddress.toIntUnsigned(),
                  tmp9.packedLength,
                  offset: 28,
                );
                i1.memory.storeInt32(
                  wasmAddress.toIntUnsigned(),
                  tmp9.ptr,
                  offset: 24,
                );
              } else {
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(0),
                  offset: 20,
                );
              }
              final tmp11 = value.fieldSize;
              if (tmp11.hasValue) {
                final value = tmp11.requireValue();
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(1),
                  offset: 32,
                );
                i1.memory.storeInt32(
                  wasmAddress.toIntUnsigned(),
                  i2.WasmI32.fromInt(value),
                  offset: 36,
                );
              } else {
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(0),
                  offset: 32,
                );
              }
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestTrailerSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(23),
              offset: 8,
            );
            final tmp13 = value;
            if (tmp13.hasValue) {
              final value = tmp13.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestTrailerSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(24),
              offset: 8,
            );
            final tmp15 = value.fieldName;
            if (tmp15.hasValue) {
              final value = tmp15.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp14 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp14.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp14.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp16 = value.fieldSize;
            if (tmp16.hasValue) {
              final value = tmp16.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 32,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeHttpResponseIncomplete():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(25),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpResponseHeaderSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(26),
              offset: 8,
            );
            final tmp17 = value;
            if (tmp17.hasValue) {
              final value = tmp17.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseHeaderSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(27),
              offset: 8,
            );
            final tmp19 = value.fieldName;
            if (tmp19.hasValue) {
              final value = tmp19.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp18 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp18.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp18.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp20 = value.fieldSize;
            if (tmp20.hasValue) {
              final value = tmp20.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 32,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeHttpResponseBodySize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(28),
              offset: 8,
            );
            final tmp21 = value;
            if (tmp21.hasValue) {
              final value = tmp21.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt64(
                wasmAddress.toIntUnsigned(),
                i2.WasmI64.fromInt(value),
                offset: 24,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseTrailerSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(29),
              offset: 8,
            );
            final tmp22 = value;
            if (tmp22.hasValue) {
              final value = tmp22.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseTrailerSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(30),
              offset: 8,
            );
            final tmp24 = value.fieldName;
            if (tmp24.hasValue) {
              final value = tmp24.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp23 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp23.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp23.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp25 = value.fieldSize;
            if (tmp25.hasValue) {
              final value = tmp25.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 32,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeHttpResponseTransferCoding(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(31),
              offset: 8,
            );
            final tmp27 = value;
            if (tmp27.hasValue) {
              final value = tmp27.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp26 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp26.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp26.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseContentCoding(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(32),
              offset: 8,
            );
            final tmp29 = value;
            if (tmp29.hasValue) {
              final value = tmp29.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp28 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp28.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp28.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(33),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpUpgradeFailed():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(34),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpProtocolError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(35),
              offset: 8,
            );

          case i5.TypesErrorCodeLoopDetected():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(36),
              offset: 8,
            );

          case i5.TypesErrorCodeConfigurationError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(37),
              offset: 8,
            );

          case i5.TypesErrorCodeInternalError(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(38),
              offset: 8,
            );
            final tmp31 = value;
            if (tmp31.hasValue) {
              final value = tmp31.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp30 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp30.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp30.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
        }
    }
  }

  @override
  i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode> load(
    int address,
  ) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    final tmp0 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode>
    tmp87;
    if (tmp0.toBool()) {
      final tmp5 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp86;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp86 = i5.TypesErrorCodeDnsTimeout();
        case 1:
          final tmp6 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp8 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp9 = .some(i1.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          final tmp10 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp12;
          if (tmp10.toBool()) {
            final tmp11 = i1.memory.loadUint16(
              wasmAddress.toIntUnsigned(),
              offset: 30,
            );

            tmp12 = .some(tmp11.toIntUnsigned());
          } else {
            tmp12 = .none;
          }

          final tmp13 = (rcode: tmp9, infoCode: tmp12);

          tmp86 = i5.TypesErrorCodeDnsError(tmp13);
        case 2:
          tmp86 = i5.TypesErrorCodeDestinationNotFound();
        case 3:
          tmp86 = i5.TypesErrorCodeDestinationUnavailable();
        case 4:
          tmp86 = i5.TypesErrorCodeDestinationIpProhibited();
        case 5:
          tmp86 = i5.TypesErrorCodeDestinationIpUnroutable();
        case 6:
          tmp86 = i5.TypesErrorCodeConnectionRefused();
        case 7:
          tmp86 = i5.TypesErrorCodeConnectionTerminated();
        case 8:
          tmp86 = i5.TypesErrorCodeConnectionTimeout();
        case 9:
          tmp86 = i5.TypesErrorCodeConnectionReadTimeout();
        case 10:
          tmp86 = i5.TypesErrorCodeConnectionWriteTimeout();
        case 11:
          tmp86 = i5.TypesErrorCodeConnectionLimitReached();
        case 12:
          tmp86 = i5.TypesErrorCodeTlsProtocolError();
        case 13:
          tmp86 = i5.TypesErrorCodeTlsCertificateError();
        case 14:
          final tmp14 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp16;
          if (tmp14.toBool()) {
            final tmp15 = i1.memory.loadUint8(
              wasmAddress.toIntUnsigned(),
              offset: 17,
            );

            tmp16 = .some(tmp15.toIntUnsigned());
          } else {
            tmp16 = .none;
          }

          final tmp17 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 20,
          );
          final i1.Option<String> tmp20;
          if (tmp17.toBool()) {
            final tmp18 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );
            final tmp19 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 28,
            );

            tmp20 = .some(i1.AllocatedString.read(tmp18, tmp19));
          } else {
            tmp20 = .none;
          }

          final tmp21 = (alertId: tmp16, alertMessage: tmp20);

          tmp86 = i5.TypesErrorCodeTlsAlertReceived(tmp21);
        case 15:
          tmp86 = i5.TypesErrorCodeHttpRequestDenied();
        case 16:
          tmp86 = i5.TypesErrorCodeHttpRequestLengthRequired();
        case 17:
          final tmp22 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp24;
          if (tmp22.toBool()) {
            final tmp23 = i1.memory.loadInt64(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp24 = .some(tmp23.toInt());
          } else {
            tmp24 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpRequestBodySize(tmp24);
        case 18:
          tmp86 = i5.TypesErrorCodeHttpRequestMethodInvalid();
        case 19:
          tmp86 = i5.TypesErrorCodeHttpRequestUriInvalid();
        case 20:
          tmp86 = i5.TypesErrorCodeHttpRequestUriTooLong();
        case 21:
          final tmp25 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp27;
          if (tmp25.toBool()) {
            final tmp26 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp27 = .some(tmp26.toIntUnsigned());
          } else {
            tmp27 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpRequestHeaderSectionSize(tmp27);
        case 22:
          final tmp28 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<
            ({i1.Option<String> fieldName, i1.Option<int> fieldSize})
          >
          tmp37;
          if (tmp28.toBool()) {
            final tmp29 = i1.memory.loadUint8(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final i1.Option<String> tmp32;
            if (tmp29.toBool()) {
              final tmp30 = i1.memory.loadInt32(
                wasmAddress.toIntUnsigned(),
                offset: 24,
              );
              final tmp31 = i1.memory.loadInt32(
                wasmAddress.toIntUnsigned(),
                offset: 28,
              );

              tmp32 = .some(i1.AllocatedString.read(tmp30, tmp31));
            } else {
              tmp32 = .none;
            }

            final tmp33 = i1.memory.loadUint8(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );
            final i1.Option<int> tmp35;
            if (tmp33.toBool()) {
              final tmp34 = i1.memory.loadInt32(
                wasmAddress.toIntUnsigned(),
                offset: 36,
              );

              tmp35 = .some(tmp34.toIntUnsigned());
            } else {
              tmp35 = .none;
            }

            final tmp36 = (fieldName: tmp32, fieldSize: tmp35);

            tmp37 = .some(tmp36);
          } else {
            tmp37 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpRequestHeaderSize(tmp37);
        case 23:
          final tmp38 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp40;
          if (tmp38.toBool()) {
            final tmp39 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp40 = .some(tmp39.toIntUnsigned());
          } else {
            tmp40 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpRequestTrailerSectionSize(tmp40);
        case 24:
          final tmp41 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp44;
          if (tmp41.toBool()) {
            final tmp42 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp43 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp44 = .some(i1.AllocatedString.read(tmp42, tmp43));
          } else {
            tmp44 = .none;
          }

          final tmp45 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp47;
          if (tmp45.toBool()) {
            final tmp46 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );

            tmp47 = .some(tmp46.toIntUnsigned());
          } else {
            tmp47 = .none;
          }

          final tmp48 = (fieldName: tmp44, fieldSize: tmp47);

          tmp86 = i5.TypesErrorCodeHttpRequestTrailerSize(tmp48);
        case 25:
          tmp86 = i5.TypesErrorCodeHttpResponseIncomplete();
        case 26:
          final tmp49 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp51;
          if (tmp49.toBool()) {
            final tmp50 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp51 = .some(tmp50.toIntUnsigned());
          } else {
            tmp51 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpResponseHeaderSectionSize(tmp51);
        case 27:
          final tmp52 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp55;
          if (tmp52.toBool()) {
            final tmp53 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp54 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp55 = .some(i1.AllocatedString.read(tmp53, tmp54));
          } else {
            tmp55 = .none;
          }

          final tmp56 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp58;
          if (tmp56.toBool()) {
            final tmp57 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );

            tmp58 = .some(tmp57.toIntUnsigned());
          } else {
            tmp58 = .none;
          }

          final tmp59 = (fieldName: tmp55, fieldSize: tmp58);

          tmp86 = i5.TypesErrorCodeHttpResponseHeaderSize(tmp59);
        case 28:
          final tmp60 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp62;
          if (tmp60.toBool()) {
            final tmp61 = i1.memory.loadInt64(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp62 = .some(tmp61.toInt());
          } else {
            tmp62 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpResponseBodySize(tmp62);
        case 29:
          final tmp63 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp65;
          if (tmp63.toBool()) {
            final tmp64 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp65 = .some(tmp64.toIntUnsigned());
          } else {
            tmp65 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpResponseTrailerSectionSize(tmp65);
        case 30:
          final tmp66 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp69;
          if (tmp66.toBool()) {
            final tmp67 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp68 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp69 = .some(i1.AllocatedString.read(tmp67, tmp68));
          } else {
            tmp69 = .none;
          }

          final tmp70 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp72;
          if (tmp70.toBool()) {
            final tmp71 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );

            tmp72 = .some(tmp71.toIntUnsigned());
          } else {
            tmp72 = .none;
          }

          final tmp73 = (fieldName: tmp69, fieldSize: tmp72);

          tmp86 = i5.TypesErrorCodeHttpResponseTrailerSize(tmp73);
        case 31:
          final tmp74 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp77;
          if (tmp74.toBool()) {
            final tmp75 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp76 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp77 = .some(i1.AllocatedString.read(tmp75, tmp76));
          } else {
            tmp77 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpResponseTransferCoding(tmp77);
        case 32:
          final tmp78 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp81;
          if (tmp78.toBool()) {
            final tmp79 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp80 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp81 = .some(i1.AllocatedString.read(tmp79, tmp80));
          } else {
            tmp81 = .none;
          }

          tmp86 = i5.TypesErrorCodeHttpResponseContentCoding(tmp81);
        case 33:
          tmp86 = i5.TypesErrorCodeHttpResponseTimeout();
        case 34:
          tmp86 = i5.TypesErrorCodeHttpUpgradeFailed();
        case 35:
          tmp86 = i5.TypesErrorCodeHttpProtocolError();
        case 36:
          tmp86 = i5.TypesErrorCodeLoopDetected();
        case 37:
          tmp86 = i5.TypesErrorCodeConfigurationError();
        case 38:
          final tmp82 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp85;
          if (tmp82.toBool()) {
            final tmp83 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp84 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp85 = .some(i1.AllocatedString.read(tmp83, tmp84));
          } else {
            tmp85 = .none;
          }

          tmp86 = i5.TypesErrorCodeInternalError(tmp85);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp87 = .error(tmp86);
    } else {
      final tmp1 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 8);
      final i1.Option<i1.Owned<i5.TypesFields>> tmp4;
      if (tmp1.toBool()) {
        final tmp2 = i1.memory.loadInt32(
          wasmAddress.toIntUnsigned(),
          offset: 12,
        );
        final tmp3 = i1.Owned<i5.TypesFields>(tmp2.toIntUnsigned(), _drop$129);
        tmp4 = .some(tmp3);
      } else {
        tmp4 = .none;
      }

      tmp87 = .ok(tmp4);
    }

    return tmp87;
  }
}

@pragma('wasm:import', 'component.future151.new')
external i2.WasmI64 _futureNew151();
@pragma('wasm:import', 'component.future151.write')
external i2.WasmI32 _futureWrite151(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future151.read')
external i2.WasmI32 _futureRead151(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future151.drop-readable')
external i2.WasmVoid _futureDropReadable151(i2.WasmI32 future);
@pragma('wasm:import', 'component.future151.drop-writable')
external i2.WasmVoid _futureDropWritable151(i2.WasmI32 future);

final class _Vtable151
    implements i1.FutureVtable<i1.Result<void, i5.TypesErrorCode>> {
  const _Vtable151();

  @override
  int newFuture() => _futureNew151().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead151(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite151(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable151(i2.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable151(i2.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i1
        .mallocAligned(const i2.WasmI32(8), const i2.WasmI32(40))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    if (containsValue) {
      final ptr = i2.WasmI32.fromInt(address);
      final tmp0 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 0);
      switch (tmp0) {
        case 0:
          break;
        case 1:
          final tmp1 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 8);
          switch (tmp1) {
            case 0:
              break;
            case 1:
              final tmp2 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 16);
              switch (tmp2) {
                case 0:
                  break;
                case 1:
                  final tmp3 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp4 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp3, tmp4).free();
                  break;
              }
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
              final tmp5 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 20);
              switch (tmp5) {
                case 0:
                  break;
                case 1:
                  final tmp6 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  final tmp7 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 28,
                  );
                  i1.AllocatedString(tmp6, tmp7).free();
                  break;
              }
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
              final tmp8 = i1.memory.loadUint8(ptr.toIntUnsigned(), offset: 16);
              switch (tmp8) {
                case 0:
                  break;
                case 1:
                  final tmp9 = i1.memory.loadUint8(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  switch (tmp9) {
                    case 0:
                      break;
                    case 1:
                      final tmp10 = i1.memory.loadInt32(
                        ptr.toIntUnsigned(),
                        offset: 24,
                      );
                      final tmp11 = i1.memory.loadInt32(
                        ptr.toIntUnsigned(),
                        offset: 28,
                      );
                      i1.AllocatedString(tmp10, tmp11).free();
                      break;
                  }
                  break;
              }
              break;
            case 23:
              break;
            case 24:
              final tmp12 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp12) {
                case 0:
                  break;
                case 1:
                  final tmp13 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp14 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp13, tmp14).free();
                  break;
              }
              break;
            case 25:
              break;
            case 26:
              break;
            case 27:
              final tmp15 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp15) {
                case 0:
                  break;
                case 1:
                  final tmp16 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp17 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp16, tmp17).free();
                  break;
              }
              break;
            case 28:
              break;
            case 29:
              break;
            case 30:
              final tmp18 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp18) {
                case 0:
                  break;
                case 1:
                  final tmp19 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp20 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp19, tmp20).free();
                  break;
              }
              break;
            case 31:
              final tmp21 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp21) {
                case 0:
                  break;
                case 1:
                  final tmp22 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp23 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp22, tmp23).free();
                  break;
              }
              break;
            case 32:
              final tmp24 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp24) {
                case 0:
                  break;
                case 1:
                  final tmp25 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp26 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp25, tmp26).free();
                  break;
              }
              break;
            case 33:
              break;
            case 34:
              break;
            case 35:
              break;
            case 36:
              break;
            case 37:
              break;
            case 38:
              final tmp27 = i1.memory.loadUint8(
                ptr.toIntUnsigned(),
                offset: 16,
              );
              switch (tmp27) {
                case 0:
                  break;
                case 1:
                  final tmp28 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 20,
                  );
                  final tmp29 = i1.memory.loadInt32(
                    ptr.toIntUnsigned(),
                    offset: 24,
                  );
                  i1.AllocatedString(tmp28, tmp29).free();
                  break;
              }
              break;
          }
          break;
      }
    }
    i1.dartFree(address.toWasmI32(), const i2.WasmI32(40), const i2.WasmI32(8));
  }

  @override
  void store(int address, i1.Result<void, i5.TypesErrorCode> value) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    switch (value) {
      case i1.OkResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(0),
          offset: 0,
        );

      case i1.ErrorResult(:final value):
        i1.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i2.WasmI32(1),
          offset: 0,
        );
        switch (value) {
          case i5.TypesErrorCodeDnsTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(0),
              offset: 8,
            );

          case i5.TypesErrorCodeDnsError(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(1),
              offset: 8,
            );
            final tmp1 = value.rcode;
            if (tmp1.hasValue) {
              final value = tmp1.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp0 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp0.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp0.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp2 = value.infoCode;
            if (tmp2.hasValue) {
              final value = tmp2.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt16(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.uint16FromInt(value),
                offset: 30,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeDestinationNotFound():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(2),
              offset: 8,
            );

          case i5.TypesErrorCodeDestinationUnavailable():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(3),
              offset: 8,
            );

          case i5.TypesErrorCodeDestinationIpProhibited():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(4),
              offset: 8,
            );

          case i5.TypesErrorCodeDestinationIpUnroutable():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(5),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionRefused():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(6),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionTerminated():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(7),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(8),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionReadTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(9),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionWriteTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(10),
              offset: 8,
            );

          case i5.TypesErrorCodeConnectionLimitReached():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(11),
              offset: 8,
            );

          case i5.TypesErrorCodeTlsProtocolError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(12),
              offset: 8,
            );

          case i5.TypesErrorCodeTlsCertificateError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(13),
              offset: 8,
            );

          case i5.TypesErrorCodeTlsAlertReceived(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(14),
              offset: 8,
            );
            final tmp3 = value.alertId;
            if (tmp3.hasValue) {
              final value = tmp3.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.uint8FromInt(value),
                offset: 17,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp5 = value.alertMessage;
            if (tmp5.hasValue) {
              final value = tmp5.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 20,
              );
              final tmp4 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp4.packedLength,
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp4.ptr,
                offset: 24,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 20,
              );
            }

          case i5.TypesErrorCodeHttpRequestDenied():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(15),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestLengthRequired():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(16),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestBodySize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(17),
              offset: 8,
            );
            final tmp6 = value;
            if (tmp6.hasValue) {
              final value = tmp6.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt64(
                wasmAddress.toIntUnsigned(),
                i2.WasmI64.fromInt(value),
                offset: 24,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestMethodInvalid():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(18),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestUriInvalid():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(19),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestUriTooLong():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(20),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpRequestHeaderSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(21),
              offset: 8,
            );
            final tmp7 = value;
            if (tmp7.hasValue) {
              final value = tmp7.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestHeaderSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(22),
              offset: 8,
            );
            final tmp11 = value;
            if (tmp11.hasValue) {
              final value = tmp11.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp9 = value.fieldName;
              if (tmp9.hasValue) {
                final value = tmp9.requireValue();
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(1),
                  offset: 20,
                );
                final tmp8 = i1.AllocatedString.allocateUtf16(value);
                i1.memory.storeInt32(
                  wasmAddress.toIntUnsigned(),
                  tmp8.packedLength,
                  offset: 28,
                );
                i1.memory.storeInt32(
                  wasmAddress.toIntUnsigned(),
                  tmp8.ptr,
                  offset: 24,
                );
              } else {
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(0),
                  offset: 20,
                );
              }
              final tmp10 = value.fieldSize;
              if (tmp10.hasValue) {
                final value = tmp10.requireValue();
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(1),
                  offset: 32,
                );
                i1.memory.storeInt32(
                  wasmAddress.toIntUnsigned(),
                  i2.WasmI32.fromInt(value),
                  offset: 36,
                );
              } else {
                i1.memory.storeInt8(
                  wasmAddress.toIntUnsigned(),
                  const i2.WasmI32(0),
                  offset: 32,
                );
              }
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestTrailerSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(23),
              offset: 8,
            );
            final tmp12 = value;
            if (tmp12.hasValue) {
              final value = tmp12.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpRequestTrailerSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(24),
              offset: 8,
            );
            final tmp14 = value.fieldName;
            if (tmp14.hasValue) {
              final value = tmp14.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp13 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp13.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp13.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp15 = value.fieldSize;
            if (tmp15.hasValue) {
              final value = tmp15.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 32,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeHttpResponseIncomplete():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(25),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpResponseHeaderSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(26),
              offset: 8,
            );
            final tmp16 = value;
            if (tmp16.hasValue) {
              final value = tmp16.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseHeaderSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(27),
              offset: 8,
            );
            final tmp18 = value.fieldName;
            if (tmp18.hasValue) {
              final value = tmp18.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp17 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp17.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp17.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp19 = value.fieldSize;
            if (tmp19.hasValue) {
              final value = tmp19.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 32,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeHttpResponseBodySize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(28),
              offset: 8,
            );
            final tmp20 = value;
            if (tmp20.hasValue) {
              final value = tmp20.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt64(
                wasmAddress.toIntUnsigned(),
                i2.WasmI64.fromInt(value),
                offset: 24,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseTrailerSectionSize(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(29),
              offset: 8,
            );
            final tmp21 = value;
            if (tmp21.hasValue) {
              final value = tmp21.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseTrailerSize(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(30),
              offset: 8,
            );
            final tmp23 = value.fieldName;
            if (tmp23.hasValue) {
              final value = tmp23.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp22 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp22.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp22.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
            final tmp24 = value.fieldSize;
            if (tmp24.hasValue) {
              final value = tmp24.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 28,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                i2.WasmI32.fromInt(value),
                offset: 32,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 28,
              );
            }

          case i5.TypesErrorCodeHttpResponseTransferCoding(
            payload: final value,
          ):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(31),
              offset: 8,
            );
            final tmp26 = value;
            if (tmp26.hasValue) {
              final value = tmp26.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp25 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp25.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp25.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseContentCoding(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(32),
              offset: 8,
            );
            final tmp28 = value;
            if (tmp28.hasValue) {
              final value = tmp28.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp27 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp27.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp27.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }

          case i5.TypesErrorCodeHttpResponseTimeout():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(33),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpUpgradeFailed():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(34),
              offset: 8,
            );

          case i5.TypesErrorCodeHttpProtocolError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(35),
              offset: 8,
            );

          case i5.TypesErrorCodeLoopDetected():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(36),
              offset: 8,
            );

          case i5.TypesErrorCodeConfigurationError():
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(37),
              offset: 8,
            );

          case i5.TypesErrorCodeInternalError(payload: final value):
            i1.memory.storeInt8(
              wasmAddress.toIntUnsigned(),
              const i2.WasmI32(38),
              offset: 8,
            );
            final tmp30 = value;
            if (tmp30.hasValue) {
              final value = tmp30.requireValue();
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(1),
                offset: 16,
              );
              final tmp29 = i1.AllocatedString.allocateUtf16(value);
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp29.packedLength,
                offset: 24,
              );
              i1.memory.storeInt32(
                wasmAddress.toIntUnsigned(),
                tmp29.ptr,
                offset: 20,
              );
            } else {
              i1.memory.storeInt8(
                wasmAddress.toIntUnsigned(),
                const i2.WasmI32(0),
                offset: 16,
              );
            }
        }
    }
  }

  @override
  i1.Result<void, i5.TypesErrorCode> load(int address) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    final tmp0 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesErrorCode> tmp83;
    if (tmp0.toBool()) {
      final tmp1 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp82;
      switch (tmp1.toIntUnsigned()) {
        case 0:
          tmp82 = i5.TypesErrorCodeDnsTimeout();
        case 1:
          final tmp2 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp5;
          if (tmp2.toBool()) {
            final tmp3 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp4 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp5 = .some(i1.AllocatedString.read(tmp3, tmp4));
          } else {
            tmp5 = .none;
          }

          final tmp6 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp8;
          if (tmp6.toBool()) {
            final tmp7 = i1.memory.loadUint16(
              wasmAddress.toIntUnsigned(),
              offset: 30,
            );

            tmp8 = .some(tmp7.toIntUnsigned());
          } else {
            tmp8 = .none;
          }

          final tmp9 = (rcode: tmp5, infoCode: tmp8);

          tmp82 = i5.TypesErrorCodeDnsError(tmp9);
        case 2:
          tmp82 = i5.TypesErrorCodeDestinationNotFound();
        case 3:
          tmp82 = i5.TypesErrorCodeDestinationUnavailable();
        case 4:
          tmp82 = i5.TypesErrorCodeDestinationIpProhibited();
        case 5:
          tmp82 = i5.TypesErrorCodeDestinationIpUnroutable();
        case 6:
          tmp82 = i5.TypesErrorCodeConnectionRefused();
        case 7:
          tmp82 = i5.TypesErrorCodeConnectionTerminated();
        case 8:
          tmp82 = i5.TypesErrorCodeConnectionTimeout();
        case 9:
          tmp82 = i5.TypesErrorCodeConnectionReadTimeout();
        case 10:
          tmp82 = i5.TypesErrorCodeConnectionWriteTimeout();
        case 11:
          tmp82 = i5.TypesErrorCodeConnectionLimitReached();
        case 12:
          tmp82 = i5.TypesErrorCodeTlsProtocolError();
        case 13:
          tmp82 = i5.TypesErrorCodeTlsCertificateError();
        case 14:
          final tmp10 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp12;
          if (tmp10.toBool()) {
            final tmp11 = i1.memory.loadUint8(
              wasmAddress.toIntUnsigned(),
              offset: 17,
            );

            tmp12 = .some(tmp11.toIntUnsigned());
          } else {
            tmp12 = .none;
          }

          final tmp13 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 20,
          );
          final i1.Option<String> tmp16;
          if (tmp13.toBool()) {
            final tmp14 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );
            final tmp15 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 28,
            );

            tmp16 = .some(i1.AllocatedString.read(tmp14, tmp15));
          } else {
            tmp16 = .none;
          }

          final tmp17 = (alertId: tmp12, alertMessage: tmp16);

          tmp82 = i5.TypesErrorCodeTlsAlertReceived(tmp17);
        case 15:
          tmp82 = i5.TypesErrorCodeHttpRequestDenied();
        case 16:
          tmp82 = i5.TypesErrorCodeHttpRequestLengthRequired();
        case 17:
          final tmp18 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp20;
          if (tmp18.toBool()) {
            final tmp19 = i1.memory.loadInt64(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp20 = .some(tmp19.toInt());
          } else {
            tmp20 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpRequestBodySize(tmp20);
        case 18:
          tmp82 = i5.TypesErrorCodeHttpRequestMethodInvalid();
        case 19:
          tmp82 = i5.TypesErrorCodeHttpRequestUriInvalid();
        case 20:
          tmp82 = i5.TypesErrorCodeHttpRequestUriTooLong();
        case 21:
          final tmp21 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp23;
          if (tmp21.toBool()) {
            final tmp22 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp23 = .some(tmp22.toIntUnsigned());
          } else {
            tmp23 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpRequestHeaderSectionSize(tmp23);
        case 22:
          final tmp24 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<
            ({i1.Option<String> fieldName, i1.Option<int> fieldSize})
          >
          tmp33;
          if (tmp24.toBool()) {
            final tmp25 = i1.memory.loadUint8(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final i1.Option<String> tmp28;
            if (tmp25.toBool()) {
              final tmp26 = i1.memory.loadInt32(
                wasmAddress.toIntUnsigned(),
                offset: 24,
              );
              final tmp27 = i1.memory.loadInt32(
                wasmAddress.toIntUnsigned(),
                offset: 28,
              );

              tmp28 = .some(i1.AllocatedString.read(tmp26, tmp27));
            } else {
              tmp28 = .none;
            }

            final tmp29 = i1.memory.loadUint8(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );
            final i1.Option<int> tmp31;
            if (tmp29.toBool()) {
              final tmp30 = i1.memory.loadInt32(
                wasmAddress.toIntUnsigned(),
                offset: 36,
              );

              tmp31 = .some(tmp30.toIntUnsigned());
            } else {
              tmp31 = .none;
            }

            final tmp32 = (fieldName: tmp28, fieldSize: tmp31);

            tmp33 = .some(tmp32);
          } else {
            tmp33 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpRequestHeaderSize(tmp33);
        case 23:
          final tmp34 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp36;
          if (tmp34.toBool()) {
            final tmp35 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp36 = .some(tmp35.toIntUnsigned());
          } else {
            tmp36 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpRequestTrailerSectionSize(tmp36);
        case 24:
          final tmp37 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp40;
          if (tmp37.toBool()) {
            final tmp38 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp39 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp40 = .some(i1.AllocatedString.read(tmp38, tmp39));
          } else {
            tmp40 = .none;
          }

          final tmp41 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp43;
          if (tmp41.toBool()) {
            final tmp42 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );

            tmp43 = .some(tmp42.toIntUnsigned());
          } else {
            tmp43 = .none;
          }

          final tmp44 = (fieldName: tmp40, fieldSize: tmp43);

          tmp82 = i5.TypesErrorCodeHttpRequestTrailerSize(tmp44);
        case 25:
          tmp82 = i5.TypesErrorCodeHttpResponseIncomplete();
        case 26:
          final tmp45 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp47;
          if (tmp45.toBool()) {
            final tmp46 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp47 = .some(tmp46.toIntUnsigned());
          } else {
            tmp47 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpResponseHeaderSectionSize(tmp47);
        case 27:
          final tmp48 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp51;
          if (tmp48.toBool()) {
            final tmp49 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp50 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp51 = .some(i1.AllocatedString.read(tmp49, tmp50));
          } else {
            tmp51 = .none;
          }

          final tmp52 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp54;
          if (tmp52.toBool()) {
            final tmp53 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );

            tmp54 = .some(tmp53.toIntUnsigned());
          } else {
            tmp54 = .none;
          }

          final tmp55 = (fieldName: tmp51, fieldSize: tmp54);

          tmp82 = i5.TypesErrorCodeHttpResponseHeaderSize(tmp55);
        case 28:
          final tmp56 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp58;
          if (tmp56.toBool()) {
            final tmp57 = i1.memory.loadInt64(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp58 = .some(tmp57.toInt());
          } else {
            tmp58 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpResponseBodySize(tmp58);
        case 29:
          final tmp59 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<int> tmp61;
          if (tmp59.toBool()) {
            final tmp60 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );

            tmp61 = .some(tmp60.toIntUnsigned());
          } else {
            tmp61 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpResponseTrailerSectionSize(tmp61);
        case 30:
          final tmp62 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp65;
          if (tmp62.toBool()) {
            final tmp63 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp64 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp65 = .some(i1.AllocatedString.read(tmp63, tmp64));
          } else {
            tmp65 = .none;
          }

          final tmp66 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 28,
          );
          final i1.Option<int> tmp68;
          if (tmp66.toBool()) {
            final tmp67 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 32,
            );

            tmp68 = .some(tmp67.toIntUnsigned());
          } else {
            tmp68 = .none;
          }

          final tmp69 = (fieldName: tmp65, fieldSize: tmp68);

          tmp82 = i5.TypesErrorCodeHttpResponseTrailerSize(tmp69);
        case 31:
          final tmp70 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp73;
          if (tmp70.toBool()) {
            final tmp71 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp72 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp73 = .some(i1.AllocatedString.read(tmp71, tmp72));
          } else {
            tmp73 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpResponseTransferCoding(tmp73);
        case 32:
          final tmp74 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp77;
          if (tmp74.toBool()) {
            final tmp75 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp76 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp77 = .some(i1.AllocatedString.read(tmp75, tmp76));
          } else {
            tmp77 = .none;
          }

          tmp82 = i5.TypesErrorCodeHttpResponseContentCoding(tmp77);
        case 33:
          tmp82 = i5.TypesErrorCodeHttpResponseTimeout();
        case 34:
          tmp82 = i5.TypesErrorCodeHttpUpgradeFailed();
        case 35:
          tmp82 = i5.TypesErrorCodeHttpProtocolError();
        case 36:
          tmp82 = i5.TypesErrorCodeLoopDetected();
        case 37:
          tmp82 = i5.TypesErrorCodeConfigurationError();
        case 38:
          final tmp78 = i1.memory.loadUint8(
            wasmAddress.toIntUnsigned(),
            offset: 16,
          );
          final i1.Option<String> tmp81;
          if (tmp78.toBool()) {
            final tmp79 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 20,
            );
            final tmp80 = i1.memory.loadInt32(
              wasmAddress.toIntUnsigned(),
              offset: 24,
            );

            tmp81 = .some(i1.AllocatedString.read(tmp79, tmp80));
          } else {
            tmp81 = .none;
          }

          tmp82 = i5.TypesErrorCodeInternalError(tmp81);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp83 = .error(tmp82);
    } else {
      tmp83 = .ok(null);
    }

    return tmp83;
  }
}

@pragma('wasm:import', r'component._drop$127')
external i2.WasmVoid _drop$127Raw(i2.WasmI32 handle);

void _drop$127(int handle) {
  _drop$127Raw(i2.WasmI32.fromInt(handle));
}

@pragma("wasm:import", r"component._import39")
external i2.WasmI32 _import39();
@pragma("wasm:import", r"component._import41")
external i2.WasmVoid _import41(i2.WasmI32 p0, i2.WasmI32 p1, i2.WasmI32 p2);
@pragma("wasm:import", r"component._import42")
external i2.WasmVoid _import42(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import43")
external i2.WasmI32 _import43(i2.WasmI32 p0, i2.WasmI32 p1, i2.WasmI32 p2);
@pragma("wasm:import", r"component._import44")
external i2.WasmVoid _import44(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
  i2.WasmI32 p4,
  i2.WasmI32 p5,
);
@pragma("wasm:import", r"component._import45")
external i2.WasmVoid _import45(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import46")
external i2.WasmVoid _import46(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import47")
external i2.WasmVoid _import47(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
  i2.WasmI32 p4,
  i2.WasmI32 p5,
);
@pragma("wasm:import", r"component._import48")
external i2.WasmVoid _import48(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import49")
external i2.WasmI32 _import49(i2.WasmI32 p0);

@pragma('wasm:import', r'component._drop$130')
external i2.WasmVoid _drop$130Raw(i2.WasmI32 handle);

void _drop$130(int handle) {
  _drop$130Raw(i2.WasmI32.fromInt(handle));
}

@pragma("wasm:import", r"component._import50")
external i2.WasmVoid _import50(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
  i2.WasmI32 p4,
  i2.WasmI32 p5,
  i2.WasmI32 p6,
);
@pragma("wasm:import", r"component._import52")
external i2.WasmVoid _import52(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import53")
external i2.WasmI32 _import53(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import54")
external i2.WasmVoid _import54(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import55")
external i2.WasmI32 _import55(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import56")
external i2.WasmVoid _import56(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import57")
external i2.WasmI32 _import57(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
  i2.WasmI32 p4,
);
@pragma("wasm:import", r"component._import58")
external i2.WasmVoid _import58(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import59")
external i2.WasmI32 _import59(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
);

@pragma('wasm:import', r'component._drop$131')
external i2.WasmVoid _drop$131Raw(i2.WasmI32 handle);

void _drop$131(int handle) {
  _drop$131Raw(i2.WasmI32.fromInt(handle));
}

@pragma("wasm:import", r"component._import60")
external i2.WasmVoid _import60(i2.WasmI32 p0, i2.WasmI32 p1);

@pragma('wasm:import', r'component._drop$128')
external i2.WasmVoid _drop$128Raw(i2.WasmI32 handle);

void _drop$128(int handle) {
  _drop$128Raw(i2.WasmI32.fromInt(handle));
}

@pragma("wasm:import", r"component._import62")
external i2.WasmI32 _import62(i2.WasmI32 p0);
@pragma("wasm:import", r"component._import64")
external i2.WasmVoid _import64(i2.WasmI32 p0, i2.WasmI32 p1, i2.WasmI32 p2);
@pragma("wasm:import", r"component._import65")
external i2.WasmI32 _import65();
@pragma("wasm:import", r"component._import66")
external i2.WasmVoid _import66(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import67")
external i2.WasmVoid _import67(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI64 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import68")
external i2.WasmVoid _import68(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import69")
external i2.WasmVoid _import69(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI64 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import70")
external i2.WasmVoid _import70(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import71")
external i2.WasmVoid _import71(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI64 p2,
  i2.WasmI32 p3,
);
@pragma("wasm:import", r"component._import72")
external i2.WasmI32 _import72(i2.WasmI32 p0);

@pragma('wasm:import', r'component._drop$133')
external i2.WasmVoid _drop$133Raw(i2.WasmI32 handle);

void _drop$133(int handle) {
  _drop$133Raw(i2.WasmI32.fromInt(handle));
}

@pragma("wasm:import", r"component._import73")
external i2.WasmVoid _import73(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI32 p3,
  i2.WasmI32 p4,
);
@pragma("wasm:import", r"component._import75")
external i2.WasmI32 _import75(i2.WasmI32 p0);
@pragma("wasm:import", r"component._import76")
external i2.WasmI32 _import76(i2.WasmI32 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import77")
external i2.WasmI32 _import77(i2.WasmI32 p0);
@pragma("wasm:import", r"component._import78")
external i2.WasmVoid _import78(i2.WasmI32 p0, i2.WasmI32 p1, i2.WasmI32 p2);

final class _Imported$23 implements i5.Types {
  const _Imported$23();
  @override
  i1.Owned<i5.TypesFields> constructorFields() {
    final tmp0 = _import39();
    final tmp1 = i1.Owned<i5.TypesFields>(tmp0.toIntUnsigned(), _drop$127);
    return tmp1;
  }

  @override
  i1.Result<i1.Owned<i5.TypesFields>, i5.TypesHeaderError>
  staticFieldsFromList({required List<(String, List<int>)> entries}) {
    final tmp4 = i2.WasmI32.fromInt(16 * entries.length);
    final tmp5 = i1.mallocAligned(const i2.WasmI32(4), tmp4);
    var tmp6 = tmp5;
    for (final element in entries) {
      final elementPtr = tmp6;
      final tmp0 = i1.AllocatedString.allocateUtf16(element.$1);
      i1.memory.storeInt32(
        elementPtr.toIntUnsigned(),
        tmp0.packedLength,
        offset: 4,
      );
      i1.memory.storeInt32(elementPtr.toIntUnsigned(), tmp0.ptr, offset: 0);

      final tmp1 = i2.WasmI32.fromInt(1 * element.$2.length);
      final tmp2 = i1.mallocAligned(const i2.WasmI32(1), tmp1);
      var tmp3 = tmp2;
      for (final element in element.$2) {
        final elementPtr = tmp3;
        i1.memory.storeInt8(
          elementPtr.toIntUnsigned(),
          i2.WasmI32.uint8FromInt(element),
          offset: 0,
        );

        tmp3 += const i2.WasmI32(1);
      }

      i1.memory.storeInt32(
        elementPtr.toIntUnsigned(),
        i2.WasmI32.fromInt(element.$2.length),
        offset: 12,
      );
      i1.memory.storeInt32(elementPtr.toIntUnsigned(), tmp2, offset: 8);

      tmp6 += const i2.WasmI32(16);
      tmp0.free();
      i1.dartFree(tmp2, tmp1, const i2.WasmI32(1));
    }

    var tmp7 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import41(tmp5, i2.WasmI32.fromInt(entries.length), tmp7);
    final tmp8 = i1.memory.loadUint8(tmp7.toIntUnsigned(), offset: 0);
    final i1.Result<i1.Owned<i5.TypesFields>, i5.TypesHeaderError> tmp17;
    if (tmp8.toBool()) {
      final tmp11 = i1.memory.loadUint8(tmp7.toIntUnsigned(), offset: 4);
      final i5.TypesHeaderError tmp16;
      switch (tmp11.toIntUnsigned()) {
        case 0:
          tmp16 = i5.TypesHeaderErrorInvalidSyntax();
        case 1:
          tmp16 = i5.TypesHeaderErrorForbidden();
        case 2:
          tmp16 = i5.TypesHeaderErrorImmutable();
        case 3:
          tmp16 = i5.TypesHeaderErrorSizeExceeded();
        case 4:
          final tmp12 = i1.memory.loadUint8(tmp7.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp15;
          if (tmp12.toBool()) {
            final tmp13 = i1.memory.loadInt32(tmp7.toIntUnsigned(), offset: 12);
            final tmp14 = i1.memory.loadInt32(tmp7.toIntUnsigned(), offset: 16);

            tmp15 = .some(i1.AllocatedString.read(tmp13, tmp14));
          } else {
            tmp15 = .none;
          }

          tmp16 = i5.TypesHeaderErrorOther(tmp15);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp17 = .error(tmp16);
    } else {
      final tmp9 = i1.memory.loadInt32(tmp7.toIntUnsigned(), offset: 4);
      final tmp10 = i1.Owned<i5.TypesFields>(tmp9.toIntUnsigned(), _drop$127);
      tmp17 = .ok(tmp10);
    }

    i1.dartFree(tmp5, tmp4, const i2.WasmI32(4));
    i1.dartFree(tmp7, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp17;
  }

  @override
  List<List<int>> methodFieldsGet({
    required i1.Borrowed<i5.TypesFields> self,
    required String name,
  }) {
    final tmp0 = i1.AllocatedString.allocateUtf16(name);
    var tmp1 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import42(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1);
    final tmp2 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 0);
    final tmp3 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 4);

    final tmp10 = tmp2.toIntUnsigned();
    final tmp9 = List.generate(tmp3.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i2.WasmI32.fromInt(tmp10 + i * 8);
      final tmp4 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 0);
      final tmp5 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 4);

      final tmp8 = tmp4.toIntUnsigned();
      final tmp7 = List.generate(tmp5.toIntUnsigned(), growable: false, (i) {
        final elementPtr = i2.WasmI32.fromInt(tmp8 + i * 1);
        final tmp6 = i1.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

        return tmp6.toIntUnsigned();
      });

      return tmp7;
    });

    tmp0.free();
    i1.dartFree(tmp1, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp9;
  }

  @override
  bool methodFieldsHas({
    required i1.Borrowed<i5.TypesFields> self,
    required String name,
  }) {
    final tmp0 = i1.AllocatedString.allocateUtf16(name);
    final tmp1 = _import43(
      self.handle.toWasmI32(),
      tmp0.ptr,
      tmp0.packedLength,
    );
    tmp0.free();
    return tmp1.toBool();
  }

  @override
  i1.Result<void, i5.TypesHeaderError> methodFieldsSet({
    required i1.Borrowed<i5.TypesFields> self,
    required String name,
    required List<List<int>> value,
  }) {
    final tmp0 = i1.AllocatedString.allocateUtf16(name);

    final tmp4 = i2.WasmI32.fromInt(8 * value.length);
    final tmp5 = i1.mallocAligned(const i2.WasmI32(4), tmp4);
    var tmp6 = tmp5;
    for (final element in value) {
      final elementPtr = tmp6;

      final tmp1 = i2.WasmI32.fromInt(1 * element.length);
      final tmp2 = i1.mallocAligned(const i2.WasmI32(1), tmp1);
      var tmp3 = tmp2;
      for (final element in element) {
        final elementPtr = tmp3;
        i1.memory.storeInt8(
          elementPtr.toIntUnsigned(),
          i2.WasmI32.uint8FromInt(element),
          offset: 0,
        );

        tmp3 += const i2.WasmI32(1);
      }

      i1.memory.storeInt32(
        elementPtr.toIntUnsigned(),
        i2.WasmI32.fromInt(element.length),
        offset: 4,
      );
      i1.memory.storeInt32(elementPtr.toIntUnsigned(), tmp2, offset: 0);

      tmp6 += const i2.WasmI32(8);
      i1.dartFree(tmp2, tmp1, const i2.WasmI32(1));
    }

    var tmp7 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import44(
      self.handle.toWasmI32(),
      tmp0.ptr,
      tmp0.packedLength,
      tmp5,
      i2.WasmI32.fromInt(value.length),
      tmp7,
    );
    final tmp8 = i1.memory.loadUint8(tmp7.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesHeaderError> tmp15;
    if (tmp8.toBool()) {
      final tmp9 = i1.memory.loadUint8(tmp7.toIntUnsigned(), offset: 4);
      final i5.TypesHeaderError tmp14;
      switch (tmp9.toIntUnsigned()) {
        case 0:
          tmp14 = i5.TypesHeaderErrorInvalidSyntax();
        case 1:
          tmp14 = i5.TypesHeaderErrorForbidden();
        case 2:
          tmp14 = i5.TypesHeaderErrorImmutable();
        case 3:
          tmp14 = i5.TypesHeaderErrorSizeExceeded();
        case 4:
          final tmp10 = i1.memory.loadUint8(tmp7.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp13;
          if (tmp10.toBool()) {
            final tmp11 = i1.memory.loadInt32(tmp7.toIntUnsigned(), offset: 12);
            final tmp12 = i1.memory.loadInt32(tmp7.toIntUnsigned(), offset: 16);

            tmp13 = .some(i1.AllocatedString.read(tmp11, tmp12));
          } else {
            tmp13 = .none;
          }

          tmp14 = i5.TypesHeaderErrorOther(tmp13);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp15 = .error(tmp14);
    } else {
      tmp15 = .ok(null);
    }

    tmp0.free();
    i1.dartFree(tmp5, tmp4, const i2.WasmI32(4));
    i1.dartFree(tmp7, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp15;
  }

  @override
  i1.Result<void, i5.TypesHeaderError> methodFieldsDelete({
    required i1.Borrowed<i5.TypesFields> self,
    required String name,
  }) {
    final tmp0 = i1.AllocatedString.allocateUtf16(name);
    var tmp1 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import45(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1);
    final tmp2 = i1.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesHeaderError> tmp9;
    if (tmp2.toBool()) {
      final tmp3 = i1.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesHeaderError tmp8;
      switch (tmp3.toIntUnsigned()) {
        case 0:
          tmp8 = i5.TypesHeaderErrorInvalidSyntax();
        case 1:
          tmp8 = i5.TypesHeaderErrorForbidden();
        case 2:
          tmp8 = i5.TypesHeaderErrorImmutable();
        case 3:
          tmp8 = i5.TypesHeaderErrorSizeExceeded();
        case 4:
          final tmp4 = i1.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp7;
          if (tmp4.toBool()) {
            final tmp5 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp6 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp7 = .some(i1.AllocatedString.read(tmp5, tmp6));
          } else {
            tmp7 = .none;
          }

          tmp8 = i5.TypesHeaderErrorOther(tmp7);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp9 = .error(tmp8);
    } else {
      tmp9 = .ok(null);
    }

    tmp0.free();
    i1.dartFree(tmp1, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp9;
  }

  @override
  i1.Result<List<List<int>>, i5.TypesHeaderError> methodFieldsGetAndDelete({
    required i1.Borrowed<i5.TypesFields> self,
    required String name,
  }) {
    final tmp0 = i1.AllocatedString.allocateUtf16(name);
    var tmp1 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import46(self.handle.toWasmI32(), tmp0.ptr, tmp0.packedLength, tmp1);
    final tmp2 = i1.memory.loadUint8(tmp1.toIntUnsigned(), offset: 0);
    final i1.Result<List<List<int>>, i5.TypesHeaderError> tmp18;
    if (tmp2.toBool()) {
      final tmp12 = i1.memory.loadUint8(tmp1.toIntUnsigned(), offset: 4);
      final i5.TypesHeaderError tmp17;
      switch (tmp12.toIntUnsigned()) {
        case 0:
          tmp17 = i5.TypesHeaderErrorInvalidSyntax();
        case 1:
          tmp17 = i5.TypesHeaderErrorForbidden();
        case 2:
          tmp17 = i5.TypesHeaderErrorImmutable();
        case 3:
          tmp17 = i5.TypesHeaderErrorSizeExceeded();
        case 4:
          final tmp13 = i1.memory.loadUint8(tmp1.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp16;
          if (tmp13.toBool()) {
            final tmp14 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 12);
            final tmp15 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 16);

            tmp16 = .some(i1.AllocatedString.read(tmp14, tmp15));
          } else {
            tmp16 = .none;
          }

          tmp17 = i5.TypesHeaderErrorOther(tmp16);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp18 = .error(tmp17);
    } else {
      final tmp3 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 4);
      final tmp4 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 8);

      final tmp11 = tmp3.toIntUnsigned();
      final tmp10 = List.generate(tmp4.toIntUnsigned(), growable: false, (i) {
        final elementPtr = i2.WasmI32.fromInt(tmp11 + i * 8);
        final tmp5 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 0);
        final tmp6 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 4);

        final tmp9 = tmp5.toIntUnsigned();
        final tmp8 = List.generate(tmp6.toIntUnsigned(), growable: false, (i) {
          final elementPtr = i2.WasmI32.fromInt(tmp9 + i * 1);
          final tmp7 = i1.memory.loadUint8(
            elementPtr.toIntUnsigned(),
            offset: 0,
          );

          return tmp7.toIntUnsigned();
        });

        return tmp8;
      });

      tmp18 = .ok(tmp10);
    }

    tmp0.free();
    i1.dartFree(tmp1, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp18;
  }

  @override
  i1.Result<void, i5.TypesHeaderError> methodFieldsAppend({
    required i1.Borrowed<i5.TypesFields> self,
    required String name,
    required List<int> value,
  }) {
    final tmp0 = i1.AllocatedString.allocateUtf16(name);

    final tmp1 = i2.WasmI32.fromInt(1 * value.length);
    final tmp2 = i1.mallocAligned(const i2.WasmI32(1), tmp1);
    var tmp3 = tmp2;
    for (final element in value) {
      final elementPtr = tmp3;
      i1.memory.storeInt8(
        elementPtr.toIntUnsigned(),
        i2.WasmI32.uint8FromInt(element),
        offset: 0,
      );

      tmp3 += const i2.WasmI32(1);
    }

    var tmp4 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import47(
      self.handle.toWasmI32(),
      tmp0.ptr,
      tmp0.packedLength,
      tmp2,
      i2.WasmI32.fromInt(value.length),
      tmp4,
    );
    final tmp5 = i1.memory.loadUint8(tmp4.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesHeaderError> tmp12;
    if (tmp5.toBool()) {
      final tmp6 = i1.memory.loadUint8(tmp4.toIntUnsigned(), offset: 4);
      final i5.TypesHeaderError tmp11;
      switch (tmp6.toIntUnsigned()) {
        case 0:
          tmp11 = i5.TypesHeaderErrorInvalidSyntax();
        case 1:
          tmp11 = i5.TypesHeaderErrorForbidden();
        case 2:
          tmp11 = i5.TypesHeaderErrorImmutable();
        case 3:
          tmp11 = i5.TypesHeaderErrorSizeExceeded();
        case 4:
          final tmp7 = i1.memory.loadUint8(tmp4.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp10;
          if (tmp7.toBool()) {
            final tmp8 = i1.memory.loadInt32(tmp4.toIntUnsigned(), offset: 12);
            final tmp9 = i1.memory.loadInt32(tmp4.toIntUnsigned(), offset: 16);

            tmp10 = .some(i1.AllocatedString.read(tmp8, tmp9));
          } else {
            tmp10 = .none;
          }

          tmp11 = i5.TypesHeaderErrorOther(tmp10);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp12 = .error(tmp11);
    } else {
      tmp12 = .ok(null);
    }

    tmp0.free();
    i1.dartFree(tmp2, tmp1, const i2.WasmI32(1));
    i1.dartFree(tmp4, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp12;
  }

  @override
  List<(String, List<int>)> methodFieldsCopyAll({
    required i1.Borrowed<i5.TypesFields> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import48(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp12 = tmp1.toIntUnsigned();
    final tmp11 = List.generate(tmp2.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i2.WasmI32.fromInt(tmp12 + i * 16);
      final tmp3 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 0);
      final tmp4 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 4);
      final tmp5 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 8);
      final tmp6 = i1.memory.loadInt32(elementPtr.toIntUnsigned(), offset: 12);

      final tmp9 = tmp5.toIntUnsigned();
      final tmp8 = List.generate(tmp6.toIntUnsigned(), growable: false, (i) {
        final elementPtr = i2.WasmI32.fromInt(tmp9 + i * 1);
        final tmp7 = i1.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

        return tmp7.toIntUnsigned();
      });

      final tmp10 = (i1.AllocatedString.read(tmp3, tmp4), tmp8);

      return tmp10;
    });

    i1.dartFree(tmp0, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp11;
  }

  @override
  i1.Owned<i5.TypesFields> methodFieldsClone({
    required i1.Borrowed<i5.TypesFields> self,
  }) {
    final tmp0 = _import49(self.handle.toWasmI32());
    final tmp1 = i1.Owned<i5.TypesFields>(tmp0.toIntUnsigned(), _drop$127);
    return tmp1;
  }

  @override
  (i1.Owned<i5.TypesRequest>, Future<i1.Result<void, i5.TypesErrorCode>>)
  staticRequestNew({
    required i1.Owned<i5.TypesFields> headers,
    required i1.Option<Stream<i3.Uint8List>> contents,
    required Future<
      i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode>
    >
    trailers,
    required i1.Option<i1.Owned<i5.TypesRequestOptions>> options,
  }) {
    i2.WasmI32 tmp1;
    i2.WasmI32 tmp2;
    final tmp3 = contents;
    if (tmp3.hasValue) {
      final value = tmp3.requireValue();
      final tmp0 = i1.newReadableStream(const _Vtable142(), value).toWasmI32();
      tmp1 = const i2.WasmI32(1);
      tmp2 = tmp0;
    } else {
      tmp1 = const i2.WasmI32(0);
      tmp2 = const i2.WasmI32(0);
    }
    final tmp4 = i1.writeFuture(trailers, const _Vtable147());
    i2.WasmI32 tmp5;
    i2.WasmI32 tmp6;
    final tmp7 = options;
    if (tmp7.hasValue) {
      final value = tmp7.requireValue();
      tmp5 = const i2.WasmI32(1);
      tmp6 = value.handle.toWasmI32();
    } else {
      tmp5 = const i2.WasmI32(0);
      tmp6 = const i2.WasmI32(0);
    }
    var tmp8 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import50(headers.handle.toWasmI32(), tmp1, tmp2, tmp4, tmp5, tmp6, tmp8);
    final tmp9 = i1.memory.loadInt32(tmp8.toIntUnsigned(), offset: 0);
    final tmp10 = i1.Owned<i5.TypesRequest>(tmp9.toIntUnsigned(), _drop$130);
    final tmp11 = i1.memory.loadInt32(tmp8.toIntUnsigned(), offset: 4);
    final tmp12 = i1.readFuture(const _Vtable151(), tmp11.toIntUnsigned());
    final tmp13 = (tmp10, tmp12);
    i1.dartFree(tmp8, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp13;
  }

  @override
  i5.TypesMethod methodRequestGetMethod({
    required i1.Borrowed<i5.TypesRequest> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(12));
    _import52(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i5.TypesMethod tmp4;
    switch (tmp1.toIntUnsigned()) {
      case 0:
        tmp4 = i5.TypesMethodGet();
      case 1:
        tmp4 = i5.TypesMethodHead();
      case 2:
        tmp4 = i5.TypesMethodPost();
      case 3:
        tmp4 = i5.TypesMethodPut();
      case 4:
        tmp4 = i5.TypesMethodDelete();
      case 5:
        tmp4 = i5.TypesMethodConnect();
      case 6:
        tmp4 = i5.TypesMethodOptions();
      case 7:
        tmp4 = i5.TypesMethodTrace();
      case 8:
        tmp4 = i5.TypesMethodPatch();
      case 9:
        final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
        final tmp3 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);

        tmp4 = i5.TypesMethodOther(i1.AllocatedString.read(tmp2, tmp3));

      default:
        throw ArgumentError('Invalid discrimant value for variant');
    }
    i1.dartFree(tmp0, const i2.WasmI32(12), const i2.WasmI32(4));
    return tmp4;
  }

  @override
  i1.Result<void, void> methodRequestSetMethod({
    required i1.Borrowed<i5.TypesRequest> self,
    required i5.TypesMethod method,
  }) {
    i2.WasmI32 tmp1;
    i2.WasmI32 tmp2;
    i2.WasmI32 tmp3;
    switch (method) {
      case i5.TypesMethodGet():
        tmp1 = const i2.WasmI32(0);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodHead():
        tmp1 = const i2.WasmI32(1);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodPost():
        tmp1 = const i2.WasmI32(2);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodPut():
        tmp1 = const i2.WasmI32(3);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodDelete():
        tmp1 = const i2.WasmI32(4);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodConnect():
        tmp1 = const i2.WasmI32(5);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodOptions():
        tmp1 = const i2.WasmI32(6);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodTrace():
        tmp1 = const i2.WasmI32(7);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodPatch():
        tmp1 = const i2.WasmI32(8);
        tmp2 = const i2.WasmI32(0);
        tmp3 = const i2.WasmI32(0);

      case i5.TypesMethodOther(payload: final value):
        final tmp0 = i1.AllocatedString.allocateUtf16(value);
        tmp1 = const i2.WasmI32(9);
        tmp2 = tmp0.ptr;
        tmp3 = tmp0.packedLength;
        tmp0.free();
    }
    final tmp4 = _import53(self.handle.toWasmI32(), tmp1, tmp2, tmp3);
    final i1.Result<void, void> tmp5;
    if (tmp4.toBool()) {
      tmp5 = .error(null);
    } else {
      tmp5 = .ok(null);
    }

    return tmp5;
  }

  @override
  i1.Option<String> methodRequestGetPathWithQuery({
    required i1.Borrowed<i5.TypesRequest> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(12));
    _import54(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<String> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);

      tmp4 = .some(i1.AllocatedString.read(tmp2, tmp3));
    } else {
      tmp4 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(12), const i2.WasmI32(4));
    return tmp4;
  }

  @override
  i1.Result<void, void> methodRequestSetPathWithQuery({
    required i1.Borrowed<i5.TypesRequest> self,
    required i1.Option<String> pathWithQuery,
  }) {
    i2.WasmI32 tmp1;
    i2.WasmI32 tmp2;
    i2.WasmI32 tmp3;
    final tmp4 = pathWithQuery;
    if (tmp4.hasValue) {
      final value = tmp4.requireValue();
      final tmp0 = i1.AllocatedString.allocateUtf16(value);
      tmp1 = const i2.WasmI32(1);
      tmp2 = tmp0.ptr;
      tmp3 = tmp0.packedLength;
      tmp0.free();
    } else {
      tmp1 = const i2.WasmI32(0);
      tmp2 = const i2.WasmI32(0);
      tmp3 = const i2.WasmI32(0);
    }
    final tmp5 = _import55(self.handle.toWasmI32(), tmp1, tmp2, tmp3);
    final i1.Result<void, void> tmp6;
    if (tmp5.toBool()) {
      tmp6 = .error(null);
    } else {
      tmp6 = .ok(null);
    }

    return tmp6;
  }

  @override
  i1.Option<i5.TypesScheme> methodRequestGetScheme({
    required i1.Borrowed<i5.TypesRequest> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(16));
    _import56(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<i5.TypesScheme> tmp6;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 4);
      final i5.TypesScheme tmp5;
      switch (tmp2.toIntUnsigned()) {
        case 0:
          tmp5 = i5.TypesSchemeHttp();
        case 1:
          tmp5 = i5.TypesSchemeHttps();
        case 2:
          final tmp3 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);
          final tmp4 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 12);

          tmp5 = i5.TypesSchemeOther(i1.AllocatedString.read(tmp3, tmp4));

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp6 = .some(tmp5);
    } else {
      tmp6 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(16), const i2.WasmI32(4));
    return tmp6;
  }

  @override
  i1.Result<void, void> methodRequestSetScheme({
    required i1.Borrowed<i5.TypesRequest> self,
    required i1.Option<i5.TypesScheme> scheme,
  }) {
    i2.WasmI32 tmp4;
    i2.WasmI32 tmp5;
    i2.WasmI32 tmp6;
    i2.WasmI32 tmp7;
    final tmp8 = scheme;
    if (tmp8.hasValue) {
      final value = tmp8.requireValue();
      i2.WasmI32 tmp1;
      i2.WasmI32 tmp2;
      i2.WasmI32 tmp3;
      switch (value) {
        case i5.TypesSchemeHttp():
          tmp1 = const i2.WasmI32(0);
          tmp2 = const i2.WasmI32(0);
          tmp3 = const i2.WasmI32(0);

        case i5.TypesSchemeHttps():
          tmp1 = const i2.WasmI32(1);
          tmp2 = const i2.WasmI32(0);
          tmp3 = const i2.WasmI32(0);

        case i5.TypesSchemeOther(payload: final value):
          final tmp0 = i1.AllocatedString.allocateUtf16(value);
          tmp1 = const i2.WasmI32(2);
          tmp2 = tmp0.ptr;
          tmp3 = tmp0.packedLength;
          tmp0.free();
      }
      tmp4 = const i2.WasmI32(1);
      tmp5 = tmp1;
      tmp6 = tmp2;
      tmp7 = tmp3;
    } else {
      tmp4 = const i2.WasmI32(0);
      tmp5 = const i2.WasmI32(0);
      tmp6 = const i2.WasmI32(0);
      tmp7 = const i2.WasmI32(0);
    }
    final tmp9 = _import57(self.handle.toWasmI32(), tmp4, tmp5, tmp6, tmp7);
    final i1.Result<void, void> tmp10;
    if (tmp9.toBool()) {
      tmp10 = .error(null);
    } else {
      tmp10 = .ok(null);
    }

    return tmp10;
  }

  @override
  i1.Option<String> methodRequestGetAuthority({
    required i1.Borrowed<i5.TypesRequest> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(12));
    _import58(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<String> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);

      tmp4 = .some(i1.AllocatedString.read(tmp2, tmp3));
    } else {
      tmp4 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(12), const i2.WasmI32(4));
    return tmp4;
  }

  @override
  i1.Result<void, void> methodRequestSetAuthority({
    required i1.Borrowed<i5.TypesRequest> self,
    required i1.Option<String> authority,
  }) {
    i2.WasmI32 tmp1;
    i2.WasmI32 tmp2;
    i2.WasmI32 tmp3;
    final tmp4 = authority;
    if (tmp4.hasValue) {
      final value = tmp4.requireValue();
      final tmp0 = i1.AllocatedString.allocateUtf16(value);
      tmp1 = const i2.WasmI32(1);
      tmp2 = tmp0.ptr;
      tmp3 = tmp0.packedLength;
      tmp0.free();
    } else {
      tmp1 = const i2.WasmI32(0);
      tmp2 = const i2.WasmI32(0);
      tmp3 = const i2.WasmI32(0);
    }
    final tmp5 = _import59(self.handle.toWasmI32(), tmp1, tmp2, tmp3);
    final i1.Result<void, void> tmp6;
    if (tmp5.toBool()) {
      tmp6 = .error(null);
    } else {
      tmp6 = .ok(null);
    }

    return tmp6;
  }

  @override
  i1.Option<i1.Owned<i5.TypesRequestOptions>> methodRequestGetOptions({
    required i1.Borrowed<i5.TypesRequest> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import60(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<i1.Owned<i5.TypesRequestOptions>> tmp4;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);
      final tmp3 = i1.Owned<i5.TypesRequestOptions>(
        tmp2.toIntUnsigned(),
        _drop$131,
      );
      tmp4 = .some(tmp3);
    } else {
      tmp4 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp4;
  }

  @override
  i1.Owned<i5.TypesFields> methodRequestGetHeaders({
    required i1.Borrowed<i5.TypesRequest> self,
  }) {
    final tmp0 = _import62(self.handle.toWasmI32());
    final tmp1 = i1.Owned<i5.TypesFields>(tmp0.toIntUnsigned(), _drop$128);
    return tmp1;
  }

  @override
  (
    Stream<i3.Uint8List>,
    Future<i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode>>,
  )
  staticRequestConsumeBody({
    required i1.Owned<i5.TypesRequest> $this,
    required Future<i1.Result<void, i5.TypesErrorCode>> res,
  }) {
    final tmp0 = i1.writeFuture(res, const _Vtable151());
    var tmp1 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import64($this.handle.toWasmI32(), tmp0, tmp1);
    final tmp2 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 0);
    final tmp3 = i1.ReadableStream(tmp2.toIntUnsigned(), const _Vtable142());
    final tmp4 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 4);
    final tmp5 = i1.readFuture(const _Vtable147(), tmp4.toIntUnsigned());
    final tmp6 = (tmp3, tmp5);
    i1.dartFree(tmp1, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp6;
  }

  @override
  i1.Owned<i5.TypesRequestOptions> constructorRequestOptions() {
    final tmp0 = _import65();
    final tmp1 = i1.Owned<i5.TypesRequestOptions>(
      tmp0.toIntUnsigned(),
      _drop$131,
    );
    return tmp1;
  }

  @override
  i1.Option<int> methodRequestOptionsGetConnectTimeout({
    required i1.Borrowed<i5.TypesRequestOptions> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(8), const i2.WasmI32(16));
    _import66(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<int> tmp3;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp3 = .some(tmp2.toInt());
    } else {
      tmp3 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(16), const i2.WasmI32(8));
    return tmp3;
  }

  @override
  i1.Result<void, i5.TypesRequestOptionsError>
  methodRequestOptionsSetConnectTimeout({
    required i1.Borrowed<i5.TypesRequestOptions> self,
    required i1.Option<int> duration,
  }) {
    i2.WasmI32 tmp0;
    i2.WasmI64 tmp1;
    final tmp2 = duration;
    if (tmp2.hasValue) {
      final value = tmp2.requireValue();
      tmp0 = const i2.WasmI32(1);
      tmp1 = i2.WasmI64.fromInt(value);
    } else {
      tmp0 = const i2.WasmI32(0);
      tmp1 = const i2.WasmI64(0);
    }
    var tmp3 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import67(self.handle.toWasmI32(), tmp0, tmp1, tmp3);
    final tmp4 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesRequestOptionsError> tmp11;
    if (tmp4.toBool()) {
      final tmp5 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 4);
      final i5.TypesRequestOptionsError tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesRequestOptionsErrorNotSupported();
        case 1:
          tmp10 = i5.TypesRequestOptionsErrorImmutable();
        case 2:
          final tmp6 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i1.memory.loadInt32(tmp3.toIntUnsigned(), offset: 12);
            final tmp8 = i1.memory.loadInt32(tmp3.toIntUnsigned(), offset: 16);

            tmp9 = .some(i1.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesRequestOptionsErrorOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      tmp11 = .ok(null);
    }

    i1.dartFree(tmp3, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp11;
  }

  @override
  i1.Option<int> methodRequestOptionsGetFirstByteTimeout({
    required i1.Borrowed<i5.TypesRequestOptions> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(8), const i2.WasmI32(16));
    _import68(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<int> tmp3;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp3 = .some(tmp2.toInt());
    } else {
      tmp3 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(16), const i2.WasmI32(8));
    return tmp3;
  }

  @override
  i1.Result<void, i5.TypesRequestOptionsError>
  methodRequestOptionsSetFirstByteTimeout({
    required i1.Borrowed<i5.TypesRequestOptions> self,
    required i1.Option<int> duration,
  }) {
    i2.WasmI32 tmp0;
    i2.WasmI64 tmp1;
    final tmp2 = duration;
    if (tmp2.hasValue) {
      final value = tmp2.requireValue();
      tmp0 = const i2.WasmI32(1);
      tmp1 = i2.WasmI64.fromInt(value);
    } else {
      tmp0 = const i2.WasmI32(0);
      tmp1 = const i2.WasmI64(0);
    }
    var tmp3 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import69(self.handle.toWasmI32(), tmp0, tmp1, tmp3);
    final tmp4 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesRequestOptionsError> tmp11;
    if (tmp4.toBool()) {
      final tmp5 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 4);
      final i5.TypesRequestOptionsError tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesRequestOptionsErrorNotSupported();
        case 1:
          tmp10 = i5.TypesRequestOptionsErrorImmutable();
        case 2:
          final tmp6 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i1.memory.loadInt32(tmp3.toIntUnsigned(), offset: 12);
            final tmp8 = i1.memory.loadInt32(tmp3.toIntUnsigned(), offset: 16);

            tmp9 = .some(i1.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesRequestOptionsErrorOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      tmp11 = .ok(null);
    }

    i1.dartFree(tmp3, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp11;
  }

  @override
  i1.Option<int> methodRequestOptionsGetBetweenBytesTimeout({
    required i1.Borrowed<i5.TypesRequestOptions> self,
  }) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(8), const i2.WasmI32(16));
    _import70(self.handle.toWasmI32(), tmp0);
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Option<int> tmp3;
    if (tmp1.toBool()) {
      final tmp2 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);

      tmp3 = .some(tmp2.toInt());
    } else {
      tmp3 = .none;
    }

    i1.dartFree(tmp0, const i2.WasmI32(16), const i2.WasmI32(8));
    return tmp3;
  }

  @override
  i1.Result<void, i5.TypesRequestOptionsError>
  methodRequestOptionsSetBetweenBytesTimeout({
    required i1.Borrowed<i5.TypesRequestOptions> self,
    required i1.Option<int> duration,
  }) {
    i2.WasmI32 tmp0;
    i2.WasmI64 tmp1;
    final tmp2 = duration;
    if (tmp2.hasValue) {
      final value = tmp2.requireValue();
      tmp0 = const i2.WasmI32(1);
      tmp1 = i2.WasmI64.fromInt(value);
    } else {
      tmp0 = const i2.WasmI32(0);
      tmp1 = const i2.WasmI64(0);
    }
    var tmp3 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(20));
    _import71(self.handle.toWasmI32(), tmp0, tmp1, tmp3);
    final tmp4 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 0);
    final i1.Result<void, i5.TypesRequestOptionsError> tmp11;
    if (tmp4.toBool()) {
      final tmp5 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 4);
      final i5.TypesRequestOptionsError tmp10;
      switch (tmp5.toIntUnsigned()) {
        case 0:
          tmp10 = i5.TypesRequestOptionsErrorNotSupported();
        case 1:
          tmp10 = i5.TypesRequestOptionsErrorImmutable();
        case 2:
          final tmp6 = i1.memory.loadUint8(tmp3.toIntUnsigned(), offset: 8);
          final i1.Option<String> tmp9;
          if (tmp6.toBool()) {
            final tmp7 = i1.memory.loadInt32(tmp3.toIntUnsigned(), offset: 12);
            final tmp8 = i1.memory.loadInt32(tmp3.toIntUnsigned(), offset: 16);

            tmp9 = .some(i1.AllocatedString.read(tmp7, tmp8));
          } else {
            tmp9 = .none;
          }

          tmp10 = i5.TypesRequestOptionsErrorOther(tmp9);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp11 = .error(tmp10);
    } else {
      tmp11 = .ok(null);
    }

    i1.dartFree(tmp3, const i2.WasmI32(20), const i2.WasmI32(4));
    return tmp11;
  }

  @override
  i1.Owned<i5.TypesRequestOptions> methodRequestOptionsClone({
    required i1.Borrowed<i5.TypesRequestOptions> self,
  }) {
    final tmp0 = _import72(self.handle.toWasmI32());
    final tmp1 = i1.Owned<i5.TypesRequestOptions>(
      tmp0.toIntUnsigned(),
      _drop$131,
    );
    return tmp1;
  }

  @override
  (i1.Owned<i5.TypesResponse>, Future<i1.Result<void, i5.TypesErrorCode>>)
  staticResponseNew({
    required i1.Owned<i5.TypesFields> headers,
    required i1.Option<Stream<i3.Uint8List>> contents,
    required Future<
      i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode>
    >
    trailers,
  }) {
    i2.WasmI32 tmp1;
    i2.WasmI32 tmp2;
    final tmp3 = contents;
    if (tmp3.hasValue) {
      final value = tmp3.requireValue();
      final tmp0 = i1.newReadableStream(const _Vtable142(), value).toWasmI32();
      tmp1 = const i2.WasmI32(1);
      tmp2 = tmp0;
    } else {
      tmp1 = const i2.WasmI32(0);
      tmp2 = const i2.WasmI32(0);
    }
    final tmp4 = i1.writeFuture(trailers, const _Vtable147());
    var tmp5 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import73(headers.handle.toWasmI32(), tmp1, tmp2, tmp4, tmp5);
    final tmp6 = i1.memory.loadInt32(tmp5.toIntUnsigned(), offset: 0);
    final tmp7 = i1.Owned<i5.TypesResponse>(tmp6.toIntUnsigned(), _drop$133);
    final tmp8 = i1.memory.loadInt32(tmp5.toIntUnsigned(), offset: 4);
    final tmp9 = i1.readFuture(const _Vtable151(), tmp8.toIntUnsigned());
    final tmp10 = (tmp7, tmp9);
    i1.dartFree(tmp5, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp10;
  }

  @override
  int methodResponseGetStatusCode({
    required i1.Borrowed<i5.TypesResponse> self,
  }) {
    final tmp0 = _import75(self.handle.toWasmI32());
    return tmp0.toIntUnsigned();
  }

  @override
  i1.Result<void, void> methodResponseSetStatusCode({
    required i1.Borrowed<i5.TypesResponse> self,
    required int statusCode,
  }) {
    final tmp0 = _import76(
      self.handle.toWasmI32(),
      i2.WasmI32.uint16FromInt(statusCode),
    );
    final i1.Result<void, void> tmp1;
    if (tmp0.toBool()) {
      tmp1 = .error(null);
    } else {
      tmp1 = .ok(null);
    }

    return tmp1;
  }

  @override
  i1.Owned<i5.TypesFields> methodResponseGetHeaders({
    required i1.Borrowed<i5.TypesResponse> self,
  }) {
    final tmp0 = _import77(self.handle.toWasmI32());
    final tmp1 = i1.Owned<i5.TypesFields>(tmp0.toIntUnsigned(), _drop$128);
    return tmp1;
  }

  @override
  (
    Stream<i3.Uint8List>,
    Future<i1.Result<i1.Option<i1.Owned<i5.TypesFields>>, i5.TypesErrorCode>>,
  )
  staticResponseConsumeBody({
    required i1.Owned<i5.TypesResponse> $this,
    required Future<i1.Result<void, i5.TypesErrorCode>> res,
  }) {
    final tmp0 = i1.writeFuture(res, const _Vtable151());
    var tmp1 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import78($this.handle.toWasmI32(), tmp0, tmp1);
    final tmp2 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 0);
    final tmp3 = i1.ReadableStream(tmp2.toIntUnsigned(), const _Vtable142());
    final tmp4 = i1.memory.loadInt32(tmp1.toIntUnsigned(), offset: 4);
    final tmp5 = i1.readFuture(const _Vtable147(), tmp4.toIntUnsigned());
    final tmp6 = (tmp3, tmp5);
    i1.dartFree(tmp1, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp6;
  }
}

@pragma('wasm:import', r'component._drop$170')
external i2.WasmVoid _drop$170Raw(i2.WasmI32 handle);

void _drop$170(int handle) {
  _drop$170Raw(i2.WasmI32.fromInt(handle));
}

@pragma("wasm:import", r"component._import79")
external i2.WasmI32 _import79(i2.WasmI32 p0, i2.WasmI32 p1);

final class _Imported$25 implements i5.Client {
  const _Imported$25();
  @override
  Future<i1.Result<i1.Owned<i5.TypesResponse>, i5.TypesErrorCode>> send({
    required i1.Owned<i5.TypesRequest> request,
  }) async {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(8), const i2.WasmI32(40));
    await i1
        .createSubtask(_import79(request.handle.toWasmI32(), tmp0))
        .completion;
    final tmp1 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 0);
    final i1.Result<i1.Owned<i5.TypesResponse>, i5.TypesErrorCode> tmp86;
    if (tmp1.toBool()) {
      final tmp4 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 8);
      final i5.TypesErrorCode tmp85;
      switch (tmp4.toIntUnsigned()) {
        case 0:
          tmp85 = i5.TypesErrorCodeDnsTimeout();
        case 1:
          final tmp5 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp8;
          if (tmp5.toBool()) {
            final tmp6 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp7 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp8 = .some(i1.AllocatedString.read(tmp6, tmp7));
          } else {
            tmp8 = .none;
          }

          final tmp9 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 28);
          final i1.Option<int> tmp11;
          if (tmp9.toBool()) {
            final tmp10 = i1.memory.loadUint16(
              tmp0.toIntUnsigned(),
              offset: 30,
            );

            tmp11 = .some(tmp10.toIntUnsigned());
          } else {
            tmp11 = .none;
          }

          final tmp12 = (rcode: tmp8, infoCode: tmp11);

          tmp85 = i5.TypesErrorCodeDnsError(tmp12);
        case 2:
          tmp85 = i5.TypesErrorCodeDestinationNotFound();
        case 3:
          tmp85 = i5.TypesErrorCodeDestinationUnavailable();
        case 4:
          tmp85 = i5.TypesErrorCodeDestinationIpProhibited();
        case 5:
          tmp85 = i5.TypesErrorCodeDestinationIpUnroutable();
        case 6:
          tmp85 = i5.TypesErrorCodeConnectionRefused();
        case 7:
          tmp85 = i5.TypesErrorCodeConnectionTerminated();
        case 8:
          tmp85 = i5.TypesErrorCodeConnectionTimeout();
        case 9:
          tmp85 = i5.TypesErrorCodeConnectionReadTimeout();
        case 10:
          tmp85 = i5.TypesErrorCodeConnectionWriteTimeout();
        case 11:
          tmp85 = i5.TypesErrorCodeConnectionLimitReached();
        case 12:
          tmp85 = i5.TypesErrorCodeTlsProtocolError();
        case 13:
          tmp85 = i5.TypesErrorCodeTlsCertificateError();
        case 14:
          final tmp13 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp15;
          if (tmp13.toBool()) {
            final tmp14 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 17);

            tmp15 = .some(tmp14.toIntUnsigned());
          } else {
            tmp15 = .none;
          }

          final tmp16 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 20);
          final i1.Option<String> tmp19;
          if (tmp16.toBool()) {
            final tmp17 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);
            final tmp18 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 28);

            tmp19 = .some(i1.AllocatedString.read(tmp17, tmp18));
          } else {
            tmp19 = .none;
          }

          final tmp20 = (alertId: tmp15, alertMessage: tmp19);

          tmp85 = i5.TypesErrorCodeTlsAlertReceived(tmp20);
        case 15:
          tmp85 = i5.TypesErrorCodeHttpRequestDenied();
        case 16:
          tmp85 = i5.TypesErrorCodeHttpRequestLengthRequired();
        case 17:
          final tmp21 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp23;
          if (tmp21.toBool()) {
            final tmp22 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 24);

            tmp23 = .some(tmp22.toInt());
          } else {
            tmp23 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpRequestBodySize(tmp23);
        case 18:
          tmp85 = i5.TypesErrorCodeHttpRequestMethodInvalid();
        case 19:
          tmp85 = i5.TypesErrorCodeHttpRequestUriInvalid();
        case 20:
          tmp85 = i5.TypesErrorCodeHttpRequestUriTooLong();
        case 21:
          final tmp24 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp26;
          if (tmp24.toBool()) {
            final tmp25 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp26 = .some(tmp25.toIntUnsigned());
          } else {
            tmp26 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpRequestHeaderSectionSize(tmp26);
        case 22:
          final tmp27 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<
            ({i1.Option<String> fieldName, i1.Option<int> fieldSize})
          >
          tmp36;
          if (tmp27.toBool()) {
            final tmp28 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 20);
            final i1.Option<String> tmp31;
            if (tmp28.toBool()) {
              final tmp29 = i1.memory.loadInt32(
                tmp0.toIntUnsigned(),
                offset: 24,
              );
              final tmp30 = i1.memory.loadInt32(
                tmp0.toIntUnsigned(),
                offset: 28,
              );

              tmp31 = .some(i1.AllocatedString.read(tmp29, tmp30));
            } else {
              tmp31 = .none;
            }

            final tmp32 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 32);
            final i1.Option<int> tmp34;
            if (tmp32.toBool()) {
              final tmp33 = i1.memory.loadInt32(
                tmp0.toIntUnsigned(),
                offset: 36,
              );

              tmp34 = .some(tmp33.toIntUnsigned());
            } else {
              tmp34 = .none;
            }

            final tmp35 = (fieldName: tmp31, fieldSize: tmp34);

            tmp36 = .some(tmp35);
          } else {
            tmp36 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpRequestHeaderSize(tmp36);
        case 23:
          final tmp37 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp39;
          if (tmp37.toBool()) {
            final tmp38 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp39 = .some(tmp38.toIntUnsigned());
          } else {
            tmp39 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpRequestTrailerSectionSize(tmp39);
        case 24:
          final tmp40 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp43;
          if (tmp40.toBool()) {
            final tmp41 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp42 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp43 = .some(i1.AllocatedString.read(tmp41, tmp42));
          } else {
            tmp43 = .none;
          }

          final tmp44 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 28);
          final i1.Option<int> tmp46;
          if (tmp44.toBool()) {
            final tmp45 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);

            tmp46 = .some(tmp45.toIntUnsigned());
          } else {
            tmp46 = .none;
          }

          final tmp47 = (fieldName: tmp43, fieldSize: tmp46);

          tmp85 = i5.TypesErrorCodeHttpRequestTrailerSize(tmp47);
        case 25:
          tmp85 = i5.TypesErrorCodeHttpResponseIncomplete();
        case 26:
          final tmp48 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp50;
          if (tmp48.toBool()) {
            final tmp49 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp50 = .some(tmp49.toIntUnsigned());
          } else {
            tmp50 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpResponseHeaderSectionSize(tmp50);
        case 27:
          final tmp51 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp54;
          if (tmp51.toBool()) {
            final tmp52 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp53 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp54 = .some(i1.AllocatedString.read(tmp52, tmp53));
          } else {
            tmp54 = .none;
          }

          final tmp55 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 28);
          final i1.Option<int> tmp57;
          if (tmp55.toBool()) {
            final tmp56 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);

            tmp57 = .some(tmp56.toIntUnsigned());
          } else {
            tmp57 = .none;
          }

          final tmp58 = (fieldName: tmp54, fieldSize: tmp57);

          tmp85 = i5.TypesErrorCodeHttpResponseHeaderSize(tmp58);
        case 28:
          final tmp59 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp61;
          if (tmp59.toBool()) {
            final tmp60 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 24);

            tmp61 = .some(tmp60.toInt());
          } else {
            tmp61 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpResponseBodySize(tmp61);
        case 29:
          final tmp62 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<int> tmp64;
          if (tmp62.toBool()) {
            final tmp63 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);

            tmp64 = .some(tmp63.toIntUnsigned());
          } else {
            tmp64 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpResponseTrailerSectionSize(tmp64);
        case 30:
          final tmp65 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp68;
          if (tmp65.toBool()) {
            final tmp66 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp67 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp68 = .some(i1.AllocatedString.read(tmp66, tmp67));
          } else {
            tmp68 = .none;
          }

          final tmp69 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 28);
          final i1.Option<int> tmp71;
          if (tmp69.toBool()) {
            final tmp70 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 32);

            tmp71 = .some(tmp70.toIntUnsigned());
          } else {
            tmp71 = .none;
          }

          final tmp72 = (fieldName: tmp68, fieldSize: tmp71);

          tmp85 = i5.TypesErrorCodeHttpResponseTrailerSize(tmp72);
        case 31:
          final tmp73 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp76;
          if (tmp73.toBool()) {
            final tmp74 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp75 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp76 = .some(i1.AllocatedString.read(tmp74, tmp75));
          } else {
            tmp76 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpResponseTransferCoding(tmp76);
        case 32:
          final tmp77 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp80;
          if (tmp77.toBool()) {
            final tmp78 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp79 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp80 = .some(i1.AllocatedString.read(tmp78, tmp79));
          } else {
            tmp80 = .none;
          }

          tmp85 = i5.TypesErrorCodeHttpResponseContentCoding(tmp80);
        case 33:
          tmp85 = i5.TypesErrorCodeHttpResponseTimeout();
        case 34:
          tmp85 = i5.TypesErrorCodeHttpUpgradeFailed();
        case 35:
          tmp85 = i5.TypesErrorCodeHttpProtocolError();
        case 36:
          tmp85 = i5.TypesErrorCodeLoopDetected();
        case 37:
          tmp85 = i5.TypesErrorCodeConfigurationError();
        case 38:
          final tmp81 = i1.memory.loadUint8(tmp0.toIntUnsigned(), offset: 16);
          final i1.Option<String> tmp84;
          if (tmp81.toBool()) {
            final tmp82 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 20);
            final tmp83 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 24);

            tmp84 = .some(i1.AllocatedString.read(tmp82, tmp83));
          } else {
            tmp84 = .none;
          }

          tmp85 = i5.TypesErrorCodeInternalError(tmp84);

        default:
          throw ArgumentError('Invalid discrimant value for variant');
      }

      tmp86 = .error(tmp85);
    } else {
      final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);
      final tmp3 = i1.Owned<i5.TypesResponse>(tmp2.toIntUnsigned(), _drop$170);
      tmp86 = .ok(tmp3);
    }

    i1.dartFree(tmp0, const i2.WasmI32(40), const i2.WasmI32(8));
    return tmp86;
  }
}

@pragma("wasm:import", r"component._import81")
external i2.WasmI64 _import81();
@pragma("wasm:import", r"component._import82")
external i2.WasmI64 _import82();
@pragma("wasm:import", r"component._import83")
external i2.WasmI32 _import83(i2.WasmI64 p0);
@pragma("wasm:import", r"component._import84")
external i2.WasmI32 _import84(i2.WasmI64 p0);

final class _Imported$1 implements i4.MonotonicClock {
  const _Imported$1();
  @override
  int now() {
    final tmp0 = _import81();
    return tmp0.toInt();
  }

  @override
  int getResolution() {
    final tmp0 = _import82();
    return tmp0.toInt();
  }

  @override
  Future<void> waitUntil({required int when}) async {
    await i1.createSubtask(_import83(i2.WasmI64.fromInt(when))).completion;
  }

  @override
  Future<void> waitFor({required int howLong}) async {
    await i1.createSubtask(_import84(i2.WasmI64.fromInt(howLong))).completion;
  }
}

@pragma("wasm:import", r"component._import85")
external i2.WasmVoid _import85(i2.WasmI32 p0);
@pragma("wasm:import", r"component._import86")
external i2.WasmI64 _import86();

final class _Imported$2 implements i4.SystemClock {
  const _Imported$2();
  @override
  ({int seconds, int nanoseconds}) now() {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(8), const i2.WasmI32(16));
    _import85(tmp0);
    final tmp1 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 8);
    final tmp3 = (seconds: tmp1.toInt(), nanoseconds: tmp2.toIntUnsigned());
    i1.dartFree(tmp0, const i2.WasmI32(16), const i2.WasmI32(8));
    return tmp3;
  }

  @override
  int getResolution() {
    final tmp0 = _import86();
    return tmp0.toInt();
  }
}

@pragma("wasm:import", r"component._import87")
external i2.WasmVoid _import87(i2.WasmI64 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import88")
external i2.WasmI64 _import88();

final class _Imported$8 implements i6.Random {
  const _Imported$8();
  @override
  List<int> getRandomBytes({required int maxLen}) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import87(i2.WasmI64.fromInt(maxLen), tmp0);
    final tmp1 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp5 = tmp1.toIntUnsigned();
    final tmp4 = List.generate(tmp2.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i2.WasmI32.fromInt(tmp5 + i * 1);
      final tmp3 = i1.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

      return tmp3.toIntUnsigned();
    });

    i1.dartFree(tmp0, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp4;
  }

  @override
  int getRandomU64() {
    final tmp0 = _import88();
    return tmp0.toInt();
  }
}

@pragma("wasm:import", r"component._import89")
external i2.WasmVoid _import89(i2.WasmI64 p0, i2.WasmI32 p1);
@pragma("wasm:import", r"component._import90")
external i2.WasmI64 _import90();

final class _Imported$9 implements i6.Insecure {
  const _Imported$9();
  @override
  List<int> getInsecureRandomBytes({required int maxLen}) {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(4), const i2.WasmI32(8));
    _import89(i2.WasmI64.fromInt(maxLen), tmp0);
    final tmp1 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i1.memory.loadInt32(tmp0.toIntUnsigned(), offset: 4);

    final tmp5 = tmp1.toIntUnsigned();
    final tmp4 = List.generate(tmp2.toIntUnsigned(), growable: false, (i) {
      final elementPtr = i2.WasmI32.fromInt(tmp5 + i * 1);
      final tmp3 = i1.memory.loadUint8(elementPtr.toIntUnsigned(), offset: 0);

      return tmp3.toIntUnsigned();
    });

    i1.dartFree(tmp0, const i2.WasmI32(8), const i2.WasmI32(4));
    return tmp4;
  }

  @override
  int getInsecureRandomU64() {
    final tmp0 = _import90();
    return tmp0.toInt();
  }
}

@pragma("wasm:import", r"component._import91")
external i2.WasmVoid _import91(i2.WasmI32 p0);

final class _Imported$10 implements i6.InsecureSeed {
  const _Imported$10();
  @override
  (int, int) getInsecureSeed() {
    var tmp0 = i1.mallocAligned(const i2.WasmI32(8), const i2.WasmI32(16));
    _import91(tmp0);
    final tmp1 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 0);
    final tmp2 = i1.memory.loadInt64(tmp0.toIntUnsigned(), offset: 8);
    final tmp3 = (tmp1.toInt(), tmp2.toInt());
    i1.dartFree(tmp0, const i2.WasmI32(16), const i2.WasmI32(8));
    return tmp3;
  }
}

late i5.Handler _unnamedExport24;

final class ServiceImports {
  const ServiceImports._();

  i0.Stdout get cliStdout => const _Imported$16();
  i0.Stderr get cliStderr => const _Imported$17();
  i0.Stdin get cliStdin => const _Imported$15();
  i5.Types get httpTypes => const _Imported$23();
  i5.Client get httpClient => const _Imported$25();
  i4.MonotonicClock get clocksMonotonicClock => const _Imported$1();
  i4.SystemClock get clocksSystemClock => const _Imported$2();
  i6.Random get randomRandom => const _Imported$8();
  i6.Insecure get randomInsecure => const _Imported$9();
  i6.InsecureSeed get randomInsecureSeed => const _Imported$10();
}

@pragma('wasm:import', r'component._drop$164')
external i2.WasmVoid _drop$164Raw(i2.WasmI32 handle);

void _drop$164(int handle) {
  _drop$164Raw(i2.WasmI32.fromInt(handle));
}

@i7.RecordUse()
void serviceComponent(i5.Handler Function(ServiceImports) defineComponent) {
  final res = defineComponent(const ServiceImports._());
  _unnamedExport24 = res;
}

@pragma('wasm:export', r'component_0')
i2.WasmI32 _component_0(i2.WasmI32 p0) {
  final asyncExitCode = i1.spawnTask(
    run: () async {
      final tmp0 = i1.Owned<i5.TypesRequest>(p0.toIntUnsigned(), _drop$164);
      final tmp1 = await _unnamedExport24.handle(request: tmp0);
      i2.WasmI32 tmp97;
      i2.WasmI32 tmp98;
      i2.WasmI32 tmp99;
      i2.WasmI64 tmp100;
      i2.WasmI32 tmp101;
      i2.WasmI32 tmp102;
      i2.WasmI32 tmp103;
      i2.WasmI32 tmp104;
      switch (tmp1) {
        case i1.OkResult(:final value):
          tmp97 = const i2.WasmI32(0);
          tmp98 = value.handle.toWasmI32();
          tmp99 = const i2.WasmI32(0);
          tmp100 = const i2.WasmI64(0);
          tmp101 = const i2.WasmI32(0);
          tmp102 = const i2.WasmI32(0);
          tmp103 = const i2.WasmI32(0);
          tmp104 = const i2.WasmI32(0);

        case i1.ErrorResult(:final value):
          i2.WasmI32 tmp90;
          i2.WasmI32 tmp91;
          i2.WasmI64 tmp92;
          i2.WasmI32 tmp93;
          i2.WasmI32 tmp94;
          i2.WasmI32 tmp95;
          i2.WasmI32 tmp96;
          switch (value) {
            case i5.TypesErrorCodeDnsTimeout():
              tmp90 = const i2.WasmI32(0);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeDnsError(payload: final value):
              i2.WasmI32 tmp3;
              i2.WasmI32 tmp4;
              i2.WasmI32 tmp5;
              final tmp6 = value.rcode;
              if (tmp6.hasValue) {
                final value = tmp6.requireValue();
                final tmp2 = i1.AllocatedString.allocateUtf16(value);
                tmp3 = const i2.WasmI32(1);
                tmp4 = tmp2.ptr;
                tmp5 = tmp2.packedLength;
                tmp2.free();
              } else {
                tmp3 = const i2.WasmI32(0);
                tmp4 = const i2.WasmI32(0);
                tmp5 = const i2.WasmI32(0);
              }
              i2.WasmI32 tmp7;
              i2.WasmI32 tmp8;
              final tmp9 = value.infoCode;
              if (tmp9.hasValue) {
                final value = tmp9.requireValue();
                tmp7 = const i2.WasmI32(1);
                tmp8 = i2.WasmI32.uint16FromInt(value);
              } else {
                tmp7 = const i2.WasmI32(0);
                tmp8 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(1);
              tmp91 = tmp3;
              tmp92 = i2.WasmI64.fromInt(tmp4.toIntUnsigned());
              tmp93 = tmp5;
              tmp94 = tmp7;
              tmp95 = tmp8;
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeDestinationNotFound():
              tmp90 = const i2.WasmI32(2);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeDestinationUnavailable():
              tmp90 = const i2.WasmI32(3);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeDestinationIpProhibited():
              tmp90 = const i2.WasmI32(4);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeDestinationIpUnroutable():
              tmp90 = const i2.WasmI32(5);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConnectionRefused():
              tmp90 = const i2.WasmI32(6);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConnectionTerminated():
              tmp90 = const i2.WasmI32(7);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConnectionTimeout():
              tmp90 = const i2.WasmI32(8);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConnectionReadTimeout():
              tmp90 = const i2.WasmI32(9);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConnectionWriteTimeout():
              tmp90 = const i2.WasmI32(10);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConnectionLimitReached():
              tmp90 = const i2.WasmI32(11);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeTlsProtocolError():
              tmp90 = const i2.WasmI32(12);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeTlsCertificateError():
              tmp90 = const i2.WasmI32(13);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeTlsAlertReceived(payload: final value):
              i2.WasmI32 tmp10;
              i2.WasmI32 tmp11;
              final tmp12 = value.alertId;
              if (tmp12.hasValue) {
                final value = tmp12.requireValue();
                tmp10 = const i2.WasmI32(1);
                tmp11 = i2.WasmI32.uint8FromInt(value);
              } else {
                tmp10 = const i2.WasmI32(0);
                tmp11 = const i2.WasmI32(0);
              }
              i2.WasmI32 tmp14;
              i2.WasmI32 tmp15;
              i2.WasmI32 tmp16;
              final tmp17 = value.alertMessage;
              if (tmp17.hasValue) {
                final value = tmp17.requireValue();
                final tmp13 = i1.AllocatedString.allocateUtf16(value);
                tmp14 = const i2.WasmI32(1);
                tmp15 = tmp13.ptr;
                tmp16 = tmp13.packedLength;
                tmp13.free();
              } else {
                tmp14 = const i2.WasmI32(0);
                tmp15 = const i2.WasmI32(0);
                tmp16 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(14);
              tmp91 = tmp10;
              tmp92 = i2.WasmI64.fromInt(tmp11.toIntUnsigned());
              tmp93 = tmp14;
              tmp94 = tmp15;
              tmp95 = tmp16;
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestDenied():
              tmp90 = const i2.WasmI32(15);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestLengthRequired():
              tmp90 = const i2.WasmI32(16);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestBodySize(payload: final value):
              i2.WasmI32 tmp18;
              i2.WasmI64 tmp19;
              final tmp20 = value;
              if (tmp20.hasValue) {
                final value = tmp20.requireValue();
                tmp18 = const i2.WasmI32(1);
                tmp19 = i2.WasmI64.fromInt(value);
              } else {
                tmp18 = const i2.WasmI32(0);
                tmp19 = const i2.WasmI64(0);
              }
              tmp90 = const i2.WasmI32(17);
              tmp91 = tmp18;
              tmp92 = tmp19;
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestMethodInvalid():
              tmp90 = const i2.WasmI32(18);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestUriInvalid():
              tmp90 = const i2.WasmI32(19);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestUriTooLong():
              tmp90 = const i2.WasmI32(20);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestHeaderSectionSize(
              payload: final value,
            ):
              i2.WasmI32 tmp21;
              i2.WasmI32 tmp22;
              final tmp23 = value;
              if (tmp23.hasValue) {
                final value = tmp23.requireValue();
                tmp21 = const i2.WasmI32(1);
                tmp22 = i2.WasmI32.fromInt(value);
              } else {
                tmp21 = const i2.WasmI32(0);
                tmp22 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(21);
              tmp91 = tmp21;
              tmp92 = i2.WasmI64.fromInt(tmp22.toIntUnsigned());
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestHeaderSize(payload: final value):
              i2.WasmI32 tmp32;
              i2.WasmI32 tmp33;
              i2.WasmI32 tmp34;
              i2.WasmI32 tmp35;
              i2.WasmI32 tmp36;
              i2.WasmI32 tmp37;
              final tmp38 = value;
              if (tmp38.hasValue) {
                final value = tmp38.requireValue();
                i2.WasmI32 tmp25;
                i2.WasmI32 tmp26;
                i2.WasmI32 tmp27;
                final tmp28 = value.fieldName;
                if (tmp28.hasValue) {
                  final value = tmp28.requireValue();
                  final tmp24 = i1.AllocatedString.allocateUtf16(value);
                  tmp25 = const i2.WasmI32(1);
                  tmp26 = tmp24.ptr;
                  tmp27 = tmp24.packedLength;
                  tmp24.free();
                } else {
                  tmp25 = const i2.WasmI32(0);
                  tmp26 = const i2.WasmI32(0);
                  tmp27 = const i2.WasmI32(0);
                }
                i2.WasmI32 tmp29;
                i2.WasmI32 tmp30;
                final tmp31 = value.fieldSize;
                if (tmp31.hasValue) {
                  final value = tmp31.requireValue();
                  tmp29 = const i2.WasmI32(1);
                  tmp30 = i2.WasmI32.fromInt(value);
                } else {
                  tmp29 = const i2.WasmI32(0);
                  tmp30 = const i2.WasmI32(0);
                }
                tmp32 = const i2.WasmI32(1);
                tmp33 = tmp25;
                tmp34 = tmp26;
                tmp35 = tmp27;
                tmp36 = tmp29;
                tmp37 = tmp30;
              } else {
                tmp32 = const i2.WasmI32(0);
                tmp33 = const i2.WasmI32(0);
                tmp34 = const i2.WasmI32(0);
                tmp35 = const i2.WasmI32(0);
                tmp36 = const i2.WasmI32(0);
                tmp37 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(22);
              tmp91 = tmp32;
              tmp92 = i2.WasmI64.fromInt(tmp33.toIntUnsigned());
              tmp93 = tmp34;
              tmp94 = tmp35;
              tmp95 = tmp36;
              tmp96 = tmp37;

            case i5.TypesErrorCodeHttpRequestTrailerSectionSize(
              payload: final value,
            ):
              i2.WasmI32 tmp39;
              i2.WasmI32 tmp40;
              final tmp41 = value;
              if (tmp41.hasValue) {
                final value = tmp41.requireValue();
                tmp39 = const i2.WasmI32(1);
                tmp40 = i2.WasmI32.fromInt(value);
              } else {
                tmp39 = const i2.WasmI32(0);
                tmp40 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(23);
              tmp91 = tmp39;
              tmp92 = i2.WasmI64.fromInt(tmp40.toIntUnsigned());
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpRequestTrailerSize(payload: final value):
              i2.WasmI32 tmp43;
              i2.WasmI32 tmp44;
              i2.WasmI32 tmp45;
              final tmp46 = value.fieldName;
              if (tmp46.hasValue) {
                final value = tmp46.requireValue();
                final tmp42 = i1.AllocatedString.allocateUtf16(value);
                tmp43 = const i2.WasmI32(1);
                tmp44 = tmp42.ptr;
                tmp45 = tmp42.packedLength;
                tmp42.free();
              } else {
                tmp43 = const i2.WasmI32(0);
                tmp44 = const i2.WasmI32(0);
                tmp45 = const i2.WasmI32(0);
              }
              i2.WasmI32 tmp47;
              i2.WasmI32 tmp48;
              final tmp49 = value.fieldSize;
              if (tmp49.hasValue) {
                final value = tmp49.requireValue();
                tmp47 = const i2.WasmI32(1);
                tmp48 = i2.WasmI32.fromInt(value);
              } else {
                tmp47 = const i2.WasmI32(0);
                tmp48 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(24);
              tmp91 = tmp43;
              tmp92 = i2.WasmI64.fromInt(tmp44.toIntUnsigned());
              tmp93 = tmp45;
              tmp94 = tmp47;
              tmp95 = tmp48;
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseIncomplete():
              tmp90 = const i2.WasmI32(25);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseHeaderSectionSize(
              payload: final value,
            ):
              i2.WasmI32 tmp50;
              i2.WasmI32 tmp51;
              final tmp52 = value;
              if (tmp52.hasValue) {
                final value = tmp52.requireValue();
                tmp50 = const i2.WasmI32(1);
                tmp51 = i2.WasmI32.fromInt(value);
              } else {
                tmp50 = const i2.WasmI32(0);
                tmp51 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(26);
              tmp91 = tmp50;
              tmp92 = i2.WasmI64.fromInt(tmp51.toIntUnsigned());
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseHeaderSize(payload: final value):
              i2.WasmI32 tmp54;
              i2.WasmI32 tmp55;
              i2.WasmI32 tmp56;
              final tmp57 = value.fieldName;
              if (tmp57.hasValue) {
                final value = tmp57.requireValue();
                final tmp53 = i1.AllocatedString.allocateUtf16(value);
                tmp54 = const i2.WasmI32(1);
                tmp55 = tmp53.ptr;
                tmp56 = tmp53.packedLength;
                tmp53.free();
              } else {
                tmp54 = const i2.WasmI32(0);
                tmp55 = const i2.WasmI32(0);
                tmp56 = const i2.WasmI32(0);
              }
              i2.WasmI32 tmp58;
              i2.WasmI32 tmp59;
              final tmp60 = value.fieldSize;
              if (tmp60.hasValue) {
                final value = tmp60.requireValue();
                tmp58 = const i2.WasmI32(1);
                tmp59 = i2.WasmI32.fromInt(value);
              } else {
                tmp58 = const i2.WasmI32(0);
                tmp59 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(27);
              tmp91 = tmp54;
              tmp92 = i2.WasmI64.fromInt(tmp55.toIntUnsigned());
              tmp93 = tmp56;
              tmp94 = tmp58;
              tmp95 = tmp59;
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseBodySize(payload: final value):
              i2.WasmI32 tmp61;
              i2.WasmI64 tmp62;
              final tmp63 = value;
              if (tmp63.hasValue) {
                final value = tmp63.requireValue();
                tmp61 = const i2.WasmI32(1);
                tmp62 = i2.WasmI64.fromInt(value);
              } else {
                tmp61 = const i2.WasmI32(0);
                tmp62 = const i2.WasmI64(0);
              }
              tmp90 = const i2.WasmI32(28);
              tmp91 = tmp61;
              tmp92 = tmp62;
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseTrailerSectionSize(
              payload: final value,
            ):
              i2.WasmI32 tmp64;
              i2.WasmI32 tmp65;
              final tmp66 = value;
              if (tmp66.hasValue) {
                final value = tmp66.requireValue();
                tmp64 = const i2.WasmI32(1);
                tmp65 = i2.WasmI32.fromInt(value);
              } else {
                tmp64 = const i2.WasmI32(0);
                tmp65 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(29);
              tmp91 = tmp64;
              tmp92 = i2.WasmI64.fromInt(tmp65.toIntUnsigned());
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseTrailerSize(payload: final value):
              i2.WasmI32 tmp68;
              i2.WasmI32 tmp69;
              i2.WasmI32 tmp70;
              final tmp71 = value.fieldName;
              if (tmp71.hasValue) {
                final value = tmp71.requireValue();
                final tmp67 = i1.AllocatedString.allocateUtf16(value);
                tmp68 = const i2.WasmI32(1);
                tmp69 = tmp67.ptr;
                tmp70 = tmp67.packedLength;
                tmp67.free();
              } else {
                tmp68 = const i2.WasmI32(0);
                tmp69 = const i2.WasmI32(0);
                tmp70 = const i2.WasmI32(0);
              }
              i2.WasmI32 tmp72;
              i2.WasmI32 tmp73;
              final tmp74 = value.fieldSize;
              if (tmp74.hasValue) {
                final value = tmp74.requireValue();
                tmp72 = const i2.WasmI32(1);
                tmp73 = i2.WasmI32.fromInt(value);
              } else {
                tmp72 = const i2.WasmI32(0);
                tmp73 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(30);
              tmp91 = tmp68;
              tmp92 = i2.WasmI64.fromInt(tmp69.toIntUnsigned());
              tmp93 = tmp70;
              tmp94 = tmp72;
              tmp95 = tmp73;
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseTransferCoding(
              payload: final value,
            ):
              i2.WasmI32 tmp76;
              i2.WasmI32 tmp77;
              i2.WasmI32 tmp78;
              final tmp79 = value;
              if (tmp79.hasValue) {
                final value = tmp79.requireValue();
                final tmp75 = i1.AllocatedString.allocateUtf16(value);
                tmp76 = const i2.WasmI32(1);
                tmp77 = tmp75.ptr;
                tmp78 = tmp75.packedLength;
                tmp75.free();
              } else {
                tmp76 = const i2.WasmI32(0);
                tmp77 = const i2.WasmI32(0);
                tmp78 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(31);
              tmp91 = tmp76;
              tmp92 = i2.WasmI64.fromInt(tmp77.toIntUnsigned());
              tmp93 = tmp78;
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseContentCoding(
              payload: final value,
            ):
              i2.WasmI32 tmp81;
              i2.WasmI32 tmp82;
              i2.WasmI32 tmp83;
              final tmp84 = value;
              if (tmp84.hasValue) {
                final value = tmp84.requireValue();
                final tmp80 = i1.AllocatedString.allocateUtf16(value);
                tmp81 = const i2.WasmI32(1);
                tmp82 = tmp80.ptr;
                tmp83 = tmp80.packedLength;
                tmp80.free();
              } else {
                tmp81 = const i2.WasmI32(0);
                tmp82 = const i2.WasmI32(0);
                tmp83 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(32);
              tmp91 = tmp81;
              tmp92 = i2.WasmI64.fromInt(tmp82.toIntUnsigned());
              tmp93 = tmp83;
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpResponseTimeout():
              tmp90 = const i2.WasmI32(33);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpUpgradeFailed():
              tmp90 = const i2.WasmI32(34);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeHttpProtocolError():
              tmp90 = const i2.WasmI32(35);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeLoopDetected():
              tmp90 = const i2.WasmI32(36);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeConfigurationError():
              tmp90 = const i2.WasmI32(37);
              tmp91 = const i2.WasmI32(0);
              tmp92 = const i2.WasmI64(0);
              tmp93 = const i2.WasmI32(0);
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);

            case i5.TypesErrorCodeInternalError(payload: final value):
              i2.WasmI32 tmp86;
              i2.WasmI32 tmp87;
              i2.WasmI32 tmp88;
              final tmp89 = value;
              if (tmp89.hasValue) {
                final value = tmp89.requireValue();
                final tmp85 = i1.AllocatedString.allocateUtf16(value);
                tmp86 = const i2.WasmI32(1);
                tmp87 = tmp85.ptr;
                tmp88 = tmp85.packedLength;
                tmp85.free();
              } else {
                tmp86 = const i2.WasmI32(0);
                tmp87 = const i2.WasmI32(0);
                tmp88 = const i2.WasmI32(0);
              }
              tmp90 = const i2.WasmI32(38);
              tmp91 = tmp86;
              tmp92 = i2.WasmI64.fromInt(tmp87.toIntUnsigned());
              tmp93 = tmp88;
              tmp94 = const i2.WasmI32(0);
              tmp95 = const i2.WasmI32(0);
              tmp96 = const i2.WasmI32(0);
          }

          tmp97 = const i2.WasmI32(1);
          tmp98 = tmp90;
          tmp99 = tmp91;
          tmp100 = tmp92;
          tmp101 = tmp93;
          tmp102 = tmp94;
          tmp103 = tmp95;
          tmp104 = tmp96;
      }
      _component_0taskReturn(
        tmp97,
        tmp98,
        tmp99,
        tmp100,
        tmp101,
        tmp102,
        tmp103,
        tmp104,
      );
    },
    debugName: 'handle',
  );
  return asyncExitCode.toWasmI32();
}

@pragma('wasm:import', 'component._component_0taskReturn')
external i2.WasmVoid _component_0taskReturn(
  i2.WasmI32 p0,
  i2.WasmI32 p1,
  i2.WasmI32 p2,
  i2.WasmI64 p3,
  i2.WasmI32 p4,
  i2.WasmI32 p5,
  i2.WasmI32 p6,
  i2.WasmI32 p7,
);
@pragma('wasm:export', r'component_0_postreturn')
i2.WasmVoid _component_0$postreturn(i2.WasmI32 p0) {
  final tmp0 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 0);
  switch (tmp0) {
    case 0:
      break;
    case 1:
      final tmp1 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 8);
      switch (tmp1) {
        case 0:
          break;
        case 1:
          final tmp2 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp2) {
            case 0:
              break;
            case 1:
              final tmp3 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp4 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp3, tmp4).free();
              break;
          }
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
          final tmp5 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 20);
          switch (tmp5) {
            case 0:
              break;
            case 1:
              final tmp6 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              final tmp7 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 28);
              i1.AllocatedString(tmp6, tmp7).free();
              break;
          }
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
          final tmp8 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp8) {
            case 0:
              break;
            case 1:
              final tmp9 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 20);
              switch (tmp9) {
                case 0:
                  break;
                case 1:
                  final tmp10 = i1.memory.loadInt32(
                    p0.toIntUnsigned(),
                    offset: 24,
                  );
                  final tmp11 = i1.memory.loadInt32(
                    p0.toIntUnsigned(),
                    offset: 28,
                  );
                  i1.AllocatedString(tmp10, tmp11).free();
                  break;
              }
              break;
          }
          break;
        case 23:
          break;
        case 24:
          final tmp12 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp12) {
            case 0:
              break;
            case 1:
              final tmp13 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp14 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp13, tmp14).free();
              break;
          }
          break;
        case 25:
          break;
        case 26:
          break;
        case 27:
          final tmp15 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp15) {
            case 0:
              break;
            case 1:
              final tmp16 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp17 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp16, tmp17).free();
              break;
          }
          break;
        case 28:
          break;
        case 29:
          break;
        case 30:
          final tmp18 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp18) {
            case 0:
              break;
            case 1:
              final tmp19 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp20 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp19, tmp20).free();
              break;
          }
          break;
        case 31:
          final tmp21 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp21) {
            case 0:
              break;
            case 1:
              final tmp22 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp23 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp22, tmp23).free();
              break;
          }
          break;
        case 32:
          final tmp24 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp24) {
            case 0:
              break;
            case 1:
              final tmp25 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp26 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp25, tmp26).free();
              break;
          }
          break;
        case 33:
          break;
        case 34:
          break;
        case 35:
          break;
        case 36:
          break;
        case 37:
          break;
        case 38:
          final tmp27 = i1.memory.loadUint8(p0.toIntUnsigned(), offset: 16);
          switch (tmp27) {
            case 0:
              break;
            case 1:
              final tmp28 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 20);
              final tmp29 = i1.memory.loadInt32(p0.toIntUnsigned(), offset: 24);
              i1.AllocatedString(tmp28, tmp29).free();
              break;
          }
          break;
      }
      break;
  }
  return i2.WasmVoid();
}
