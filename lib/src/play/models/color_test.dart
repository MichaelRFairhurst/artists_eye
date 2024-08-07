import 'package:flutter/painting.dart';

class ColorTest {
  const ColorTest({
    required this.colorLeft,
    required this.colorRight,
    required this.hintColor,
    required this.toFind,
  });

  /// The color to the "left" of the correct color (wheel, gradient, etc).
  final Color colorLeft;

  /// The color to the "right" of the correct color (wheel, gradient, etc).
  final Color colorRight;

  /// The color shown to the user.
  ///
  /// Not necessarily the color the user must find. For instance, it may be the
  /// compliment of the target color.
  final Color hintColor;

  /// The correct, target color, that the user is being asked to find.
  ///
  /// This color should exist "between" [colorLeft] and [colorRight] in the
  /// gradient, color wheel, etc.
  final Color toFind;

  ColorTest copyWith({
    Color? colorLeft,
    Color? colorRight,
    Color? hintColor,
    Color? toFind,
  }) =>
      ColorTest(
        colorLeft: colorLeft ?? this.colorLeft,
        colorRight: colorRight ?? this.colorRight,
        hintColor: hintColor ?? this.hintColor,
        toFind: toFind ?? this.toFind,
      );
}
