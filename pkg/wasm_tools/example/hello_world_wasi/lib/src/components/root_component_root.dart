// ignore_for_file: type=warning
import r'wasi_cli.dart' as i0;

import r'package:wasm_components/wasm_components.dart' as i1;

// ignore: import_internal_library
import r'dart:_wasm' as i2;
import r'dart:typed_data' as i3;

final class _Imported$0 implements i0.Types {
  const _Imported$0();
}

const i0.Types importedInstance0 = _Imported$0();

@pragma('wasm:import', 'component.stream2.new')
external i2.WasmI64 _streamNew2();
@pragma('wasm:import', 'component.stream2.write')
external i2.WasmI32 _streamWrite2(
  i2.WasmI32 stream,
  i2.WasmI32 ptr,
  i2.WasmI32 n,
);
@pragma('wasm:import', 'component.stream2.drop-writable')
external i2.WasmVoid _streamDropWritable2(i2.WasmI32 stream);

final class _Vtable2 implements i1.StreamVtable<i3.Uint8List> {
  const _Vtable2();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i1
        .mallocAligned(const i2.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int nonTransferredOffset) {
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
  int newStream() => _streamNew2().toInt();
  @override
  void dropWritable(int stream) {
    _streamDropWritable2(i2.WasmI32.fromInt(stream));
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite2(
      i2.WasmI32.fromInt(stream),
      i2.WasmI32.fromInt(ptr),
      i2.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.future4.new')
external i2.WasmI64 _futureNew4();
@pragma('wasm:import', 'component.future4.write')
external i2.WasmI32 _futureWrite4(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future4.read')
external i2.WasmI32 _futureRead4(i2.WasmI32 future, i2.WasmI32 ptr);
@pragma('wasm:import', 'component.future4.drop-readable')
external i2.WasmVoid _futureDropReadable4(i2.WasmI32 future);
@pragma('wasm:import', 'component.future4.drop-writable')
external i2.WasmVoid _futureDropWritable4(i2.WasmI32 future);

final class _Vtable4 implements i1.FutureVtable<i1.Result<void, i0.ErrorCode>> {
  const _Vtable4();

  @override
  int newFuture() => _futureNew4().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead4(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite4(
      i2.WasmI32.fromInt(future),
      i2.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable4(i2.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable4(i2.WasmI32.fromInt(future));
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
  void store(int address, i1.Result<void, i0.ErrorCode> value) {
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
  i1.Result<void, i0.ErrorCode> load(int address) {
    final wasmAddress = i2.WasmI32.fromInt(address);

    final tmp0 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i1.Result<void, i0.ErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i1.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(i0.ErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

@pragma("wasm:import", r"component._import8")
external i2.WasmI32 _import8(i2.WasmI32 p0);

final class _Imported$1 implements i0.Stdout {
  const _Imported$1();
  @override
  Future<i1.Result<void, i0.ErrorCode>> writeViaStream({
    required Stream<i3.Uint8List> data,
  }) {
    final tmp0 = i1.newReadableStream(const _Vtable2(), data).toWasmI32();
    final tmp1 = _import8(tmp0);
    final tmp2 = i1.readFuture(const _Vtable4(), tmp1.toIntUnsigned());
    return tmp2;
  }
}

const i0.Stdout importedInstance1 = _Imported$1();
late i0.Run _unnamedExport2;
void defineInstanceExport({required i0.Run unnamedExport2}) {
  _unnamedExport2 = unnamedExport2;
}

@pragma('wasm:export', r'component_0')
i2.WasmI32 _component_0() {
  final asyncExitCode = i1.spawnTask(
    run: () async {
      final tmp0 = await _unnamedExport2.run();
      i2.WasmI32 tmp1;
      switch (tmp0) {
        case i1.OkResult(:final value):
          tmp1 = const i2.WasmI32(0);
        case i1.ErrorResult(:final value):
          tmp1 = const i2.WasmI32(1);
      }
      _component_0taskReturn(tmp1);
    },
    debugName: 'run',
  );
  return asyncExitCode.toWasmI32();
}

@pragma('wasm:import', 'component._component_0taskReturn')
external i2.WasmVoid _component_0taskReturn(i2.WasmI32 p0);
