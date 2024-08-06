import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Timer extends StatefulWidget {
  const Timer({
    this.buffer = Duration.zero,
    this.running = true,
    super.key,
  });

  final bool running;
  final Duration buffer;

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  late DateTime start;
  late Ticker ticker;

  @override
  void initState() {
    super.initState();
    start = DateTime.now();

    ticker = createTicker(onTick);

    ticker.start();
  }

  @override
  void didUpdateWidget(Timer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.running == ticker.isActive) {
      return;
    }

    if (!widget.running) {
      ticker.stop();
    } else {
      ticker.start();
    }
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void onTick(Duration _) {
    setState(() {});
  }

  String getTimeText() {
    final now = DateTime.now();
    final elapsed = now.difference(start);

    return elapsed.inSeconds.abs().toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getTimeText(),
      style: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(color: Colors.white),
    );
  }
}
