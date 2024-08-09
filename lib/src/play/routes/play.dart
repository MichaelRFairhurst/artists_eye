import 'dart:math';

import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/color/models/color_match.dart';
import 'package:artists_eye/src/color/widgets/color_wheel.dart';
import 'package:artists_eye/src/play/models/color_test.dart';
import 'package:artists_eye/src/play/models/score.dart';
import 'package:artists_eye/src/play/routes/final_score.dart';
import 'package:artists_eye/src/play/widgets/color_comparison.dart';
import 'package:artists_eye/src/play/widgets/mistakes_widget.dart';
import 'package:artists_eye/src/play/widgets/pick_from_gradient.dart';
import 'package:artists_eye/src/play/widgets/pick_from_wheel.dart';
import 'package:artists_eye/src/play/widgets/pick_with_vocab.dart';
import 'package:artists_eye/src/play/widgets/progress.dart';
import 'package:artists_eye/src/play/widgets/timer.dart';
import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:artists_eye/src/scaffold/widgets/primary_area_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:material_color_utilities/material_color_utilities.dart'
    show Cam16, Hct;

class Play extends StatefulWidget {
  const Play({
    required this.challenge,
    this.startingColorTest,
    super.key,
  });

  final Challenge challenge;
  final ColorTest? startingColorTest;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  final score = Score();
  final completed = <Color>[];

  late ColorTest colorTest;
  Color? picked;

  final random = Random();

