import 'dart:async';

import 'package:artists_eye/src/challenges/models/record_history.dart';
import 'package:flutter/material.dart';

class RecordCarousel extends StatefulWidget {
  const RecordCarousel({
    required this.records,
    this.showDuration = const Duration(milliseconds: 2500),
    this.switchDuration = const Duration(milliseconds: 300),
    super.key,
  });

  final Duration switchDuration;
  final Duration showDuration;
  final List<RecordValue> records;

  @override
  State<RecordCarousel> createState() => _RecordCarouselState();
}

class _RecordCarouselState extends State<RecordCarousel> {
  int offset = 0;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(widget.showDuration, (_) {
      setState(() {
        offset++;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.switchDuration,
      reverseDuration: widget.switchDuration,
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeInQuint,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: Text(
        key: ValueKey(offset % widget.records.length),
        recordString(widget.records[offset % widget.records.length]),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  String recordString(RecordValue record) {
    final val = record.value;
    switch (record.kind) {
      case RecordKind.fastestTime:
        final secondsString =
            ((val as Duration).inMilliseconds / 1000).toStringAsFixed(2);
        return '$secondsString seconds';
      case RecordKind.highestAverageMatch:
        final matchString = ((val as double) * 100).round();
        return '$matchString% overall accuracy';
      case RecordKind.mostPerfect:
        return val == 1 ? '$val perfect match' : '$val perfect matches';
      case RecordKind.mostSuperb:
        return val == 1 ? '$val superb match' : '$val superb matches';
      case RecordKind.mostExcellent:
        return val == 1 ? '$val excellent match' : '$val excellent matches';
      case RecordKind.fewestMistakes:
        return val == 1 ? 'only $val mistake' : 'only $val mistakes';
    }
  }
}
