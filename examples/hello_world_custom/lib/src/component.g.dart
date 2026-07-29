// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

// ignore: import_internal_library
import r'dart:_wasm' as i1;
import r'dart:typed_data' as i2;

abstract interface class Types {}

final class _Imported$Types implements Types {
  const _Imported$Types();
}

const importedInstance0 = _Imported$Types();

@pragma('wasm:import', 'component.stream2.new')
external i1.WasmI64 _streamNew2();
@pragma('wasm:import', 'component.stream2.write')
external i1.WasmI32 _streamWrite2(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream2.drop-writable')
external i1.WasmVoid _streamDropWritable2(i1.WasmI32 stream);

final class _Vtable2 implements i0.StreamVtable<i2.Uint8List> {
  const _Vtable2();

  @override
  int get elementSize => 1;
  @override
  int allocateBuffer(int size) {
    return i0
        .mallocAligned(const i1.WasmI32(1), (size * 1).toWasmI32())
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, int totalSize, int nonTransferredOffset) {
    i0.dartFree(
      address.toWasmI32(),
      (totalSize * 1).toWasmI32(),
      const i1.WasmI32(1),
    );
  }

  @override
  void writeToBuffer(int address, i2.Uint8List elements) {
    for (final (i, element) in elements.indexed) {
      final wasmAddress = i1.WasmI32.fromInt(address + i);

      i0.memory.storeInt8(
        wasmAddress.toIntUnsigned(),
        i1.WasmI32.uint8FromInt(element),
        offset: 0,
      );
    }
  }

  @override
  int newStream() => _streamNew2().toInt();
  @override
  void dropWritable(int stream) {
    _streamDropWritable2(i1.WasmI32.fromInt(stream));
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite2(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

enum ErrorCode {
  /// Input/output error
  io,

  /// Invalid or incomplete multibyte or wide character
  illegalByteSequence,

  /// Broken pipe
  pipe,
}

@pragma('wasm:import', 'component.future4.new')
external i1.WasmI64 _futureNew4();
@pragma('wasm:import', 'component.future4.write')
external i1.WasmI32 _futureWrite4(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future4.read')
external i1.WasmI32 _futureRead4(i1.WasmI32 future, i1.WasmI32 ptr);
@pragma('wasm:import', 'component.future4.drop-readable')
external i1.WasmVoid _futureDropReadable4(i1.WasmI32 future);
@pragma('wasm:import', 'component.future4.drop-writable')
external i1.WasmVoid _futureDropWritable4(i1.WasmI32 future);

final class _Vtable4 implements i0.FutureVtable<i0.Result<void, ErrorCode>> {
  const _Vtable4();

  @override
  int newFuture() => _futureNew4().toInt();

  @override
  int read(int future, int buffer) {
    return _futureRead4(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  int write(int future, int buffer) {
    return _futureWrite4(
      i1.WasmI32.fromInt(future),
      i1.WasmI32.fromInt(buffer),
    ).toIntUnsigned();
  }

  @override
  void dropRead(int future) {
    _futureDropReadable4(i1.WasmI32.fromInt(future));
  }

  @override
  void dropWrite(int future) {
    _futureDropWritable4(i1.WasmI32.fromInt(future));
  }

  @override
  int allocateBuffer() {
    return i0
        .mallocAligned(const i1.WasmI32(1), const i1.WasmI32(2))
        .toIntUnsigned();
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {
    i0.dartFree(address.toWasmI32(), const i1.WasmI32(2), const i1.WasmI32(1));
  }

  @override
  void store(int address, i0.Result<void, ErrorCode> value) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    switch (value) {
      case i0.OkResult(:final value):
        i0.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(0),
          offset: 0,
        );

      case i0.ErrorResult(:final value):
        i0.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          const i1.WasmI32(1),
          offset: 0,
        );
        i0.memory.storeInt8(
          wasmAddress.toIntUnsigned(),
          value.index.toWasmI32(),
          offset: 1,
        );
    }
  }

  @override
  i0.Result<void, ErrorCode> load(int address) {
    final wasmAddress = i1.WasmI32.fromInt(address);

    final tmp0 = i0.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 0);
    final i0.Result<void, ErrorCode> tmp2;
    if (tmp0.toBool()) {
      final tmp1 = i0.memory.loadUint8(wasmAddress.toIntUnsigned(), offset: 1);

      tmp2 = .error(ErrorCode.values[tmp1.toIntUnsigned()]);
    } else {
      tmp2 = .ok(null);
    }

    return tmp2;
  }
}

abstract interface class Stdout {
  Future<i0.Result<void, ErrorCode>> writeViaStream({
    required Stream<i2.Uint8List> data,
  });
}

@pragma("wasm:import", r"component._import8")
external i1.WasmI32 _import8(i1.WasmI32 p0);

final class _Imported$Stdout implements Stdout {
  const _Imported$Stdout();
  @override
  Future<i0.Result<void, ErrorCode>> writeViaStream({
    required Stream<i2.Uint8List> data,
  }) {
    final tmp0 = i0.newReadableStream(const _Vtable2(), data).toWasmI32();
    final tmp1 = _import8(tmp0);
    final tmp2 = i0.readFuture(const _Vtable4(), tmp1.toIntUnsigned());
    return tmp2;
  }
}

const importedInstance1 = _Imported$Stdout();

abstract interface class Run {
  Future<i0.Result<void, void>> run();
}

late Run _unnamedExport2;
void defineInstanceExport({required Run unnamedExport2}) {
  _unnamedExport2 = unnamedExport2;
}

@pragma('wasm:export', r'component_0')
i1.WasmI32 _component_0() {
  final asyncExitCode = i0.spawnTask(
    run: () async {
      final tmp0 = await _unnamedExport2.run();
      i1.WasmI32 tmp1;
      switch (tmp0) {
        case i0.OkResult(:final value):
          tmp1 = const i1.WasmI32(0);
        case i0.ErrorResult(:final value):
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
