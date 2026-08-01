import 'dart:async';
// ignore: import_internal_library
import 'dart:_wasm';
import 'dart:math';

import 'package:meta/meta.dart';

import 'future.dart';
import 'task.dart';
import 'waitable.dart';

abstract interface class StreamVtable<T extends List<Object?>> {
  /// Calls `canon stream.new` with the appropriate type.
  int newStream();

  /// Calls `canon stream.write` on the stream.
  int write(int stream, int ptr, int n);

  /// Calls `canon stream.drop-writable` on the stream.
  void dropWritable(int stream);

  int get elementSize;

  /// Allocates a buffer holding the given amount of elements.
  int allocateBuffer(int size);

  /// Frees a buffer allocated by [allocateBuffer].
  void freeBuffer(
    /// The address returned by [allocateBuffer]
    int address,

    /// The total size of the buffer in elements.
    ///
    /// This is always equal to the size of elements passed to [allocateBuffer].
    int totalSize,

    /// The amount of elements that have been transferred through the stream
    /// (acknowledged by the other component).
    ///
    /// Remaining items in the buffer at this offset are still owned by this
    /// component and we may have to run their destructors.
    int nonTransferredOffset,
  );

  void writeToBuffer(int address, T elements);
}

/// Creates a stream from the Dart [stream].
///
/// Returns the handle id of the readable end of the stream.
int newReadableStream<T extends List<Object?>>(
  StreamVtable<T> vtable,
  Stream<T> stream,
) {
  final task = Task.forCurrentZone();

  final streams = vtable.newStream();
  final readable = streams.toUnsigned(32);
  final writable = streams >>> 32;

  final subscription = stream.listen(null);
  subscription.pause();

  final state = StreamSinkState<T>(vtable, task, subscription, writable);
  task.writeStreams[writable] = state;
  task.waitable.addWaitable(WasmI32.fromInt(writable));

  return readable;
}

/// Turns the readable end of a component model stream into a Dart stream.
Stream<T> readStream<T extends List<Object?>>(
  int handle,
  StreamVtable<T> vtable, {
  int bufferSizeInBytes = 1024,
}) {
  final state = StreamReadState(
    vtable,
    .forCurrentZone(),
    handle,
    bufferSizeInBytes,
  );
  return state._controller.stream;
}

@internal
final class StreamSinkState<T extends List<Object?>> {
  final StreamVtable<T> _vtable;
  final Task _task;
  final StreamSubscription<T> _subscription;
  final int _id;
  final int _elementSize;

  var _otherEndDropped = false;
  var _dropped = false;

  _PendingStreamBuffer? _pendingWrite;

  new(this._vtable, this._task, this._subscription, this._id)
    : _elementSize = _vtable.elementSize {
    // The subscription is paused initially. Start an empty write, which will
    // block if there's no pending listener and otherwise allows us to resume
    // the subscription.
    assert(_subscription.isPaused);
    _subscription.onData(_onData);
    _subscription.onDone(_onDone);

    dispatchEvent(_startWrite(_PendingStreamBuffer(0, 0)));
  }

  void _onData(T data) {
    if (_pendingWrite != null || _otherEndDropped || _dropped) {
      throw StateError(
        'Stream subscription emitted event during pause or after cancellation.',
      );
    }

    final start = _vtable.allocateBuffer(data.length);
    _vtable.writeToBuffer(start, data);
    final buffer = _PendingStreamBuffer(start, data.length);
    dispatchEvent(_startWrite(buffer));
  }

  void _onDone() {
    _subscription.cancel();
    drop();
  }

  int _startWrite(_PendingStreamBuffer write) {
    assert(_pendingWrite == null);
    _pendingWrite = write;
    return _vtable.write(_id, write.startPointer, write.totalLength);
  }

  void _dropPendingWriteBuffer() {
    if (_pendingWrite case final pending? when pending.totalLength > 0) {
      _vtable.freeBuffer(
        pending.startPointer,
        pending.totalLength,
        pending.acknowledged,
      );
    }
  }

  void dispatchEvent(int code) {
    writeLoop:
    while (true) {
      if (code == blockedCode) break;

      final eventCode = CopyResult.values[code & 0x0f];
      final elementsTransferred = code >>> 4;
      switch (eventCode) {
        case CopyResult.completed:
          assert(_subscription.isPaused);
          if (_pendingWrite case final pending?) {
            pending.advance(elementsTransferred);

            if (pending.acknowledged == pending.totalLength) {
              if (pending.totalLength > 0) {
                _vtable.freeBuffer(
                  pending.startPointer,
                  pending.totalLength,
                  pending.totalLength,
                );
              }

              _pendingWrite = null;
            } else {
              // Continue partial write.
              code = _vtable.write(
                _id,
                pending.startPointer + _elementSize,
                pending.totalLength - pending.acknowledged,
              );
              continue writeLoop;
            }
          }

          // We've completed the write, so the subscription can be resumed.
          assert(_pendingWrite == null);
          _subscription.resume();
        case CopyResult.dropped:
          _pendingWrite?.advance(elementsTransferred);
          _dropPendingWriteBuffer();
          _otherEndDropped = true;
          // The other end has been dropped, this corresponds to a cancelled
          // subscription in Dart.
          _subscription.cancel().whenComplete(drop);
        case CopyResult.cancelled:
          // Cancelled means that we tried to cancel an in-progress write, which
          // is something we don't currently do.
          throw UnimplementedError();
      }

      // If we didn't explicitly continue a write, break out of the loop.
      break writeLoop;
    }
  }

  void drop() {
    if (!_dropped) {
      _dropped = true;
      _vtable.dropWritable(_id);
      _task.writeStreams.remove(_id);
    }
  }
}

class _PendingStreamBuffer {
  final int startPointer;
  final int totalLength;
  int acknowledged = 0;

  new(this.startPointer, this.totalLength);

  void advance(int numCopied) {
    acknowledged += numCopied;
  }
}

@internal
final class StreamReadState<T extends List<Object?>> {
  final StreamController<T> _controller = StreamController(sync: true);
  final StreamVtable<T> _vtable;
  final Task _task;
  final int _id;
  final int _elementSize;
  int _readBufferSize = -1;

  _PendingStreamBuffer? _pendingRead;

  new(this._vtable, this._task, this._id, int bufferSize)
    : _elementSize = _vtable.elementSize {
    _controller
      ..onListen = _listenOrResume
      ..onResume = _listenOrResume
      ..onCancel = _cancel;

    _readBufferSize = max(bufferSize ~/ _elementSize, 1);
    throw 'todo: stream reads';
  }

  void _dropPendingReadBuffer() {
    if (_pendingRead case final pending? when pending.totalLength > 0) {
      _vtable.freeBuffer(
        pending.startPointer,
        pending.totalLength,
        pending.acknowledged,
      );
    }
  }

  void _listenOrResume() {
    if (_pendingRead == null) {}
  }

  void _cancel() {}

  void dispatchEvent(int code) {}
}
