import 'package:flutter/material.dart';

class ColorWheel extends StatelessWidget {
  const ColorWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorWheelPainter(),
      child: const SizedBox(
        height: 580,
        width: 200,
      ),
    );
  }
}

class ColorWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(0, size.width);
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
      ..shader = const SweepGradient(
        startAngle: 3.14 * 1,
        //endAngle: 1.5 * 3.14,
        center: FractionalOffset.center,
        colors: [
	      Colors.orange,
          Colors.red,
		  Colors.purple,
          Colors.blue,
        ],
        transform: GradientRotation(3.14 * 0.35),
      ).createShader(
          Offset(-size.width / 2, size.width - size.height / 2) & size);

    canvas.drawPath(ring, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
