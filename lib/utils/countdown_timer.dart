import 'dart:async';

import 'package:eocout_flutter/utils/store.dart';
import 'package:rxdart/rxdart.dart';

class CountdownTimer {
  final BehaviorSubject<int> timer = BehaviorSubject<int>.seeded(0);
  late Timer _countdownTimer;

  void startTimer(int duration) {
    Store.saveResendOTPTime(DateTime.now());
    timer.add(duration);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timer.value > 0) {
        timer.add(timer.value - 1);
      } else {
        cancelTimer();
      }
    });
  }

  void restartTimer() {
    cancelTimer();
    startTimer(60);
  }

  void cancelTimer() {
    _countdownTimer.cancel();
    Store.removeResendOTPTime();
  }
}
