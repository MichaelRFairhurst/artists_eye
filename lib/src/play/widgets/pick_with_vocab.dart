import 'dart:math';
import 'package:artists_eye/src/play/models/color_test.dart';
import 'package:flutter/material.dart';

class PickWithVocab extends StatefulWidget {
  const PickWithVocab({
    required this.options,
    required this.onSelect,
    super.key,
  });

  final List<ColorOption> options;
  final void Function(Color) onSelect;

  @override
  State<PickWithVocab> createState() => _PickWithVocabState();
}

class _PickWithVocabState extends State<PickWithVocab> {
  int? selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => handleTap(context, details),
      child: CustomPaint(
        painter: ColorVocabPainter(
          options: widget.options,
          selected: selected,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {
    final offset = details.localPosition;
    final size = context.size!;
    final center = Offset(0, size.width);

    final relative = offset - center;
    final angle = pi - atan2(relative.dx, relative.dy);
    final shownAngle = pi / 2 + atan((size.height - size.width) / size.width) + 0.6;
    final segmentAngle = shownAngle / widget.options.length;

    final tapped = (angle / segmentAngle).floor();

    if (tapped != selected) {
      setState(() {
        selected = (angle / segmentAngle).floor();
      });
    } else {
      widget.onSelect(widget.options[tapped].color);
	  setState(() {
		selected = null;
	  });
    }
  }
}

class ColorVocabPainter extends CustomPainter {
  const ColorVocabPainter({
    required this.options,
    required this.selected,
  });

  final List<ColorOption> options;
  final int? selected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(0, size.width);
    final segments = options.length;

    final shownAngle = pi / 2 + atan((size.height - size.width) / size.width) + 0.6;
    final circleRect = Rect.fromCircle(center: center, radius: size.width - 50);
    final segmentAngle = shownAngle / segments;

    for (int i = 0; i < segments; ++i) {
      final option = options[i];
      final startAngle = -pi / 2 + (shownAngle / segments) * i;

      if (selected == i) {
        canvas.drawArc(
          circleRect,
          startAngle,
          segmentAngle,
          false,
          Paint()
            ..color = Colors.white.withOpacity(0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 100,
        );
        canvas.drawArc(
          circleRect,
          startAngle,
          segmentAngle,
          false,
          Paint()
            ..color = option.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 100
            ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 8.0),
        );
      } else {
        canvas.drawArc(
          circleRect,
          startAngle,
          segmentAngle,
          false,
          Paint()
            ..color = option.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 100,
        );
      }

      canvas.save();
      try {
        canvas.translate(0, size.width);
        canvas.rotate(pi / 2 + startAngle + segmentAngle / 2);

        final textPainter = TextPainter(
          text: TextSpan(
            text: i == selected ? 'tap again' : option.colorName,
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(-textPainter.width / 2,
                -textPainter.height / 2 - size.width + 50));
      } finally {
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
