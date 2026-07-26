import 'dart:async';

import 'subtask.dart';

final class OneShotTimer implements Timer {
  @override
  var isActive = true;
  @override
  var tick = 0;

  OneShotTimer(Subtask wait, void Function() run) {
    wait.completion.then((_) {
      if (isActive) {
        isActive = false;
        tick++;
        run();
      }
    });
  }

  @override
  void cancel() {
    isActive = false;
    // Ideally we should cancel the wait subtask too, but that is not currently
    // possible (see Subtask.cancel for details).
  }
}
