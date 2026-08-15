library;

import 'dart:async';
// ignore: import_internal_library
import 'dart:_wasm';

import 'package:meta/meta.dart';

import 'task.dart';
import 'waitable.dart';

/// A type-specific description of how values are read from and stored in linear
/// memory.
abstract interface class FutureVtable<T> {
  /// Calls `canon future.new` with the type of this vtable.
  int newFuture();

  /// Calls `canon future.read` asynchronously with the type of this vtable.
  int read(int future, int buffer);

  /// Calls `canon future.write` asynchronously with the type of this vtable.
  int write(int future, int buffer);

  /// Calls `canon future.drop-read` with the type of this vtable.
  void dropRead(int future);

  /// Calls `canon future.drop-write` with the type of this vtable.
  void dropWrite(int future);

  /// Allocates buffer capable of holding a single element of [T].
  int allocateBuffer();

  /// Frees a buffer allocated with [allocateBuffer].
  ///
  /// [containsValue] describes whether the buffer currently contains a value
  /// that may have to be freed separately.
  void freeBuffer(int address, {required bool containsValue});

  /// Loads a value out of a buffer.
  T load(int address);

  /// Stores a value in a allocated buffer.
  void store(int address, T value);

  /// A builtin vtable implementation for `Future<void>`.
  static const FutureVtable<void> voidVtable = _VoidFutureVtable();
}

/// Converts a readable future to Dart.
Future<T> readFuture<T>(FutureVtable<T> vtable, int future) {
  return readFutureInternal(vtable, future, .forCurrentZone());
}

@internal
Future<T> readFutureInternal<T>(FutureVtable<T> vtable, int future, Task task) {
  final buffer = vtable.allocateBuffer();

  void drop() {
    vtable.dropRead(future);
    task.pendingFutureReads.remove(future);
  }

  void applyToCompleter(Completer<T> completer, CopyResult result) {
    switch (result) {
      case CopyResult.completed:
        final value = vtable.load(buffer);
        // no value in buffer because the load moves out of it
        vtable.freeBuffer(buffer, containsValue: false);
        drop();
        completer.complete(value);
      case CopyResult.dropped:
        // no value because the other end was dropped first.
        vtable.freeBuffer(buffer, containsValue: false);
        drop();
        completer.completeError(const RemoteEndDroppedException._());
      case CopyResult.cancelled:
        // We don't currently cancel reads
        throw UnimplementedError();
    }
  }

  final nativeRead = vtable.read(future, buffer);
  final Completer<T> completer;
  if (nativeRead == blockedCode) {
    // The read will complete asynchronously in a new event loop iteration, so
    // we can use a synchronous completer.
    completer = Completer<T>.sync();
    task.waitable.addWaitable(future.toWasmI32());
    task.pendingFutureReads[future] = (result) {
      applyToCompleter(completer, result);
    };
  } else {
    // The read was able to complete synchronously, introduce a microtask delay
    // for Dart.
    completer = Completer<T>();
    applyToCompleter(completer, CopyResult.values[nativeRead]);
  }

  return completer.future;
}

/// Generates a writable future and completes it with [future], using the
/// [vtable] to serialize values.
///
/// Returns the readable end of the created future, which can be passed to other
/// components or the host.
WasmI32 writeFuture<T>(Future<T> future, FutureVtable<T> vtable) {
  final (readableEnd, writable) = WritableFuture.create(
    vtable,
    Task.forCurrentZone(),
  );

  unawaited(future.then(writable.writeValue));
  return WasmI32.fromInt(readableEnd);
}

@internal
final class WritableFuture<T> {
  final int _handle;
  final FutureVtable<T> _vtable;
  final Task _task;

  int _buffer = 0;

  new _(this._handle, this._vtable, this._task);

  /// Creates a new future, returning the code for the readable end and the
  /// [WritableFuture] for the writable end.
  static (int, WritableFuture<T>) create<T>(FutureVtable<T> vtable, Task task) {
    final code = vtable.newFuture();
    final readableEnd = code.toUnsigned(32);
    final writableEnd = code >>> 32;

    return (readableEnd, WritableFuture._(writableEnd, vtable, task));
  }

  void _drop() {
    _vtable.dropWrite(_handle);
    _task.pendingFutureWrites.remove(_handle);
  }

  void _applyToCompleter(Completer<void> completer, CopyResult result) {
    switch (result) {
      case CopyResult.completed:
        // no value in buffer because it was transferred.
        _vtable.freeBuffer(_buffer, containsValue: false);
        _drop();
        completer.complete();
      case CopyResult.dropped:
        _vtable.freeBuffer(_buffer, containsValue: true);
        _drop();
        completer.completeError(const RemoteEndDroppedException._());
      case CopyResult.cancelled:
        // We don't currently cancel reads
        throw UnimplementedError();
    }
  }

  Future<void> writeValue(T value) {
    final buffer = _buffer = _vtable.allocateBuffer();
    _vtable.store(buffer, value);

    final writeResult = _vtable.write(_handle, buffer);
    final Completer<void> completer;
    if (writeResult == blockedCode) {
      // The write will complete asynchronously in a new event loop iteration,
      // so we can use a synchronous completer.
      completer = Completer.sync();
      _task.waitable.addWaitable(_handle.toWasmI32());
      _task.pendingFutureWrites[_handle] = (code) {
        _applyToCompleter(completer, code);
      };
    } else {
      completer = Completer();
      _applyToCompleter(completer, CopyResult.values[writeResult]);
    }

    return completer.future;
  }
}

/// An exception thrown when reading from or writing to a future where the other
/// end has been dropped before the write could be delivered.
final class RemoteEndDroppedException implements Exception {
  const RemoteEndDroppedException._();

  @override
  String toString() {
    return 'Remote end of future was dropped before read or write could complete';
  }
}

enum CopyResult { completed, dropped, cancelled }

typedef FutureEventHandler = void Function(CopyResult);

final class _VoidFutureVtable implements FutureVtable<void> {
  const _VoidFutureVtable();

  @override
  int allocateBuffer() => 0;

  @override
  void dropRead(int future) {
    _voidFutureDropRead(future.toWasmI32());
  }

  @override
  void dropWrite(int future) {
    _voidFutureDropWrite(future.toWasmI32());
  }

  @override
  void freeBuffer(int address, {required bool containsValue}) {}

  @override
  void load(int address) {}

  @override
  int newFuture() => _voidFutureNew().toInt();

  @override
  int read(int future, int buffer) {
    return _voidFutureRead(
      future.toWasmI32(),
      buffer.toWasmI32(),
    ).toIntUnsigned();
  }

  @override
  void store(int address, void value) {}

  @override
  int write(int future, int buffer) {
    return _voidFutureWrite(
      future.toWasmI32(),
      buffer.toWasmI32(),
    ).toIntUnsigned();
  }
}

@pragma('wasm:import', 'component.canon.future<void>.new')
external WasmI64 _voidFutureNew();

@pragma('wasm:import', 'component.canon.future<void>.read')
external WasmI32 _voidFutureRead(WasmI32 future, WasmI32 buffer);

@pragma('wasm:import', 'component.canon.future<void>.write')
external WasmI32 _voidFutureWrite(WasmI32 future, WasmI32 buffer);

@pragma('wasm:import', 'component.canon.future<void>.drop-read')
external WasmVoid _voidFutureDropRead(WasmI32 future);

@pragma('wasm:import', 'component.canon.future<void>.drop-write')
external WasmVoid _voidFutureDropWrite(WasmI32 future);
