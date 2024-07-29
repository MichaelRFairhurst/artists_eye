import 'dart:math';
import 'dart:ui';
import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/challenges/models/record_history.dart';
import 'package:artists_eye/src/play/models/score.dart';
import 'package:artists_eye/src/play/routes/play.dart';
import 'package:artists_eye/src/play/widgets/record_carousel.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:artists_eye/src/util/widgets/changing_color.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector4;

import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:flutter/material.dart' hide Matrix4;

class FinalScore extends StatelessWidget {
  const FinalScore({
    required this.score,
    required this.challenge,
    required this.records,
    super.key,
  });

  final Challenge challenge;
  final Score score;
  final List<RecordValue> records;

  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      titleColor: Colors.white,
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
            if (challenge.isWin(score))
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
            const SizedBox(height: 16),
            Text('${score.correct} correct, ${score.incorrect} mistakes',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            if (score.perfect > 0) ...[
              Text('${score.perfect} perfect matches!',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white)),
              const SizedBox(height: 12),
            ],
            if (score.excellent > 0) ...[
              Text('${score.excellent} excellent matches!',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white)),
              const SizedBox(height: 12),
            ],
            Text('${(score.averageMatch * 100).round()}% overall accuracy',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 36),
        child: Column(
          children: [
            if (records.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: SkewedBoxBackground(
                      color: Colors.white.withOpacity(0.6),
                      skew: 18,
                      blur: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              records.length == 1
                                  ? 'New record!'
                                  : '${records.length} new records!',
                              style: Theme.of(context).textTheme.displayMedium),
                          RecordCarousel(
                            records: records,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 120.0, end: 0.0),
                duration: const Duration(seconds: 3),
                curve: Curves.easeInOutQuart,
                builder: (context, value, child) {
                  return Transform.translate(
				    offset: Offset(value, 0),
					child: child,
				  );
                },
				child: ThumbWidget(
                    color: Colors.grey[200]!,
                    text: 'Play again',
                    height: 110,
                    width: 120,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Play(
                            challenge: challenge,
                          ),
                        ),
                      );
                    },
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkewedBoxBackground extends StatelessWidget {
  const SkewedBoxBackground({
    required this.skew,
    required this.blur,
    required this.color,
    required this.child,
    super.key,
  });

  final Widget child;
  final double skew;
  final double blur;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SkewedBoxBackgroundPainter(
        blur: blur,
        skew: skew,
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: skew),
        child: child,
      ),
    );
  }
}

class SkewedBoxBackgroundPainter extends CustomPainter {
  const SkewedBoxBackgroundPainter({
    required this.skew,
    required this.blur,
    required this.color,
  });

  final double skew;
  final double blur;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(skew, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - skew, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur));
  }

  @override
  bool shouldRepaint(SkewedBoxBackgroundPainter oldDelegate) =>
      skew != oldDelegate.skew ||
      color != oldDelegate.color ||
      blur != oldDelegate.blur;
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
          ...generateSkewedRects(random, 7),
          ...generateCircles(random, 4)
        ];

  static double randomRotationVelocity(Random random) =>
      lerpDouble(8, 10, random.nextDouble())! * (random.nextBool() ? 1 : -1);

  static double randomSkew(Random random) =>
      lerpDouble(0.05, 0.35, random.nextDouble())! *
      (random.nextBool() ? 1 : -1);

  static List<SkewedRect> generateSkewedRects(Random random, int count) =>
      <SkewedRect>[
        for (int i = 0; i < count; ++i)
          SkewedRect(
            axis: i * 2 * pi / count,
            axisVelocity: i % 2 == 0 ? -5 : 5,
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
            axisVelocity: i % 2 == 0 ? -3 : 3,
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
    final lightGradient = createGradient(size, 0.6);
    final darkGradient = createGradient(size, 1.0);

    canvas.drawRect(const Offset(0, 0) & size, lightGradient);

    final shape = getShape(size);

    canvas.drawPath(
        shape.shift(const Offset(0, 4)),
        Paint()
          ..color = Colors.grey[900]!.withOpacity(0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
    canvas.drawPath(shape, darkGradient);
  }

  Paint createGradient(Size size, double opacity) {
    return Paint()
      ..shader = LinearGradient(
        colors: [
          colorLeft.withOpacity(opacity),
          colorRight.withOpacity(opacity),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(const Offset(0, 0) & size);
  }

  Path getShape(Size size) {
    final partsPath = movingParts.parts
        .map(driftingToPath)
        .reduce((a, b) => Path.combine(PathOperation.union, a, b))
        .transform((Matrix4.identity()
              ..translate(size.width / 2, size.height / 2, 0.0)
              ..scale(size.width / 2, size.width / 2, 1.0))
            .storage);

    final mainCircle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * 5 / 12,
      ));

    return Path.combine(
      PathOperation.union,
      mainCircle,
      partsPath,
    );
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

  double sinLerp(double minVal, double maxVal, double sinVal) =>
      lerpDouble(minVal, maxVal, (1 + sin(sinVal)) / 2)!;

  Offset driftingCenter(Drifting part) {
    final centerTransform = Matrix4.identity()..rotateZ(part.axis);
    final centerVec = centerTransform
        .transformed(Vector4(sinLerp(0.8, 0.95, part.distance), 0, 0, 0));
    return Offset(centerVec[0], centerVec[1] * 1.9);
  }

  Path circleToPath(Circle circle) {
    final center = driftingCenter(circle);

    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: circle.radius));
  }

  Path rectToPath(SkewedRect rect) {
    final center = driftingCenter(rect);
    final size = rect.rect;

    final halfSkew = rect.skew * size.height;
    final halfHeight = size.height / 2;
    final halfWidth = size.width / 2;

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
