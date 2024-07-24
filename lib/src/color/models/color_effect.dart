import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';

abstract class ColorEffect {
  const ColorEffect();

  static const none = NoColorEffect();

  Color perform(Color input);

  ColorEffect and(ColorEffect other) => _CompoundColorEffect(this, other);
}

class NoColorEffect extends ColorEffect {
  const NoColorEffect();

  @override
  Color perform(Color input) => input;
}

class AddHSL extends ColorEffect {
  final double deltaAlpha;
  final double deltaHue;
  final double deltaSaturation;
  final double deltaLightness;

  const AddHSL({
    this.deltaAlpha = 0.0,
    this.deltaHue = 0.0,
    this.deltaSaturation = 0.0,
    this.deltaLightness = 0.0,
  });

  @override
  Color perform(Color input) {
    final hsl = HSLColor.fromColor(input);
    return HSLColor.fromAHSL(
      (hsl.alpha + deltaAlpha).clamp(0.0, 1.0),
      (hsl.hue + deltaHue) % 360.0,
      (hsl.saturation + deltaSaturation).clamp(0.0, 1.0),
      (hsl.lightness + deltaLightness).clamp(0.0, 1.0),
    ).toColor();
  }
}

class _CompoundColorEffect extends ColorEffect {
  final ColorEffect first;
  final ColorEffect second;

  _CompoundColorEffect(this.first, this.second);

  @override
  Color perform(Color input) => second.perform(first.perform(input));
}
