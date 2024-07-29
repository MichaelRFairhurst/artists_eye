import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Timer extends StatefulWidget {
  const Timer({
    required this.duration,
	required this.onDone,
    this.buffer = Duration.zero,
    super.key,
  });

  final void Function() onDone;
  final Duration duration;
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
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void onTick(Duration _) {
	setState(() {});

    if (start.add(widget.buffer + widget.duration).isBefore(DateTime.now())) {
	  ticker.stop();
	  widget.onDone();
	}
  }

  String getTimeText() {
    final now = DateTime.now();
    final elapsed = now.difference(start);
    final left = widget.duration + widget.buffer - elapsed;

    if (left > widget.duration) {
      return '';
    }

    if (left.isNegative) {
      return "TIME'S UP!";
    }

    return left.inSeconds.abs().toString().padLeft(2, '0');
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
