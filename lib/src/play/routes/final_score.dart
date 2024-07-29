import 'dart:math';
import 'dart:ui';
import 'package:artists_eye/src/util/widgets/changing_color.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector4;

import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:flutter/material.dart' hide Matrix4;

class FinalScore extends StatelessWidget {
  const FinalScore({
    required this.correct,
    super.key,
  });

  final int correct;

  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      background: ChangingColors(
        duration: const Duration(seconds: 16),
        builder: (context, colorLeft, colorRight, child) {
          return MovingBackground(
            colorLeft: colorLeft,
            colorRight: colorRight,
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (correct >= 20)
              Text('You win!',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white))
            else
              Text('Try again!',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Colors.white)),
            Text('You got $correct correct!',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
      body: const SizedBox(),
    );
  }
}

class MovingBackground extends StatefulWidget {
  const MovingBackground({
    required this.colorLeft,
    required this.colorRight,
    this.child,
    super.key,
  });

  final Widget? child;
  final Color colorLeft;
  final Color colorRight;

  @override
  State<MovingBackground> createState() => _MovingBackgroundState();
}

class _MovingBackgroundState extends State<MovingBackground>
    with SingleTickerProviderStateMixin {
  final MovingBackgroundParts movingParts = MovingBackgroundParts(Random());
  late final Ticker ticker;
  late DateTime lastTick;

  @override
  void initState() {
    super.initState();
    ticker = createTicker(onTick)..start();
    lastTick = DateTime.now();
  }

  void onTick(Duration elapsed) {
    final now = DateTime.now();
    final elapsed = now.difference(lastTick);
    lastTick = now;
    movingParts.tick(elapsed);
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MovingBackgroundPainter(
        colorLeft: widget.colorLeft,
        colorRight: widget.colorRight,
        movingParts: movingParts,
      ),
      child: SizedBox.expand(child: widget.child),
    );
  }
}

class MovingBackgroundParts extends ChangeNotifier {
  MovingBackgroundParts(Random random)
      : parts = [
          Circle(
            radius: 5 / 6,
            distance: 0,
            axis: 0,
            axisVelocity: 0,
            distanceVelocity: 0,
          ),
          ...generateSkewedRects(random, 9),
          ...generateCircles(random, 5)
        ];

  static double randomAxisVelocity(Random random) =>
      lerpDouble(4, 6, random.nextDouble())! * (random.nextBool() ? 1 : -1);

  static double randomRotationVelocity(Random random) =>
      lerpDouble(8, 10, random.nextDouble())! * (random.nextBool() ? 1 : -1);

  static double randomSkew(Random random) =>
      lerpDouble(0.1, 0.4, random.nextDouble())! * (random.nextBool() ? 1 : -1);

  static List<SkewedRect> generateSkewedRects(Random random, int count) =>
      <SkewedRect>[
        for (int i = 0; i < count; ++i)
          SkewedRect(
            //axis: random.nextDouble() * 2 * pi / 4 + 2 * pi / i,
            axis: i * 2 * pi / count,
            axisVelocity: randomAxisVelocity(random),
            distance: random.nextDouble() * 2 * pi,
            distanceVelocity: lerpDouble(3, 5, random.nextDouble())!,
            rect: Size(lerpDouble(0.2, 0.8, random.nextDouble())!,
                lerpDouble(0.2, 0.35, random.nextDouble())!),
            skew: randomSkew(random),
            rotation: random.nextDouble(),
            rotationVelocity: randomRotationVelocity(random),
          )
      ];

  static List<Circle> generateCircles(Random random, int count) => <Circle>[
        for (int i = 0; i < count; ++i)
          Circle(
            axis: random.nextDouble() * 2 * pi,
            axisVelocity: randomAxisVelocity(random),
            distance: random.nextDouble() * 2 * pi,
            distanceVelocity: lerpDouble(3, 5, random.nextDouble())!,
            radius: lerpDouble(0.1, 0.45, random.nextDouble())!,
          )
      ];

  final List<Drifting> parts;

  void tick(Duration duration) {
    for (final part in parts) {
      part.drift(duration);
    }
    notifyListeners();
  }
}

class Drifting {
  Drifting({
    required this.axis,
    required this.axisVelocity,
    required this.distance,
    required this.distanceVelocity,
  });

