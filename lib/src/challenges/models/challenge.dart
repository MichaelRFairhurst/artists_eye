import 'dart:math';

import 'package:artists_eye/src/challenges/models/record_history.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/play/models/color_test.dart';
import 'package:artists_eye/src/play/models/score.dart';
import 'package:flutter/painting.dart';

class Challenge {
  Challenge({
    required this.name,
    required this.id,
    required this.goal,
    required this.maxMistakes,
    required this.makeColorTest,
    this.isWheel = false,
    this.tilePreviewEffect = ColorEffect.none,
    this.rightColorPreviewEffect = ColorEffect.none,
  }) : recordHistory = RecordHistory(
          mistakesAllowed: maxMistakes,
        );

  final String name;
  final String id;
  final bool isWheel;
  final int goal;
  final int maxMistakes;
  final RecordHistory recordHistory;
  final ColorTest Function() makeColorTest;

  final ColorEffect tilePreviewEffect;
  final ColorEffect rightColorPreviewEffect;

  bool isWin(Score score) {
    return score.correct >= goal && score.incorrect <= maxMistakes;
  }

  bool finished(Score score) {
    return score.correct >= goal || score.incorrect >= maxMistakes;
  }

  List<RecordValue> getNewRecords(Score newScore) {
    if (!isWin(newScore)) {
      return const [];
    }
    return recordHistory.getNewRecords(newScore);
  }

  static ColorTest matchBrightness() {
    final random = Random();

    final rgb = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    final hsv = HSVColor.fromColor(rgb);
    return ColorTest(
      colorLeft: hsv.withValue(0).toColor(),
      colorRight: hsv.withValue(1).toColor(),
      toFind: rgb,
    );
  }

  static ColorTest matchSaturation() {
    final random = Random();

    final rgb = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    final hsv = HSVColor.fromColor(rgb);
    return ColorTest(
      colorLeft: hsv.withSaturation(0).toColor(),
      colorRight: hsv.withSaturation(1).toColor(),
      toFind: rgb,
    );
  }

  static ColorTest matchColor() {
    final random = Random();

    final rgb = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    final hsv = HSVColor.fromColor(rgb);
    return ColorTest(
      colorLeft:
          hsv.withHue((hsv.hue + random.nextDouble() * 60) % 360).toColor(),
      colorRight:
          hsv.withHue((hsv.hue - random.nextDouble() * 60) % 360).toColor(),
      toFind: rgb,
    );
  }
}
