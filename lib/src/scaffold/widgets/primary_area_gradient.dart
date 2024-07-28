import 'package:flutter/material.dart';

const defaultPrimaryAreaGradientRadius = 32.0;

class PrimaryAreaGradient extends StatelessWidget {
  const PrimaryAreaGradient({
    required this.heroTag,
    required this.colorLeft,
    required this.colorRight,
    this.radius = defaultPrimaryAreaGradientRadius,
    super.key,
  });

  final String heroTag;
  final Color colorLeft;
  final Color colorRight;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (context, animation, _, __, ___) {
        return PrimaryAreaGradientBase(
          colorLeft: colorLeft,
          colorRight: colorRight,
          radius: radius,
          animation: animation,
        );
      },
      child: PrimaryAreaGradientBase(
        colorLeft: colorLeft,
        colorRight: colorRight,
        radius: radius,
      ),
    );
  }
}

class PrimaryAreaGradientBase extends StatelessWidget {
  const PrimaryAreaGradientBase({
    required this.colorLeft,
    required this.colorRight,
    required this.radius,
    this.animation,
	this.child,
    super.key,
  });

  final Animation<double>? animation;
  final Color colorLeft;
  final Color colorRight;
  final double radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PrimaryAreaGradientClipper(radius: radius, animation: animation),
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
        ),
		child: child,
      ),
    );
  }
}

class PrimaryAreaGradientClipper extends CustomClipper<Path> {
  PrimaryAreaGradientClipper({
    required this.radius,
    this.animation,
  }) : super(reclip: animation);

  final Animation<double>? animation;
  final double radius;

  @override
  Path getClip(Size size) {
    final v = animation?.value ?? 1.0;
    final radiusOutTween = Tween<double>(begin: radius, end: 0);
    final radiusOut = radiusOutTween.transform(v);
    final radiusInTween = Tween<double>(begin: 0, end: radius);
    final radiusIn = radiusInTween.transform(v);

    final baseRect = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Offset(0, radiusIn) & Size(size.width, size.height - radiusIn),
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radiusOut),
        bottomLeft: Radius.circular(radiusOut),
        topLeft: Radius.circular(radiusOutTween.transform((v * 2).clamp(0, 1))),
      ));

    final topLeft = Path()
      ..addRect(
          Offset(0, radiusOut) & Size(radiusIn, size.height - radius * 2));

    final inverseRadius = radiusInTween.transform((v * 2 - 1).clamp(0, 1));
    final inverseCorner = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Offset(0, -radiusIn) & Size(size.width, radiusIn * 2),
        bottomLeft: Radius.circular(inverseRadius),
      ));

    return Path.combine(
      PathOperation.difference,
      Path.combine(
        PathOperation.union,
        baseRect,
        topLeft,
      ),
      inverseCorner,
    );
  }

  @override
  bool shouldReclip(covariant PrimaryAreaGradientClipper oldClipper) =>
      radius != oldClipper.radius;
}
