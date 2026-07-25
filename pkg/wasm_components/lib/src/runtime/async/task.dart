import 'dart:async';
// ignore: import_internal_library
import 'dart:_wasm';
import 'dart:collection';

import 'package:meta/meta.dart';

import '../../embedder/clock.dart';
import 'callback.dart';
import 'future.dart';
import 'timer.dart';
import 'waitable.dart';

@pragma('wasm:import', 'component.canon.context.set_i32_0')
external WasmVoid _contextSet(WasmI32 context);

@pragma('wasm:import', 'component.canon.context.get_i32_0')
external WasmI32 _contextGet();

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

@pragma('wasm:import', 'component.canon.subtask.drop')
external WasmVoid _subtaskDrop(WasmI32 task);

var _nextTaskId = 0;
final Map<int, Task> _activeTasks = {};

final class Task {
  final int _id;
  final String? _debugName;

  /// A set of async subtasks that this is waiting on.
  final WaitableSet _waitable = WaitableSet();

  final LinkedList<_MicrotaskEntry> _microtaskQueue = LinkedList();
  final Map<int, Subtask> _subtasks = {};
  final Map<int, FutureEventHandler> _pendingFutureWrites = {};
  final Map<int, FutureEventHandler> _pendingFutureReads = {};

  var _isRunning = false;
  var _microtaskScheduled = false;

  new _(this._id, this._debugName) {
    _activeTasks[_id] = this;
  }

  int _dispatchEvent(WasmI32 code, WasmI32 p1, WasmI32 p2) {
    _isRunning = true;

    final parsedCode = EventCode.values[code.toIntUnsigned()];
    switch (parsedCode) {
      case EventCode.none:
        // We'll just run the microtask queue.
        break;
      case EventCode.subtask:
        final task = p1.toIntUnsigned();
        final state = _SubtaskState.values[p2.toIntSigned()];
        final isDone = _subtasks[task]!._dispatchEvent(state);
        if (isDone) {
          _subtaskDrop(p1);
          _subtasks.remove(task);
        }
      case EventCode.streamRead:
        throw UnimplementedError();
      case EventCode.streamWrite:
        throw UnimplementedError();
      case EventCode.futureRead:
        final futureIndex = p1.toIntUnsigned();
        final code = CopyResult.values[p2.toIntUnsigned()];
        _pendingFutureReads.remove(futureIndex)!(code);
      case EventCode.futureWrite:
        final futureIndex = p1.toIntUnsigned();
        final code = CopyResult.values[p2.toIntUnsigned()];
        _pendingFutureWrites.remove(futureIndex)!(code);
      case EventCode.taskCancelled:
        // We don't currently support cancellations, in the future we might want
        // to notify listeners.
        break;
    }

    return _finishEventLoopIteration();
  }

  /// Runs pending microtasks before yielding to the component embedder.
  int _finishEventLoopIteration() {
    assert(_isRunning);

    while (_microtaskQueue.isNotEmpty) {
      final task = _microtaskQueue.first..unlink();
      task.entry();
    }

    _isRunning = false;
    return CallbackCode.wait.packResult(_waitable);
  }

  /// Assert that the current thread is supposed to run this particular task.
  void _verifyCurrent() {
    assert(_isRunning);
    final actualId = _contextGet().toIntUnsigned();
    if (actualId != _id) {
      final associatedTask = _activeTasks[actualId];

      throw StateError(
        'Expect task $_debugName (id $_id) to run, but the current thread is '
        'associated with ${associatedTask?._debugName} (${associatedTask?._id}).',
      );
    }
  }

