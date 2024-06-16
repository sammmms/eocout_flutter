import 'package:eocout_flutter/utils/countdown_timer.dart';
import 'package:flutter/material.dart';

class DurationCountdown extends StatefulWidget {
  final CountdownTimer timer;
  final Widget Function(BuildContext context, int duration) builder;
  const DurationCountdown(
      {super.key, required this.timer, required this.builder});

  @override
  State<DurationCountdown> createState() => _DurationCountdownState();
}

class _DurationCountdownState extends State<DurationCountdown> {
  @override
  void initState() {
    widget.timer.startTimer(30);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.timer.timer,
        builder: (context, snapshot) {
          return widget.builder(context, snapshot.data ?? 0);
        });
  }
}
