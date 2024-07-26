import 'package:artists_eye/src/scaffold/widgets/primary_area_gradient.dart';
import 'package:flutter/material.dart';

class GradientToPrimaryArea extends StatelessWidget {
  const GradientToPrimaryArea({
    required this.colorLeft,
    required this.colorRight,
    required this.heroTag,
    this.radius = defaultPrimaryAreaGradientRadius,
    this.onTap,
    this.child,
    super.key,
  });

  final String heroTag;
  final Color colorLeft;
  final Color colorRight;
  final double radius;
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: heroTag,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorLeft,
                        colorRight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