  /// A zone specification that associates async work with this task and
  /// verifies that the zone is not entered outside of the virtual thread for
  /// its task.
  ZoneSpecification get _zoneSpecification {
    return ZoneSpecification(
      run: <R>(self, parent, zone, f) {
        _verifyCurrent();
        return parent.run(zone, f);
      },
      runUnary: <R, T1>(self, parent, zone, f, arg) {
        _verifyCurrent();
        return parent.runUnary(zone, f, arg);
      },
      runBinary: <R, T1, T2>(self, parent, zone, f, arg1, arg2) {
        _verifyCurrent();
        return parent.runBinary(zone, f, arg1, arg2);
      },
      createTimer: (self, parent, zone, duration, f) {
        final inNanos = (duration.inMicroseconds * 1000).toWasmI64();
        final subtask = _trackSubtask(wasiMonotonicWaitFor(inNanos));

        return OneShotTimer(subtask, self.bindCallbackGuarded(f));
      },
      scheduleMicrotask: (self, parent, zone, f) {
        _microtaskQueue.add(_MicrotaskEntry(zone.bindCallbackGuarded(f)));

        if (!_isRunning && !_microtaskScheduled) {
          final (read, write) = extractFutureHandlesFromPackedCode(
            _voidFutureNew().toInt(),
          );
          _microtaskScheduled = true;
          _pendingFutureReads[read.handle] = (_) {
            _voidFutureDropRead(read.handle.toWasmI32());
          };
          _pendingFutureWrites[write.handle] = (_) {
            _voidFutureDropWrite(write.handle.toWasmI32());
          };

          final readHandle = read.handle.toWasmI32();
          _voidFutureRead(readHandle, const WasmI32(0));
          _waitable.addWaitable(readHandle);

          // Immediately complete the future to wake up the task.
          final writeHandle = write.handle.toWasmI32();
          _voidFutureWrite(writeHandle, const WasmI32(0));
          _waitable.addWaitable(writeHandle);
        }
      },
    );
  }

  Subtask _trackSubtask(WasmI32 createCode) {
    assert(_isRunning);
    final asInt = createCode.toIntUnsigned();
    final state = _SubtaskState.values[asInt & 0x0f];
    final taskIndex = asInt >>> 4;

    switch (state) {
      case _SubtaskState.starting:
      case _SubtaskState.started:
        _waitable.addWaitable(WasmI32.fromInt(taskIndex));
        final task = Subtask._();
        _subtasks[taskIndex] = task;
        return task;
      case _SubtaskState.returned:
      case _SubtaskState.cancelledBeforeStarted:
      case _SubtaskState.cancelledBeforeReturned:
        return ._alreadyCompleted(state);
    }
  }

  /// Configures a new task.
  ///
  /// This should only be called once from exported async component functions,
  /// which is typically done by generated code.
  @internal
  static int spawn({String? debugName, required void Function() run}) {
    final id = _nextTaskId++;
    final task = Task._(id, debugName);
    _contextSet(id.toWasmI32());

    task._isRunning = true;
    runZoned(
      run,
      zoneSpecification: task._zoneSpecification,
      zoneValues: {_currentTaskKey: task},
    );
    return task._finishEventLoopIteration();
  }

  static const _currentTaskKey = #_currentTask;
}

@internal
Task taskForCurrentThread() {
  return _activeTasks[_contextGet().toIntUnsigned()]!;
}

@internal
int dispatchEvent(Task t, WasmI32 code, WasmI32 p1, WasmI32 p2) {
  return t._dispatchEvent(code, p1, p2);
}

final class _MicrotaskEntry extends LinkedListEntry<_MicrotaskEntry> {
  final void Function() entry;

  _MicrotaskEntry(this.entry);
}

enum _SubtaskState {
  starting,
  started,
  returned,
  cancelledBeforeStarted,
  cancelledBeforeReturned,
}

/// A component-model subtask.
///
/// Subtasks are created when an async component function calls another async
/// function from another component.
final class Subtask {
  _SubtaskState _state = .starting;

  final Completer<void>? _completer;

  Subtask._() : _completer = Completer();

  Subtask._alreadyCompleted(this._state) : _completer = null;

  bool _dispatchEvent(_SubtaskState state) {
    _state = state;

    switch (state) {
      case _SubtaskState.starting:
      case _SubtaskState.started:
        return false;
      case _SubtaskState.returned:
        _completer?.complete();
        return true;
      case _SubtaskState.cancelledBeforeStarted:
      case _SubtaskState.cancelledBeforeReturned:
        // TODO: Add cancellation exception to return _completer?
        throw UnimplementedError();
    }
  }

  Future<void> get completion {
    if (_completer case final completer?) return completer.future;

    assert(_state == .returned, 'Must be immediately-returned subtask');
    return Future.value();
  }
}

Subtask createSubtask(WasmI32 subtaskReturnCode) {
  return taskForCurrentThread()._trackSubtask(subtaskReturnCode);
}