  @override
  void initState() {
    super.initState();
    score.start();

    if (widget.challenge.tutorialBuilder != null) {
      // TODO: fix this...
      Future.delayed(const Duration(seconds: 1)).then((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            insetPadding: const EdgeInsets.all(16.0),
            content: widget.challenge.tutorialBuilder!(),
          ),
        );
      });
    }
    colorTest = widget.startingColorTest ?? widget.challenge.makeColorTest();
  }

  void setNewColorTest() {
    setState(() {
      colorTest = widget.challenge.makeColorTest();
    });
  }

  Widget get heading => score.correct(widget.challenge.difficulty) == 0
      ? matchTextHeading
      : progress;

  Widget get matchTextHeading => Text(
        widget.challenge.prompt,
        style: Theme.of(context).textTheme.titleLarge,
      );

  Widget get progress => Progress(
        completed: completed,
        total: widget.challenge.difficulty.goal,
      );

  Widget primaryAreaGradient() {
    final colorTest = this.colorTest;
    final Color colorLeft;
    final Color colorRight;

    if (colorTest is GradientColorTest) {
      if (widget.challenge.isWheel) {
        const softener = AddHSL(
          deltaSaturation: -0.5,
          deltaLightness: 0.2,
        );

        colorLeft = softener.perform(colorTest.colorRight);
        colorRight = softener.perform(colorTest.colorLeft);
      } else {
        colorLeft = colorTest.colorLeft;
        colorRight = colorTest.colorRight;
      }
    } else {
      colorLeft = Colors.grey[200]!;
      colorRight = Colors.grey[100]!;
    }

    return Positioned.fill(
      child: PrimaryAreaGradient(
        heroTag: 'gradient${widget.challenge.id}',
        colorLeft: colorLeft,
        colorRight: colorRight,
      ),
    );
  }

  Widget overPrimaryArea() {
    final colorTest = this.colorTest;

    if (colorTest is GradientColorTest && widget.challenge.isWheel) {
      return Positioned.fill(
        top: 32,
        child: FadeIn(
          child: ColorWheel(
            colorLeft: colorTest.colorLeft,
            colorRight: colorTest.colorRight,
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget colorPickerWidget() {
    final colorTest = this.colorTest;
    if (colorTest is GradientColorTest) {
      if (widget.challenge.isWheel) {
        return Positioned.fill(
          top: 32,
          child: PickFromWheel(
            colorLeft: colorTest.colorLeft,
            colorRight: colorTest.colorRight,
            pickedColorEffect: widget.challenge.selectedColorEffect,
            onSelect: colorSelected,
          ),
        );
      } else {
        return Positioned.fill(
          child: PickFromGradient(
            colorLeft: colorTest.colorLeft,
            colorRight: colorTest.colorRight,
            onSelect: colorSelected,
          ),
        );
      }
    }

    if (colorTest is MultiSelectColorTest) {
      return Positioned.fill(
        top: 32,
        child: FadeIn(
          child: PickWithVocab(
            options: colorTest.options,
            onSelect: colorSelected,
          ),
        ),
      );
    }

    throw 'unreachable!';
  }

  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      thumb: ThumbWidget(
        text: widget.challenge.thumbtext,
        heroTag: 'findme${widget.challenge.id}',
        color: colorTest.hintColor,
      ),
      background: Container(color: Colors.white),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 12),
            child: heading,
          ),
          const SizedBox(height: 12),
        ],
      ),
      primaryAreaGradient: Stack(
        alignment: Alignment.topCenter,
        children: [
          primaryAreaGradient(),
          overPrimaryArea(),
          colorPickerWidget(),
          Positioned(
            bottom: 36,
            left: 36,
            child: Timer(
              buffer: const Duration(milliseconds: 1500),
              running: !widget.challenge.finished(score),
            ),
          ),
        ],
      ),
    );
  }

  void colorSelected(Color value) {
    setState(() {
      picked = value;

      final match = getMatch();
      score.addMatch(match);

      if (widget.challenge.isCorrect(match.type)) {
        final hsv = HSLColor.fromColor(picked!);
        completed
            .add(hsv.withSaturation(hsv.saturation.clamp(0, 0.7)).toColor());
      }

      if (widget.challenge.finished(score)) {
        score.end();
      }

      showComparisonModal(match);
    });
  }

  void endPlay() {
    final records = widget.challenge.getNewRecords(score);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return FinalScore(
            score: score,
            challenge: widget.challenge,
            records: records,
          );
        },
      ),
    );
  }

  void showComparisonModal(ColorMatch colorMatch) async {
    final Widget mistakesWidget;
    if (!widget.challenge.isCorrect(colorMatch.type)) {
      mistakesWidget = MistakesWidget(
        mistakes: score.incorrect(widget.challenge.difficulty),
        allowedMistakes: widget.challenge.difficulty.allowedMistakes,
      );
    } else {
      mistakesWidget = const SizedBox();
    }
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.grey[400]!.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, ___) {
          return FadeTransition(
            opacity: animation,
            child: ColorComparison(
              mistakesWidget: mistakesWidget,
              match: colorMatch,
              challenge: widget.challenge,
            ),
          );
        },
      ),
    );

    if (widget.challenge.finished(score)) {
      endPlay();
    } else {
      setNewColorTest();
    }
  }

  double cam16Score(Color a, Color b) {
    final cam16a = Cam16.fromInt(a.toRgbColor().value);
    final cam16b = Cam16.fromInt(b.toRgbColor().value);
    final dist = cam16a.distance(cam16b);

    return (1 - dist / 100).clamp(0.0, 1.0);
  }

  double hctScore(Color a, Color b) {
    final hcta = Hct.fromInt(a.toRgbColor().value);
    final hctb = Hct.fromInt(b.toRgbColor().value);

    final hdist = hcta.hue - hctb.hue;
    final cdist = hcta.chroma - hctb.chroma;
    final tdist = hcta.tone - hctb.tone;

    final dist = sqrt(hdist * hdist + cdist * cdist + tdist * tdist);

    return (1 - dist / 75).clamp(0.0, 1.0);
  }

  double labScore(Color a, Color b) {
    return (1 - labColorDistance(a, b) / 50).clamp(0.0, 1.0);
  }

  double labColorDistance(Color a, Color b) {
    final labA = OklabColor.fromColor(a);
    final labB = OklabColor.fromColor(b);

    final adist = labA.a - labB.a;
    final bdist = labA.b - labB.b;
    final ldist = labA.lightness - labB.lightness;

    return sqrt(adist * adist + bdist * bdist + ldist * ldist);
  }

  ColorMatch getMatch() {
    return ColorMatch(
      targetColor: colorTest.toFind,
      pickedColor: picked!,
      //percentage: cam16Score(answer, picked!),
      percentage: hctScore(colorTest.toFind, picked!),
    );
  }
}
