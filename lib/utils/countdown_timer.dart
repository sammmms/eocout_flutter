import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CountdownTimer {
  final BehaviorSubject<int> timer = BehaviorSubject<int>.seeded(0);
  late Timer _countdownTimer;

  void startTimer(int duration) {
    timer.add(duration);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timer.value > 0) {
        timer.add(timer.value - 1);
      } else {
        _countdownTimer.cancel();
      }
    });
  }

  void cancelTimer() {
    _countdownTimer.cancel();
  }
}
