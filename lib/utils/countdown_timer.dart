import 'dart:async';

import 'package:eocout_flutter/utils/store.dart';
import 'package:rxdart/rxdart.dart';

class CountdownTimer {
  final BehaviorSubject<int> timer = BehaviorSubject<int>.seeded(0);
  Timer? _countdownTimer;

  void startTimer(int duration) {
    Store.saveResendOTPTime();
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
    if (_countdownTimer != null) {
      _countdownTimer!.cancel();
      _countdownTimer = null;
    }
    Store.removeResendOTPTime();
  }
}
