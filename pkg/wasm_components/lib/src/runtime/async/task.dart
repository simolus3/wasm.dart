import 'dart:async';
// ignore: import_internal_library
import 'dart:_wasm';
import 'dart:collection';

import 'package:meta/meta.dart';

import 'callback.dart';
import 'future.dart';
import 'waitable.dart';

@pragma('wasm:import', 'component.canon.context.set_i32_0')
external WasmVoid _contextSet(WasmI32 context);

@pragma('wasm:import', 'component.canon.context.get_i32_0')
external WasmI32 _contextGet();

@pragma('wasm:import', 'component.canon.future.void.new')
external WasmI64 _voidFutureNew();

@pragma('wasm:import', 'component.canon.future.void.write')
external WasmI32 _voidFutureWrite(WasmI32 future);

var _nextTaskId = 0;
final Map<int, Task> _activeTasks = {};

final class Task {
  final int _id;
  final String? _debugName;

  /// A set of async subtasks that this is waiting on.
  final WaitableSet _waitable = WaitableSet();

  final LinkedList<_MicrotaskEntry> _microtaskQueue = LinkedList();

  var _isRunning = false;
  RawFutureReadableEnd? _scheduleForMicrotask;

  new _(this._id, this._debugName);

  void _dispatchEvent(WasmI32 code, WasmI32 p1, WasmI32 p2) {
    _isRunning = true;

    final parsedCode = EventCode.values[code.toIntUnsigned()];
    switch (parsedCode) {
      case EventCode.none:
        // We'll just run the microtask queue.
        return;
      case EventCode.subtask:
        throw UnimplementedError();
      case EventCode.streamRead:
        throw UnimplementedError();
      case EventCode.streamWrite:
        throw UnimplementedError();
      case EventCode.futureRead:
        throw UnimplementedError();
      case EventCode.futureWrite:
        throw UnimplementedError();
      case EventCode.taskCancelled:
        // We don't currently support cancellations, in the future we might want
        // to notify listeners.
        return;
    }
  }

  /// Runs pending microtasks before yielding to the component embedder.
  int finishEventLoopIteration() {
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
      scheduleMicrotask: (self, parent, zone, f) {
        _microtaskQueue.add(_MicrotaskEntry(zone.bindCallbackGuarded(f)));

        if (!_isRunning && _scheduleForMicrotask == null) {
          final (read, write) = extractFutureHandlesFromPackedCode(
            _voidFutureNew().toInt(),
          );
          _scheduleForMicrotask = read;
          _waitable.addWaitable(read.handle.toWasmI32());

          // Immediately complete the future to wake up the task.
          _voidFutureWrite(write.handle.toWasmI32());
        }
      },
    );
  }

  /// Configures a new task.
  ///
  /// This should only be called once from exported async component functions,
  /// which is typically done by generated code.
  @internal
  static Task spawn({String? debugName, required void Function() run}) {
    final id = _nextTaskId++;
    final task = Task._(id, debugName);
    _contextSet(id.toWasmI32());

    task._isRunning = true;
    runZoned(
      run,
      zoneSpecification: task._zoneSpecification,
      zoneValues: {_currentTaskKey: task},
    );
    return task;
  }

  static const _currentTaskKey = #_currentTask;
}

@internal
Task taskForCurrentThread() {
  return _activeTasks[_contextGet().toIntUnsigned()]!;
}

@internal
void dispatchEvent(Task t, WasmI32 code, WasmI32 p1, WasmI32 p2) {
  t._dispatchEvent(code, p1, p2);
}

final class _MicrotaskEntry extends LinkedListEntry<_MicrotaskEntry> {
  final void Function() entry;

  _MicrotaskEntry(this.entry);
}
