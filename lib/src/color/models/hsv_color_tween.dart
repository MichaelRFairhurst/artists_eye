import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

class HsvColorTween extends Tween<HSLColor> {
  HsvColorTween({
    super.begin,
    super.end,
  });

  double _lerpHue(double t) {
    if (reverseHue) {
      return lerpDouble(begin!.hue + 360, end!.hue, t)! % 360;
    } else {
      return lerpDouble(begin!.hue, end!.hue, t)! % 360;
    }
  }

  @override
  HSLColor lerp(double t) => HSLColor.fromAHSL(
        lerpDouble(begin!.alpha, end!.alpha, t)!,
        _lerpHue(t),
        lerpDouble(begin!.saturation, end!.saturation, t)!,
        lerpDouble(begin!.lightness, end!.lightness, t)!,
      );

  bool get reverseHue =>
      (begin!.hue - end!.hue).abs() > ((begin!.hue + 360) - end!.hue).abs();
}
