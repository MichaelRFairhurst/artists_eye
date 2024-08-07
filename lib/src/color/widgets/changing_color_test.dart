import 'dart:math';

import 'package:artists_eye/src/play/models/color_test.dart';
import 'package:flutter/material.dart';

class ChangingColorTest extends StatefulWidget {
  const ChangingColorTest({
    required this.builder,
    required this.makeColorTest,
    Duration? duration,
    this.child,
    super.key,
  }) : duration = duration ?? const Duration(seconds: 8);

  final ColorTest Function() makeColorTest;
  final Duration duration;
  final Widget? child;

  final Widget Function(BuildContext, ColorTest, Widget?) builder;

  @override
  State<ChangingColorTest> createState() => _ChangingColorState();
}

class ColorTestTween extends Tween<ColorTest> {
  ColorTestTween({
    required super.begin,
    required super.end,
  });

  @override
  ColorTest lerp(double t) {
    return ColorTest(
      colorLeft: Color.lerp(begin!.colorLeft, end!.colorLeft, t)!,
      colorRight: Color.lerp(begin!.colorRight, end!.colorRight, t)!,
      hintColor: Color.lerp(begin!.hintColor, end!.hintColor, t)!,
      toFind: Color.lerp(begin!.toFind, end!.toFind, t)!,
    );
  }
}

class _ChangingColorState extends State<ChangingColorTest>
    with SingleTickerProviderStateMixin {
  late Animation<ColorTest> animation;
  late AnimationController controller;
  late ColorTestTween tween;
  final random = Random();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final startTest = widget.makeColorTest();
    tween = ColorTestTween(begin: startTest, end: startTest);
    animation = tween.animate(controller);
    _changeColors();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _changeColors() {
    tween.begin = tween.end;
    tween.end = widget.makeColorTest();

    controller.reset();
    controller.forward().then((_) {
      _changeColors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return widget.builder(
          context,
          animation.value,
          child,
        );
      },
      child: widget.child,
    );
  }
}
