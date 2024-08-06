import 'dart:math';

import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/color/models/cam16.dart';
import 'package:artists_eye/src/color/models/color_match.dart';
import 'package:artists_eye/src/color/widgets/color_wheel.dart';
import 'package:artists_eye/src/play/models/score.dart';
import 'package:artists_eye/src/play/routes/final_score.dart';
import 'package:artists_eye/src/play/widgets/color_comparison.dart';
import 'package:artists_eye/src/play/widgets/mistakes_widget.dart';
import 'package:artists_eye/src/play/widgets/pick_from_gradient.dart';
import 'package:artists_eye/src/play/widgets/progress.dart';
import 'package:artists_eye/src/play/widgets/timer.dart';
import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:artists_eye/src/scaffold/widgets/primary_area_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';

class Play extends StatefulWidget {
  const Play({
    required this.challenge,
    this.colorLeft,
    this.colorRight,
    super.key,
  });

  final Challenge challenge;
  final Color? colorLeft;
  final Color? colorRight;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  final score = Score();
  final completed = <Color>[];

  late Color colorLeft;
  late Color colorRight;
  late Color answer;
  double? picked;

  final random = Random();

  @override
  void initState() {
    super.initState();
    score.start();

    if (widget.colorLeft != null && widget.colorRight != null) {
      colorLeft = widget.colorLeft!;
      colorRight = widget.colorRight!;
      answer = Color.lerp(colorLeft, colorRight, random.nextDouble())!;
    } else {
      newPuzzle();
    }
  }

  void newPuzzle() {
    final newTest = widget.challenge.makeColorTest();
    colorLeft = newTest.colorLeft;
    colorRight = newTest.colorRight;
    answer = newTest.toFind;
  }

  Widget get heading => score.correct(widget.challenge.difficulty) == 0
      ? matchTextHeading
      : progress;

  Widget get matchTextHeading => Text(
        'Match the color:',
        style: Theme.of(context).textTheme.titleLarge,
      );

  Widget get progress => Progress(
        completed: completed,
        total: widget.challenge.difficulty.goal,
      );

  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      thumb: ThumbWidget(
        text: 'Find me!',
        heroTag: 'findme${widget.challenge.id}',
        color: answer,
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
          Positioned.fill(
            child: PrimaryAreaGradient(
              heroTag: 'gradient${widget.challenge.id}',
              colorLeft: colorLeft,
              colorRight: colorRight,
            ),
          ),
          Positioned.fill(
            child: PickFromGradient(
              colorLeft: colorLeft,
              colorRight: colorRight,
              onSelect: colorSelected,
            ),
          ),
          if (widget.challenge.isWheel)
            const Positioned.fill(
              child: FadeIn(
                child: ColorWheel(),
              ),
            ),
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

  void colorSelected(double value) {
    setState(() {
      picked = value;

      final match = getMatch();
      score.addMatch(match);

      if (widget.challenge.isCorrect(match.type)) {
        final pickedColor = Color.lerp(colorLeft, colorRight, value)!;
        final hsv = HSLColor.fromColor(pickedColor);
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
      setState(() {
        newPuzzle();
      });
    }
  }

  double cam16Score(Color a, Color b) {
    final dist = Cam16Color.fromXYZ(XyzColor.fromColor(a))
        .distanceTo(Cam16Color.fromXYZ(XyzColor.fromColor(b)));

    return (1 - dist / 200).clamp(0.0, 1.0);
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
    final targetColor = answer;
    final pickedColor = Color.lerp(colorLeft, colorRight, picked!)!;

    return ColorMatch(
      targetColor: targetColor,
      pickedColor: pickedColor,
      percentage: cam16Score(targetColor, pickedColor),
    );
  }
}
