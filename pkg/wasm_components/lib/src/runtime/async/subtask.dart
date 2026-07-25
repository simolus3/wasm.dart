// ignore: import_internal_library
import 'dart:_wasm';

import 'dart:async';

import 'package:meta/meta.dart';

import 'task.dart';

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
  void cancel();
}

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
      case SubtaskState.cancelledBeforeReturned:
        _removeSelf();
        _completer?.completeError(const SubtaskCancelledException._());
    }
  }

  void _removeSelf() {
    _task.removeSubtask(_index);
  }

  @override
  Future<void> get completion {
    if (_completer case final completer?) return completer.future;

    assert(_state == .returned, 'Must be immediately-returned subtask');
    return Future.value();
  }

  @override
  void cancel() {
    if (_cancellationRequested || _index == 0) return;
    // TODO: Because we add subtasks to the waitable set immediately after
    // creating them, cancelling requires the "🚝: enabling more canonical ABI
    // options on more async-related builtins" feature to make
    // subtask.cancel async. Until that is stabilized, we can't cancel subtasks.
    // After adding that, also fix timers to cancel properly.

    //    const blockedCode = 0xffff_ffff;

    _cancellationRequested = true;
    // final newState = _subtaskCancel(_index.toWasmI32()).toIntUnsigned();
    // if (newState == blockedCode) {
    //   // We're already waiting on the task, we'll be notified asynchronously
    //   // about state updates.
    // } else {
    //   _dispatchEvent(_SubtaskState.values[newState]);
    // }
  }
}

/// An exception thrown from [Subtask.completion] when the subtask was cancelled
/// and has acknowledged its cancellation.
final class SubtaskCancelledException implements Exception {
  const SubtaskCancelledException._();

  @override
  String toString() {
    return 'Subtask cancelled';
  }
}

/// Creates a subtask from a return code of an async import.
///
/// This function is only meant to be called by witgen-generated code.
Subtask createSubtask(WasmI32 subtaskReturnCode) {
  return Task.forCurrentZone().trackSubtask(subtaskReturnCode);
}
