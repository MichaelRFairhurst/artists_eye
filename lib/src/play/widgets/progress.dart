import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  const Progress({
    required this.completed,
    required this.total,
    this.incompleteColor = const Color(0xFFE8E8E8),
    this.radius = 10,
    this.barHeight = 6,
    super.key,
  });

  final List<Color> completed;
  final int total;
  final Color incompleteColor;
  final double radius;
  final double barHeight;

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  Iterable<Color> get colors => widget.completed.followedBy(
        Iterable.generate(widget.total - widget.completed.length,
            (_) => widget.incompleteColor),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: widget.radius - widget.barHeight / 2,
          left: widget.radius,
          right: widget.radius,
          height: widget.barHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors.toList(),
              ),
            ),
            child: SizedBox(
              height: widget.barHeight,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < widget.total; ++i)
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.radius),
                  color: i < widget.completed.length
                      ? widget.completed[i]
                      : widget.incompleteColor,
                ),
                child: SizedBox(
                  width: widget.radius * 2,
                  height: widget.radius * 2,
                  child: i >= widget.completed.length
                      ? null
                      : Icon(
                          Icons.check,
                          size: widget.radius * 1.5,
                          color: Colors.white,
                        ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
