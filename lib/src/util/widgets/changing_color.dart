import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ChangingColors extends StatelessWidget {
  final Widget Function(BuildContext, Color a, Color b, Widget? child) builder;
  final Widget? child;

  const ChangingColors({
    required this.builder,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangingColor(
      builder: (context, firstColor) {
        return ChangingColor(
          builder: (context, secondColor) {
            return AnimatedBuilder(
              animation: Listenable.merge([firstColor, secondColor]),
              builder: (context, _) {
                return builder(
                    context, firstColor.value!, secondColor.value!, child);
              },
            );
          },
        );
      },
    );
  }
}

class ChangingColor extends StatefulWidget {
  const ChangingColor({
    required this.builder,
    super.key,
  });

  ChangingColor.valueBuilder(
      {required Widget Function(BuildContext, Color value, Widget? child)
          builder,
      Widget? child,
      Key? key})
      : this(
          builder: (context, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return builder(context, animation.value!, child);
              },
              child: child,
            );
          },
          key: key,
        );

  final Widget Function(BuildContext, Animation<Color?>) builder;

  @override
  State<ChangingColor> createState() => _ChangingColorState();
}

class _ChangingColorState extends State<ChangingColor>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;
  late ColorTween tween;
  final random = Random();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    final startColor = randomColor();
    tween = ColorTween(begin: startColor, end: startColor);
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
    tween.end = randomColor();

    controller.reset();
    controller.forward().then((_) {
      _changeColors();
    });
  }

  Color randomColor() {
    return HSLColor.fromAHSL(
      1.0,
      random.nextDouble() * 360,
      lerpDouble(0.7, 0.5, random.nextDouble())!,
      lerpDouble(0.9, 0.45, random.nextDouble())!,
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, animation);
  }
}
