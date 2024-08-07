import 'dart:math';

import 'package:artists_eye/src/challenges/models/difficulty.dart';
import 'package:artists_eye/src/challenges/models/record_history.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/color/models/match_type.dart';
import 'package:artists_eye/src/play/models/color_test.dart';
import 'package:artists_eye/src/play/models/score.dart';
import 'package:flutter/painting.dart';

class Challenge {
  Challenge({
    required this.name,
    required this.id,
    required this.difficulty,
    required this.makeColorTest,
	required this.prompt,
	required this.thumbtext,
    this.isWheel = false,
    this.selectedColorEffect = ColorEffect.none,
  }) : recordHistory = RecordHistory(
          mistakesAllowed: difficulty.allowedMistakes,
        );

  final String name;
  final String id;
  final String prompt;
  final String thumbtext;
  final bool isWheel;
  final Difficulty difficulty;
  final RecordHistory recordHistory;
  final ColorTest Function() makeColorTest;

  final ColorEffect selectedColorEffect;

  bool isWin(Score score) => difficulty.isWin(score);

  bool finished(Score score) => difficulty.finished(score);

  bool isCorrect(MatchType matchType) => difficulty.isCorrect(matchType);

  List<RecordValue> getNewRecords(Score newScore) {
    if (!isWin(newScore)) {
      return const [];
    }
    return recordHistory.getNewRecords(newScore, difficulty);
  }

  static GradientColorTest matchBrightness() {
    final random = Random();

    final rgb = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    final hsv = HSVColor.fromColor(rgb);
    return GradientColorTest(
      colorLeft: hsv.withValue(0).toColor(),
      colorRight: hsv.withValue(1).toColor(),
      toFind: rgb,
	  hintColor: rgb,
    );
  }

  static GradientColorTest matchSaturation() {
    final random = Random();

    final rgb = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    final hsv = HSVColor.fromColor(rgb);
    return GradientColorTest(
      colorLeft: hsv.withSaturation(0).toColor(),
      colorRight: hsv.withSaturation(1).toColor(),
      toFind: rgb,
	  hintColor: rgb,
    );
  }

  static GradientColorTest matchColor() {
    final random = Random();

    final rgb = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    final hsv = HSVColor.fromColor(rgb);
    return GradientColorTest(
      colorLeft:
          hsv.withHue((hsv.hue + random.nextDouble() * 60) % 360).toColor(),
      colorRight:
          hsv.withHue((hsv.hue - random.nextDouble() * 60) % 360).toColor(),
      toFind: rgb,
	  hintColor: rgb,
    );
  }

  static ColorTest matchColorComplimentIntro() {
	final random = Random();
	const count = 3;
	final index = random.nextInt(primary6.length);
	final offset = -random.nextInt(count - 1);

	const desaturate = AddHSL(
	  deltaSaturation: -0.7,
	  deltaLightness: 0.05,
	);

    return MultiSelectColorTest(
	  toFind: desaturate.perform(primary6[index].color),
	  hintColor: desaturate.perform(primary6[(index + 3) % 6].color),
	  options: [
	    for (var i = 0; i < count; ++i)
		  ColorOption(
		    color: desaturate.perform(primary6[(i + index + offset) % 6].color),
			colorName: primary6[(i + index + offset) % 6].colorName,
		  ),
	  ]
	);
  }

  static ColorTest matchColorComplimentEasy() {
	final matchColorTest = matchColor();
	const addHue = AddHSL(
	  deltaHue: 180,
	);
	return matchColorTest.copyWith(
	  colorLeft: addHue.perform(matchColorTest.colorLeft),
	  colorRight: addHue.perform(matchColorTest.colorRight),
	);
  }

  static GradientColorTest matchColorComplimentHard() {
	final matchColorTest = matchColor();
	const addHue = AddHSL(
	  deltaHue: 180,
	);
	return matchColorTest.copyWith(
	  hintColor: addHue.perform(matchColorTest.hintColor),
	);
  }
}
