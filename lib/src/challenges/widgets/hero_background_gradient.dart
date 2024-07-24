import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:flutter/material.dart';

class HeroBackgroundGradient extends StatelessWidget {
  final String tag;
  final double borderRadius;
  final Color colorLeft;
  final Color colorRight;
  final ColorEffect rightColorEffect;

  const HeroBackgroundGradient({
    required this.tag,
    required this.borderRadius,
    required this.colorLeft,
    required this.colorRight,
    required this.rightColorEffect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (context, anim, direction, _, __) {
        return AnimatedBuilder(
          animation: anim,
          builder: (context, _) {
            return buildWithProgress(anim.value);
          },
        );
      },
      child: buildWithProgress(0.0),
    );
  }

  Widget buildWithProgress(double progress) {
    final blendedCorner = Radius.circular(42 * (1 - progress));
    const unchangingCorner = Radius.circular(42);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: blendedCorner,
          topRight: unchangingCorner,
          bottomRight: blendedCorner,
          bottomLeft: blendedCorner,
        ),
        gradient: LinearGradient(
          colors: [colorLeft, rightColorEffect.perform(colorRight)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            offset: const Offset(0, 0),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
