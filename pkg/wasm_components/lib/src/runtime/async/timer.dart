@internal
library;

// ignore: import_internal_library
import 'dart:_wasm';
import 'dart:async';

import 'package:meta/meta.dart';

import '../../embedder/clock.dart';
import 'subtask.dart';
import 'task.dart';

final class WasmTimer implements Timer {
  final Task _task;
  final Duration _duration;

  /// The callback, which should be bound to the zone creating this timer.
  final void Function() _callback;
  final bool _isPeriodic;

  Subtask? _currentWait;

  @override
  var isActive = true;

  @override
  var tick = 0;

  new({
    required this._task,
    required this._duration,
    required this._callback,
    required this._isPeriodic,
  }) {
    _schedule();
  }

  void _schedule() {
    assert(_currentWait == null && isActive);
    final inNanos = (_duration.inMicroseconds * 1000).toWasmI64();
    final task = _currentWait = _task.trackSubtask(
      wasiMonotonicWaitFor(inNanos),
    );

    task.completion.onError<SubtaskCancelledException>((_, _) {}).whenComplete(
      () {
        if (isActive) {
          if (!_isPeriodic) isActive = false;

          tick++;
          _callback();

          if (_isPeriodic && isActive) {
            _schedule();
          }
        }
      },
    );
  }

  @override
  void cancel() {
    isActive = false;
    _currentWait?.cancel();
    _currentWait = null;
  }
}
