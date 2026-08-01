import 'dart:async';
// ignore: import_internal_library
import 'dart:_wasm';
import 'dart:collection';

import '../../embedder/clock.dart';
import 'callback.dart';
import 'future.dart';
import 'stream_sink.dart';
import 'subtask.dart';
import 'timer.dart';
import 'waitable.dart';

@pragma('wasm:import', 'component.canon.context.set_i32_0')
external WasmVoid _contextSet(WasmI32 context);

@pragma('wasm:import', 'component.canon.context.get_i32_0')
external WasmI32 _contextGet();

@pragma('wasm:import', 'component.canon.subtask.drop')
external WasmVoid _subtaskDrop(WasmI32 task);

//@pragma('wasm:import', 'component.canon.subtask.cancel')
//external WasmI32 _subtaskCancel(WasmI32 task);

var _nextTaskId = 0;
final Map<int, Task> _activeTasks = {};

final class Task {
  final int _id;
  final String? _debugName;

  /// The root zone for this task, created when it was originally created.
  late Zone _rootZone;
  (Object, StackTrace)? _unhandledError;

  /// A set of async subtasks that this is waiting on.
  final WaitableSet waitable = WaitableSet();

  final LinkedList<_MicrotaskEntry> _microtaskQueue = LinkedList();
  final Map<int, SubtaskImpl> _subtasks = {};
  final Map<int, FutureEventHandler> pendingFutureWrites = {};
  final Map<int, FutureEventHandler> pendingFutureReads = {};
  final Map<int, StreamSinkState<void>> writeStreams = {};

  var _isRunning = false;
  var _microtaskScheduled = false;

  new _(this._id, this._debugName) {
    _activeTasks[_id] = this;
  }

  int dispatchEvent(WasmI32 code, WasmI32 p1, WasmI32 p2) {
    // This is called outside of a task zone by a global event entrypoint.
    assert(Zone.current == Zone.root);
    return _rootZone.run(() => _dispatchEvent(code, p1, p2));
  }

  int _dispatchEvent(WasmI32 code, WasmI32 p1, WasmI32 p2) {
    assert(Zone.current == _rootZone);
    _isRunning = true;

    final parsedCode = EventCode.values[code.toIntUnsigned()];
    final index = p1.toIntUnsigned();
    switch (parsedCode) {
      case EventCode.none:
        // We'll just run the microtask queue.
        break;
      case EventCode.subtask:
        final state = SubtaskState.values[p2.toIntUnsigned()];
        _subtasks[index]!.dispatchEvent(state);
      case EventCode.streamRead:
        throw UnimplementedError();
      case EventCode.streamWrite:
        writeStreams[index]!.dispatchEvent(p2.toIntUnsigned());
      case EventCode.futureRead:
        final code = CopyResult.values[p2.toIntUnsigned()];
        pendingFutureReads[index]!(code);
      case EventCode.futureWrite:
        final code = CopyResult.values[p2.toIntUnsigned()];
        pendingFutureWrites[index]!(code);
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
    if (_unhandledError case (final error, final trace)?) {
      // This crashes the program, which is better than letting async errors go
      // unhandled.
      _unhandledError = null;
      Error.throwWithStackTrace(error, trace);
    }

    return CallbackCode.wait.packResult(waitable);
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
      handleUncaughtError: (self, parent, zone, error, stackTrace) {
        _unhandledError = (error, stackTrace);
      },
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
        final subtask = trackSubtask(wasiMonotonicWaitFor(inNanos));

        return OneShotTimer(subtask, zone.bindCallbackGuarded(f));
      },
      scheduleMicrotask: (self, parent, zone, f) {
        _microtaskQueue.add(_MicrotaskEntry(zone.bindCallbackGuarded(f)));

        if (!_isRunning && !_microtaskScheduled) {
          final (read, writable) = WritableFuture.create(
            FutureVtable.voidVtable,
            this,
          );
          _microtaskScheduled = true;

          // We don't have to await the future, completing it will trigger an
          // event loop iteration which then runs microtasks.
          unawaited(readFutureInternal(FutureVtable.voidVtable, read, this));

          // Immediately complete the future to wake up the task.
          unawaited(writable.writeValue(null));
        }
      },
    );
  }

  SubtaskImpl trackSubtask(WasmI32 createCode) {
    assert(_isRunning);
    final asInt = createCode.toIntUnsigned();
    final state = SubtaskState.values[asInt & 0x0f];
    final taskIndex = asInt >>> 4;

    switch (state) {
      case SubtaskState.starting:
      case SubtaskState.started:
        waitable.addWaitable(WasmI32.fromInt(taskIndex));
        final task = SubtaskImpl(taskIndex, this);
        _subtasks[taskIndex] = task;
        return task;
      case SubtaskState.returned:
      case SubtaskState.cancelledBeforeStarted:
      case SubtaskState.cancelledBeforeReturned:
        return .alreadyCompleted(state, this);
    }
  }

  void removeSubtask(int index) {
    _subtaskDrop(index.toWasmI32());
    _subtasks.remove(index);
  }

  static const _currentTaskKey = #_currentTask;

  static Task forCurrentThread() {
    final task = _activeTasks[_contextGet().toIntUnsigned()]!;
    assert(
      !task._isRunning,
      'Task.forCurrentThread should only be called in async entrypoints',
    );
    return task;
  }

  static Task forCurrentZone() {
    final task = Zone.current[_currentTaskKey] as Task;
    assert(task._isRunning);
    assert(() {
      task._verifyCurrent();
      return true;
    }());

    return task;
  }
}

/// Configures a new task.
///
/// This should only be called once from exported async component functions,
/// which is typically done by generated code.
int spawnTask({String? debugName, required void Function() run}) {
  final id = _nextTaskId++;
  final task = Task._(id, debugName);
  _contextSet(id.toWasmI32());

  task._isRunning = true;
  runZoned(
    () {
      task._rootZone = Zone.current;
      return run();
    },
    zoneSpecification: task._zoneSpecification,
    zoneValues: {Task._currentTaskKey: task},
  );
  return task._finishEventLoopIteration();
}

final class _MicrotaskEntry extends LinkedListEntry<_MicrotaskEntry> {
  final void Function() entry;

  _MicrotaskEntry(this.entry);
}
