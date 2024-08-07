import 'dart:math';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/color/models/hsv_color_tween.dart';
import 'package:flutter/material.dart';

class PickFromWheel extends StatefulWidget {
  const PickFromWheel({
    required this.colorLeft,
    required this.colorRight,
    required this.onSelect,
    this.pickerSize = 64,
    super.key,
  });

  final void Function(Color) onSelect;
  final Color colorLeft;
  final Color colorRight;
  final double pickerSize;

  @override
  State<PickFromWheel> createState() => _PickFromWheelState();
}

class _PickFromWheelState extends State<PickFromWheel> {
  double? pickedAngle;
  double? pickedProgress;
  Color? pickedColor;
  Offset? origin;
  late HsvColorTween colorTween;

  static const shadowTransform = AddHSL(
    deltaHue: 120,
    deltaSaturation: 0.2,
    deltaLightness: 0.25,
  );

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
          if (pickedAngle != null)
            Flow(
              delegate: _PickedAngleFlowDelegate(
                pickedAngle: pickedAngle!,
              ),
              children: [
                Hero(
                  tag: 'picked',
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: pickedColor!,
                      borderRadius:
                          BorderRadius.circular(widget.pickerSize / 2 - 8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 2,
                          color: shadowTransform
                              .perform(pickedColor!)
                              .withOpacity(0.75),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: widget.pickerSize,
                      height: widget.pickerSize,
                      child: IconButton(
                        icon: const Icon(Icons.check_rounded),
                        color: shadowTransform.perform(pickedColor!),
                        onPressed: () {
                          widget.onSelect(pickedColor!);
                          setState(
                            () {
                              pickedAngle = null;
                              pickedProgress = null;
                              pickedColor = null;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
    setState(() {
      origin = center;
      pickedAngle = angle;
      pickedProgress = angle / shownAngle;
      pickedColor = colorTween.transform(pickedProgress!).toColor();
    });
  }
}

class _PickedAngleFlowDelegate extends FlowDelegate {
  _PickedAngleFlowDelegate({
    required this.pickedAngle,
  });

  final double pickedAngle;

  @override
  void paintChildren(FlowPaintingContext context) {
    final squareSize = context.getChildSize(0)!;
    //final checkSize = context.getChildSize(1);
    final size = context.size;

    context.paintChild(0,
        transform: Matrix4.identity()
          ..translate(0.0, size.width)
          ..rotateZ(pickedAngle)
          ..translate(-squareSize.width / 2, -squareSize.height / 2)
          ..translate(0.0, -size.width + 50));
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return true;
  }
}
