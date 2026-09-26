import 'dart:async';

import 'package:test_runner/test_runner.dart';
import 'package:wasm_components/src/runtime/async/future.dart';
import 'package:wasm_components/src/runtime/async/stream.dart';
import 'package:wasm_components/src/runtime/async/waitable.dart';

/// Verifies that when `onDone` fires while a host `write` is still pending
/// (`blockedCode`), `dropWritable` is NOT called until `CopyResult.completed`
/// finishes the pending write (preventing WASI 0.3's `cannot drop busy stream`
/// trap).
void testStreamSinkDeferredDrop(BaseResultCollector collector) {
  final vtable = _FakeStreamVtable();
  final sub = _DirectSubscription<List<int>>(bufferWhenPaused: false);

  final state = StreamSinkState<List<int>>(vtable, null, sub, 42);
  // Complete the initial 0-length handshake write so the subscription resumes.
  state.dispatchEvent(CopyResult.completed.index);

  // Emit a chunk (which blocks in write()) and immediately signal onDone
  // while `_pendingWrite` is still non-null.
  sub.emitData(const [10, 20, 30]);
  sub.emitDone();

  // While the write of 3 bytes is still pending, dropWritable must be false.
  collector.recordBool(e: vtable.droppedWritable);
  collector.recordInt(e: vtable.writtenChunks.length);

  // Once the host completes the 3-byte write, dropWritable must fire.
  state.dispatchEvent(CopyResult.completed.index | (3 << 4));
  collector.recordBool(e: vtable.droppedWritable);
}

/// Verifies that `_onData` pauses the subscription while a write is pending so
/// subsequent synchronous chunks and `close()` queue cleanly without a
/// StateError or premature drop.
void testStreamSinkBackpressure(BaseResultCollector collector) {
  final vtable = _FakeStreamVtable();
  final sub = _DirectSubscription<List<int>>(bufferWhenPaused: true);

  final state = StreamSinkState<List<int>>(vtable, null, sub, 99);
  state.dispatchEvent(CopyResult.completed.index);

  // First chunk starts a blocking write and pauses `sub`.
  sub.emitData(const [1, 2]);
  collector.recordBool(e: sub.isPaused);
  collector.recordInt(e: vtable.writtenChunks.length);

  // Complete first write (2 elements); subscription resumes.
  state.dispatchEvent(CopyResult.completed.index | (2 << 4));
  collector.recordBool(e: sub.isPaused);

  // Emit second chunk and close while the second write is still pending.
  sub.emitData(const [3, 4, 5]);
  sub.emitDone();
  collector.recordInt(e: vtable.writtenChunks.length);
  collector.recordBool(e: vtable.droppedWritable);

  state.dispatchEvent(CopyResult.completed.index | (3 << 4));
  collector.recordBool(e: vtable.droppedWritable);
}

final class _DirectSubscription<T> implements StreamSubscription<T> {
  final bool bufferWhenPaused;
  final List<void Function()> _pending = [];
  void Function(T data)? _onData;
  void Function()? _onDone;
  var _paused = true;
  var _canceled = false;

  _DirectSubscription({required this.bufferWhenPaused});

  void emitData(T data) {
    if (_canceled) return;
    if (bufferWhenPaused && _paused) {
      _pending.add(() => _onData?.call(data));
    } else {
      _onData?.call(data);
    }
  }

  void emitDone() {
    if (_canceled) return;
    if (bufferWhenPaused && _paused) {
      _pending.add(() => _onDone?.call());
    } else {
      _onDone?.call();
    }
  }

  @override
  bool get isPaused => _paused;

  @override
  void onData(void Function(T data)? handleData) => _onData = handleData;

  @override
  void onDone(void Function()? handleDone) => _onDone = handleDone;

  @override
  void onError(Function? handleError) {}

  @override
  void pause([Future<void>? resumeSignal]) => _paused = true;

  @override
  void resume() {
    _paused = false;
    while (!_paused && !_canceled && _pending.isNotEmpty) {
      _pending.removeAt(0)();
    }
  }

  @override
  Future<void> cancel() {
    _canceled = true;
    _pending.clear();
    return const _DummyFuture<void>();
  }

  @override
  Future<E> asFuture<E>([E? futureValue]) => const _DummyFuture();
}

final class _DummyFuture<T> implements Future<T> {
  const _DummyFuture();

  @override
  Stream<T> asStream() => throw UnimplementedError();

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) =>
      this;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function? onError,
  }) => const _DummyFuture();

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      this;

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) => this;
}

final class _FakeStreamVtable implements StreamVtable<List<int>> {
  final List<List<int>> writtenChunks = [];
  final Map<int, List<int>> _buffers = {};
  var _nextAddress = 1;
  var droppedWritable = false;

  @override
  int get elementSize => 1;

  @override
  int allocateBuffer(int size) {
    final addr = _nextAddress++;
    _buffers[addr] = List<int>.filled(size, 0);
    return addr;
  }

  @override
  void writeToBuffer(int address, List<int> elements) {
    _buffers[address] = List<int>.of(elements);
  }

  @override
  int write(int stream, int ptr, int n) {
    if (n > 0) {
      writtenChunks.add(_buffers[ptr]!);
    }
    return blockedCode;
  }

  @override
  void freeBuffer(int address, int totalSize, int start, int end) {
    _buffers.remove(address);
  }

  @override
  void dropWritable(int stream) {
    droppedWritable = true;
  }

  @override
  void dropReadable(int stream) {}

  @override
  int newStream() => 0;

  @override
  int read(int stream, int ptr, int n) => blockedCode;

  @override
  List<int> readFromBuffer(int address, int count) => const [];
}
