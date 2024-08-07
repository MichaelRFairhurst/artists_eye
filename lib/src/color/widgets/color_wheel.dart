import 'dart:math';
import 'package:artists_eye/src/color/models/hsv_color_tween.dart';
import 'package:flutter/material.dart';

class ColorWheel extends StatelessWidget {
  const ColorWheel({
    required this.colorLeft,
    required this.colorRight,
    super.key,
  });

  final Color colorLeft;
  final Color colorRight;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorWheelPainter(
        colorTween: HsvColorTween(
		  begin: HSLColor.fromColor(colorLeft),
		  end: HSLColor.fromColor(colorRight),
		),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class ColorWheelPainter extends CustomPainter {
  static const stops = 15;

  const ColorWheelPainter({
     required this.colorTween,
  });

  final HsvColorTween colorTween;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(0, size.width);

    final shownAngle = pi / 2 + atan((size.height - size.width) / size.width);
    final outer = Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: size.width,
        ),
      );

    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: size.width - 100,
        ),
      );

    final ring = Path.combine(
      PathOperation.difference,
      outer,
      inner,
    );

    final paint = Paint()
      ..shader = getGradient(shownAngle).createShader(
          Offset(-size.width / 2, size.width - size.height / 2) & size);

    canvas.drawPath(ring, paint);
  }

  SweepGradient getGradient(double shownAngle) {
    return SweepGradient(
      startAngle: 0,
      endAngle: shownAngle,
      center: FractionalOffset.center,
      colors: gradientColors(),
      transform: const GradientRotation(-pi / 2),
    );
  }

  List<Color> gradientColors() {
    return [
      for (int i = 0; i <= stops; ++i)
        colorTween.transform(i / stops).toColor()
    ];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