  double axis;
  double axisVelocity;
  double distance;
  double distanceVelocity;

  void drift(Duration duration) {
    axis += axisVelocity * duration.inMicroseconds / 100000000;
    axis = axis % (2 * pi);
    distance += distanceVelocity * duration.inMicroseconds / 100000000;
    distance = distance % (2 * pi);
  }
}

class Circle extends Drifting {
  Circle({
    required this.radius,
    required super.axis,
    required super.axisVelocity,
    required super.distance,
    required super.distanceVelocity,
  });

  final double radius;
}

class SkewedRect extends Drifting {
  SkewedRect({
    required this.rect,
    required super.axis,
    required super.axisVelocity,
    required super.distance,
    required super.distanceVelocity,
    this.skew = 0.0,
    this.rotation = 0.0,
    this.rotationVelocity = 0.0,
  });

  final Size rect;
  final double skew;
  double rotation;
  final double rotationVelocity;

  @override
  void drift(Duration duration) {
    super.drift(duration);
    rotation += rotationVelocity * duration.inMicroseconds / 100000000;
  }
}

class MovingBackgroundPainter extends CustomPainter {
  MovingBackgroundPainter({
    required this.colorLeft,
    required this.colorRight,
    required this.movingParts,
  }) : super(repaint: movingParts);

  final Color colorLeft;
  final Color colorRight;
  final MovingBackgroundParts movingParts;

  @override
  void paint(Canvas canvas, Size size) {
    final darkGradient = Paint()
      ..shader = LinearGradient(
        colors: [
          colorLeft,
          colorRight,
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(const Offset(0, 0) & size);

    final lightGradient = Paint()
      ..shader = LinearGradient(
        colors: [
          colorLeft.withOpacity(0.6),
          colorRight.withOpacity(0.6),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(const Offset(0, 0) & size);

    canvas.drawRect(const Offset(0, 0) & size, Paint()..color = Colors.white);
    canvas.drawRect(const Offset(0, 0) & size, lightGradient);

    final partsPath = movingParts.parts
        .map(driftingToPath)
        .reduce((a, b) => Path.combine(PathOperation.union, a, b))
        .transform((Matrix4.identity()
              ..translate(size.width / 2, size.height / 2, 0.0)
              ..scale(size.width / 2, size.width / 2, 1.0))
            .storage);

    canvas.drawPath(
        partsPath.shift(const Offset(0, 4)),
        Paint()
          ..color = Colors.grey[800]!.withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7));
    canvas.drawPath(partsPath, darkGradient);
  }

  Path driftingToPath(Drifting drifting) {
    if (drifting is SkewedRect) {
      return rectToPath(drifting);
    } else if (drifting is Circle) {
      return circleToPath(drifting);
    } else {
      throw UnimplementedError();
    }
  }

  Path circleToPath(Circle circle) {
    final centerTransform = Matrix4.identity()..rotateZ(circle.axis);
    final centerVec =
        centerTransform.transformed(Vector4(sin(circle.distance), 0, 0, 0));
    final center = Offset(centerVec[0], centerVec[1] * 1.9);

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: circle.radius));
  }

  Path rectToPath(SkewedRect rect) {
    final size = rect.rect;

    final halfSkew = rect.skew * size.height;
    final halfHeight = size.height / 2;
    final halfWidth = size.width / 2;

    final centerTransform = Matrix4.identity()..rotateZ(rect.axis);
    final centerVec = centerTransform
        .transformed(Vector4(0.75 + sin(rect.distance) * 0.25, 0, 0, 0));
    final center = Offset(centerVec[0], centerVec[1] * 1.9);

    final topLeft = Offset(-halfWidth - halfSkew, -halfHeight);
    final topRight = Offset(halfWidth - halfSkew, -halfHeight);
    final bottomLeft = Offset(-halfWidth + halfSkew, halfHeight);
    final bottomRight = Offset(halfWidth + halfSkew, halfHeight);

    return (Path()
          ..moveTo(topLeft.dx, topLeft.dy)
          ..lineTo(topRight.dx, topRight.dy)
          ..lineTo(bottomRight.dx, bottomRight.dy)
          ..lineTo(bottomLeft.dx, bottomLeft.dy)
          ..close())
        .transform(Matrix4.rotationZ(rect.rotation - rect.axis).storage)
        .shift(center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
