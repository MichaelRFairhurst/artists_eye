import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:flutter/material.dart';

class PickColorButton extends StatelessWidget {
  const PickColorButton({
    required this.color,
    required this.onConfirm,
    this.size = 64,
    this.borderRadius = 24,
    this.rotation = 0,
    super.key,
  });

  final Color color;
  final void Function() onConfirm;
  final double size;
  final double borderRadius;
  final double rotation;

  static const shadowTransform = AddHSL(
    deltaHue: 120,
    deltaSaturation: 0.2,
    deltaLightness: 0.25,
  );

  @override
  Widget build(BuildContext context) {
    final shadowColor = shadowTransform.perform(color);
    return Hero(
      tag: 'picked',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              color: shadowColor.withOpacity(0.75),
            ),
          ],
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: IconButton(
            icon: const Icon(Icons.check_rounded),
            color: shadowColor,
            onPressed: onConfirm,
          ),
        ),
      ),
    );
  }
}
