import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

abstract class ColorTest {
  const ColorTest({
    required this.hintColor,
    required this.toFind,
  });

  /// Color to be shown in the challenge tile on the list view.
  Color get tileGradientLeft;

  /// Color to be shown in the challenge tile on the list view.
  Color get tileGradientRight;

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
}

class ColorOption {
  const ColorOption({
    required this.color,
    required this.colorName,
  });

  final Color color;
  final String colorName;
}

const primary6 = <ColorOption>[
  ColorOption(color: Color(0xFFFF0000), colorName: 'red'),
  ColorOption(color: Color(0xFFFF00FF), colorName: 'magenta'),
  ColorOption(color: Color(0xFF0000FF), colorName: 'blue'),
  ColorOption(color: Color(0xFF00FFFF), colorName: 'cyan'),
  ColorOption(color: Color(0xFF00FF00), colorName: 'green'),
  ColorOption(color: Color(0xFFFFFF00), colorName: 'yellow'),
];

class MultiSelectColorTest extends ColorTest {
  const MultiSelectColorTest({
    required this.options,
    required super.hintColor,
    required super.toFind,
  });

  @override
  Color get tileGradientLeft => options.first.color;

  @override
  Color get tileGradientRight => options.last.color;

  final List<ColorOption> options;
}

class GradientColorTest extends ColorTest {
  const GradientColorTest({
    required this.colorLeft,
    required this.colorRight,
    required super.hintColor,
    required super.toFind,
  });

  /// The color to the "left" of the correct color (wheel, gradient, etc).
  final Color colorLeft;

  /// The color to the "right" of the correct color (wheel, gradient, etc).
  final Color colorRight;

  @override
  Color get tileGradientLeft => colorLeft;

  @override
  Color get tileGradientRight => colorRight;

  GradientColorTest copyWith({
    Color? colorLeft,
    Color? colorRight,
    Color? hintColor,
    Color? toFind,
  }) =>
      GradientColorTest(
        colorLeft: colorLeft ?? this.colorLeft,
        colorRight: colorRight ?? this.colorRight,
        hintColor: hintColor ?? this.hintColor,
        toFind: toFind ?? this.toFind,
      );
}
