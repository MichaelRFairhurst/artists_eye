import 'dart:math';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/color/models/hsv_color_tween.dart';
import 'package:artists_eye/src/play/widgets/pick_color_button.dart';
import 'package:flutter/material.dart';

class PickFromWheel extends StatefulWidget {
  const PickFromWheel({
    required this.colorLeft,
    required this.colorRight,
    required this.onSelect,
    this.pickerSize = 64,
    this.pickedColorEffect = ColorEffect.none,
    super.key,
  });

  final void Function(Color) onSelect;
  final Color colorLeft;
  final Color colorRight;
  final double pickerSize;
  final ColorEffect pickedColorEffect;

  @override
  State<PickFromWheel> createState() => _PickFromWheelState();
}

class _PickFromWheelState extends State<PickFromWheel> {
  _Selection? picked;
  late HsvColorTween colorTween;

  @override
  void initState() {
    super.initState();
    colorTween = HsvColorTween(
      begin: HSLColor.fromColor(widget.colorLeft),
      end: HSLColor.fromColor(widget.colorRight),
    );
  }

  @override
  void didUpdateWidget(PickFromWheel oldWidget) {
    super.didUpdateWidget(oldWidget);

    colorTween = HsvColorTween(
      begin: HSLColor.fromColor(widget.colorLeft),
      end: HSLColor.fromColor(widget.colorRight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        pickHue(context, details.localPosition);
      },
      onTapDown: (details) {
        pickHue(context, details.localPosition);
      },
      onPanDown: (details) {
        pickHue(context, details.localPosition);
      },
      onPanStart: (details) {
        pickHue(context, details.localPosition);
      },
      onPanUpdate: (details) {
        pickHue(context, details.localPosition);
      },
      onPanEnd: (details) {
        pickHue(context, details.localPosition);
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
            ),
          ),
          if (picked != null)
            Positioned(
              left: picked!.buttonOffset.dx - widget.pickerSize / 2,
              top: picked!.buttonOffset.dy - widget.pickerSize / 2,
              child: PickColorButton(
                color: picked!.color,
                rotation: picked!.angle,
                onConfirm: () {
                  widget.onSelect(picked!.color);
                  setState(() {
                    picked = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void pickHue(BuildContext context, Offset offset) {
    final size = context.size!;
    final center = Offset(0, size.width);

    final relative = offset - center;
    final angle = pi - atan2(relative.dx, relative.dy);
    final shownAngle = pi / 2 + atan((size.height - size.width) / size.width);

    final radius = size.width - 50;
    final dx = cos(angle - pi / 2) * radius;
    final dy = sin(angle - pi / 2) * radius;
    final progress = angle / shownAngle;

    setState(() {
      picked = _Selection(
        angle: angle,
        color: widget.pickedColorEffect
            .perform(colorTween.transform(progress).toColor()),
        buttonOffset: Offset(dx, dy + size.width),
      );
    });
  }
}

class _Selection {
  const _Selection({
    required this.angle,
    required this.color,
    required this.buttonOffset,
  });

  final double angle;
  final Color color;
  final Offset buttonOffset;
}
