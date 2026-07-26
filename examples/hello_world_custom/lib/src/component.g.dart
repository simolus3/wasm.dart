// ignore_for_file: type=warning
import r'package:wasm_components/wasm_components.dart' as i0;

// ignore: import_internal_library
import r'dart:_wasm' as i1;
import r'dart:typed_data' as i2;

@pragma('wasm:import', 'component.stream0.new')
external i1.WasmI64 _streamNew0();
@pragma('wasm:import', 'component.stream0.write')
external i1.WasmI32 _streamWrite0(
  i1.WasmI32 stream,
  i1.WasmI32 ptr,
  i1.WasmI32 n,
);
@pragma('wasm:import', 'component.stream0.drop-writable')
external i1.WasmVoid _streamDropWritable0(i1.WasmI32 stream);

final class _Vtable0 implements i0.StreamVtable<i2.Uint8List> {
  const _Vtable0();

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
  int newStream() => _streamNew0().toInt();
  @override
  void dropWritable(int stream) {
    _streamDropWritable0(i1.WasmI32.fromInt(stream));
  }

  @override
  int write(int stream, int ptr, int n) {
    return _streamWrite0(
      i1.WasmI32.fromInt(stream),
      i1.WasmI32.fromInt(ptr),
      i1.WasmI32.fromInt(n),
    ).toIntUnsigned();
  }
}

/// Component that can print stuff.
abstract interface class Print {
  void forwardToStdout({required Stream<i2.Uint8List> data});
}

@pragma("wasm:import", r"component._import0")
external i1.WasmVoid _import0(i1.WasmI32 p0);

final class _Imported$Print implements Print {
  const _Imported$Print();
  @override
  void forwardToStdout({required Stream<i2.Uint8List> data}) {
    final tmp0 = i0.newReadableStream(const _Vtable0(), data).toWasmI32();
    _import0(tmp0);
  }
}

const importedInstance0 = _Imported$Print();

abstract interface class Run {
  Future<i0.Result<void, void>> run();
}

late Run _unnamedExport1;
void defineInstanceExport({required Run unnamedExport1}) {
  _unnamedExport1 = unnamedExport1;
}

@pragma('wasm:export', r'component_0')
i1.WasmI32 _component_0() {
  final asyncExitCode = i0.spawnTask(
    run: () async {
      final tmp0 = await _unnamedExport1.run();
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
