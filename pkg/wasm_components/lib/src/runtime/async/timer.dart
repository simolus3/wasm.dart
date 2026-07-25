import 'dart:async';

import 'task.dart';

final class OneShotTimer implements Timer {
  Subtask? _monotonicClockWait;

  @override
  var isActive = true;

  OneShotTimer(Subtask wait, void Function() run) : _monotonicClockWait = wait {
    wait.completion.then((_) => run());
  }

  @override
  void cancel() {
    // TODO: implement cancel
  }

  @override
  int get tick => _monotonicClockWait == null ? 0 : 1;
}
