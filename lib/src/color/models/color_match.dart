import 'dart:ui';

import 'package:artists_eye/src/color/models/match_type.dart';

class ColorMatch {
  ColorMatch({
    required this.percentage,
    required this.targetColor,
    required this.pickedColor,
  }) : type = MatchType.fromDouble(percentage);

  final Color targetColor;
  final Color pickedColor;
  final double percentage;
  final MatchType type;
}
