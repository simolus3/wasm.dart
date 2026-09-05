// ignore: import_internal_library
import 'dart:_wasm';

import 'dart:async';

import 'package:meta/meta.dart';

import 'task.dart';
import 'waitable.dart';

@internal
enum SubtaskState {
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
abstract final class Subtask {
  /// A future that completes once the subtask has returned a value.
  ///
  /// Throws a [SubtaskCancelledException] if the subtask was cancelled before
  /// returning.
  Future<void> get completion;

  /// Requests the subtask to be cancelled.
  ///
  /// Due to limitations in the component model, this currently blocks the
  /// Dart thread until the subtask returns or affirms the cancellation. This
  /// will be fixed once the `async` option on `subtask.cancel` is stable.
  void cancel();
}

@pragma('wasm:import', 'component.canon.subtask.cancel')
external WasmI32 _subtaskCancel(WasmI32 task);

@internal
final class SubtaskImpl extends Subtask {
  final int _index;
  SubtaskState _state = .starting;

  final Completer<void>? _completer;
  final Task _task;
  var _cancellationRequested = false;

  SubtaskImpl(this._index, this._task)
    : assert(_index > 0),
      _completer = Completer();

  SubtaskImpl.alreadyCompleted(this._state, this._task)
    : _index = 0,
      _completer = null;

  void dispatchEvent(SubtaskState state) {
    _state = state;

    switch (state) {
      case SubtaskState.starting:
      case SubtaskState.started:
        return;
      case SubtaskState.returned:
        _removeSelf();
        _completer?.complete();
      case SubtaskState.cancelledBeforeStarted:
        _removeCancelled(const SubtaskCancelledException._(true));
      case SubtaskState.cancelledBeforeReturned:
        _removeCancelled(const SubtaskCancelledException._(false));
    }
  }

  void _removeSelf() {
    _task.removeSubtask(_index);
  }

  void _removeCancelled(SubtaskCancelledException e) {
    _removeSelf();
    _completer?.completeError(e);
  }

  @override
  Future<void> get completion {
    if (_completer case final completer?) return completer.future;

    assert(_state == .returned, 'Must be immediately-returned subtask');
    return Future.syncValue(null);
  }

  @override
  void cancel() {
    if (_cancellationRequested || _index == 0 || _completer!.isCompleted) {
      return;
    }
    _cancellationRequested = true;

    final indexI32 = WasmI32.fromInt(_index);

    // We can't cancel subtasks that are currently in a waitable set, so we have
    // to temporarily remove the task from the waitable set.
    waitableJoin(indexI32, const WasmI32(0));

    final newState = _subtaskCancel(indexI32).toIntUnsigned();
    if (newState == blockedCode) {
      // Wait on the task (again), so we'll be notified when it completes or
      // acknowledges the cancellation request.
      _task.waitable.addWaitable(indexI32);
    } else {
      dispatchEvent(SubtaskState.values[newState]);
    }
  }
}

/// An exception thrown from [Subtask.completion] when the subtask was cancelled
/// and has acknowledged its cancellation.
final class SubtaskCancelledException implements Exception {
  final bool beforeStarted;

  const SubtaskCancelledException._(this.beforeStarted);

  @override
  String toString() {
    return beforeStarted
        ? 'Subtask cancelled before starting'
        : 'Subtask cancelled';
  }
}

/// Creates a subtask from a return code of an async import.
///
/// This function is only meant to be called by witgen-generated code.
Subtask createSubtask(WasmI32 subtaskReturnCode) {
  return Task.forCurrentZone().trackSubtask(subtaskReturnCode);
}
