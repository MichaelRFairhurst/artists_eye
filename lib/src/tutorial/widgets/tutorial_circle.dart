import 'package:flutter/material.dart';

class TutorialCircle extends StatelessWidget {
  const TutorialCircle(
    this.color, {
    this.isHero = false,
    this.text = '',
    super.key,
  });

  final Color color;
  final bool isHero;
  final String text;

  static const size = 52.0;

  @override
  Widget build(BuildContext context) {
    final circle = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: color,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: getTextWidget(context),
      ),
    );

    if (isHero) {
      return Hero(
        tag: color,
        child: circle,
      );
    } else {
      return circle;
    }
  }

  Widget? getTextWidget(BuildContext context) {
    if (text == '') {
      return null;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
