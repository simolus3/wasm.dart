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

  /// Calls `canon stream.drop-readable` on the stream.
  void dropReadable(int stream);

  /// Calls `canon stream.read` on the stream.
  int read(int stream, int ptr, int n);

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

    /// The index of the first element in the buffer that is owned by our side
    /// of the buffer (hasn't been written or read out of).
    int start,

    /// From `start`, the size of the span of elements still owned by the
    /// buffer.
    int amount,
  );

  void writeToBuffer(int address, T elements);

  T readFromBuffer(int address, int count);
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

/// A readable stream in the WebAssembly component model.
///
/// Its [listen] method provides the `bufferSizeInBytes` parameter, which can be
/// used to control the size of buffers requested for the underlying stream
/// reads.
final class ReadableStream<T extends List<Object?>> extends Stream<T> {
  final int _handle;
  final StreamVtable<T> _vtable;
  var _didListen = false;

  new(this._handle, this._vtable);

  @override
  bool get isBroadcast => false;

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    int bufferSizeInBytes = 1024,
  }) {
    if (_didListen) {
      throw StateError('Can only listen to component model streams once');
    }
    _didListen = true;

    return Stream<T>.multi((controller) {
      StreamReadState(
        controller,
        _vtable,
        .forCurrentZone(),
        _handle,
        bufferSizeInBytes,
      );
    }).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
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
        pending.totalLength,
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
                  0,
                  0,
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

  int get remaining => totalLength - acknowledged;
}

/// ## State machine
///
/// Reading streams can be in one of these states:
///
///  1. Waiting: There's an outstanding read to the stream.
///  2. Dropped: The other stream end has been dropped,
///     [StreamSubscription.onDone] was called and the stream is done.
///  3. Idle: After forwarding an event, the stream was paused. We'll resume
///     waiting when the subscription resumes.
///  4. Cancelled: If the subscription was cancelled and we're not currently
///     waiting for an event, we cna drop the stream.
///
/// We don't currently support cancelling a pending wait, so the state machine
/// is as follows:
///
///  - We start by calling `stream.read` after [Stream.listen], in the waiting
///    state. Then,
///     - if we receive a copy complete event, call [StreamSubscription.onData].
///       - if the subscription still has a listener, call `stream.read` again
///         and transition to waiting.
///       - if it's paused, transition to idle.
///       - if it's cancelled, drop the readable end and transition to
///         cancelled.
///     - if we receive a dropped event, call [StreamSubscription.onDone] and
///       transition to dropped.
///  - In the idle state: Once the subscription is resumed, call `stream.read`
///    and transition to waiting. If it's cancelled, drop the readable and
///    transition to cancelled.
///
/// We don't currently support cancelling an in-progress read.
@internal
final class StreamReadState<T extends List<Object?>> {
  final MultiStreamController<T> _controller;
  final StreamVtable<T> _vtable;
  final Task _task;
  final int _id;
  final int _elementSize;
  int _readBufferSize = -1;

  // If we're in the waiting state, a pending read.
  _PendingStreamBuffer? _pendingRead;
  var _dropped = false;

  new(this._controller, this._vtable, this._task, this._id, int bufferSize)
    : _elementSize = _vtable.elementSize {
    _readBufferSize = max(bufferSize ~/ _elementSize, 1);

    _task.readStreams[_id] = this;
    _controller.onResume = _resume;
    _startReading();
  }

  void _startReading() {
    _dispatchEvent(_readCode(), false);
  }

  int _readCode() {
    assert(_controller.hasListener && !_controller.isPaused);

    if (_pendingRead case final existing?) {
      return _vtable.read(
        _id,
        existing.startPointer + _elementSize * existing.acknowledged,
        existing.remaining,
      );
    } else {
      final start = _vtable.allocateBuffer(_readBufferSize);
      _pendingRead = _PendingStreamBuffer(start, _readBufferSize);
      return _vtable.read(_id, start, _readBufferSize);
    }
  }

  void _resume() {
    if (!_dropped) {
      _startReading();
    }
  }

  void dispatchEvent(int code) {
    _dispatchEvent(code, true);
  }

  void _dispatchEvent(int code, bool async) {
    readLoop:
    while (true) {
      if (code == blockedCode) break;

      final eventCode = CopyResult.values[code & 0x0f];
      final elementsRead = code >>> 4;
      switch (eventCode) {
        case CopyResult.completed:
          _forwardData(async, elementsRead);

          if (!_controller.hasListener) {
            _completeClose();
          } else if (_controller.isPaused) {
            // Nothing to do! We'll resume when the subscription is resumed.
          } else {
            // Keep reading.
            code = _readCode();
            continue readLoop;
          }
        case CopyResult.dropped:
          _forwardData(async, elementsRead);

          async ? _controller.closeSync() : _controller.close();
          _completeClose();
        case CopyResult.cancelled:
          // Cancelled means that we tried to cancel an in-progress read, which
          // is something we don't currently do.
          throw UnimplementedError();
      }

      break readLoop;
    }
  }

  void _forwardData(bool forwardSynchronously, int elementsRead) {
    if (_pendingRead case final pending?) {
      final chunk = _vtable.readFromBuffer(
        pending.startPointer + pending.acknowledged * _elementSize,
        elementsRead,
      );
      pending.advance(elementsRead);
      if (pending.remaining == 0) _pendingRead = null;

      forwardSynchronously
          ? _controller.addSync(chunk)
          : _controller.add(chunk);
    }
  }

  void _completeClose() {
    if (_pendingRead case final pending? when pending.totalLength > 0) {
      _vtable.freeBuffer(
        pending.startPointer,
        pending.totalLength,
        pending.acknowledged,
        pending.remaining,
      );
    }

    _vtable.dropReadable(_id);
    _task.readStreams.remove(_id);
    _dropped = true;
  }
}
