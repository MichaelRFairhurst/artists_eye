import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PickFromGradient extends StatefulWidget {
  const PickFromGradient({
    required this.colorLeft,
    required this.colorRight,
    required this.onSelect,
    this.pickerSize = 64,
    super.key,
  });

  final void Function(double) onSelect;
  final Color colorLeft;
  final Color colorRight;
  final double pickerSize;

  @override
  State<PickFromGradient> createState() => _PickFromGradientState();
}

class _PickFromGradientState extends State<PickFromGradient> {
  Offset? picked;
  double? pickedProgress;

  static const shadowTransform = AddHSL(
    deltaHue: 120,
    deltaSaturation: 0.2,
    deltaLightness: 0.25,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        pickOffset(context, details.localPosition);
      },
      onTapDown: (details) {
        pickOffset(context, details.localPosition);
      },
      onPanDown: (details) {
        pickOffset(context, details.localPosition);
      },
      onPanStart: (details) {
        pickOffset(context, details.localPosition);
      },
      onPanUpdate: (details) {
        pickOffset(context, details.localPosition);
      },
      onPanEnd: (details) {
        pickOffset(context, details.localPosition);
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
              left: picked!.dx - widget.pickerSize / 2,
              top: picked!.dy - widget.pickerSize / 2,
              child: Container(
                width: widget.pickerSize,
                height: widget.pickerSize,
                decoration: BoxDecoration(
                  color: Color.lerp(
                      widget.colorLeft, widget.colorRight, pickedProgress!),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.0),
                    width: 4.0,
                  ),
                  borderRadius:
                      BorderRadius.circular(widget.pickerSize / 2 - 8),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 2,
                      color: shadowTransform
                          .perform(pickedColor())
                          .withOpacity(0.75),
                    ),
                  ],
                ),
                child: IconButton(
                    icon: const Icon(Icons.check_rounded),
                    color: shadowTransform.perform(pickedColor()),
                    onPressed: () {
                      widget.onSelect(pickedProgress!);
                      setState(() {
                        picked = null;
                        pickedProgress = null;
                      });
                    }),
              ),
            ),
        ],
      ),
    );
  }

  Color pickedColor() =>
      Color.lerp(widget.colorLeft, widget.colorRight, pickedProgress!)!;

  void pickOffset(BuildContext context, Offset offset) {
    final size = context.size!;
    final slope = -(size.height - size.width) / size.width;
    final expectedY = slope * offset.dx;
    final diff = offset.dy - expectedY;
    final progress = (diff / (size.height - slope * size.width));
    setState(() {
      picked = offset;
      pickedProgress = progress;
    });
  }
}
