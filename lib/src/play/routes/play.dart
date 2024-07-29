import 'dart:math';

import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/color/widgets/color_wheel.dart';
import 'package:artists_eye/src/play/models/score.dart';
import 'package:artists_eye/src/play/routes/final_score.dart';
import 'package:artists_eye/src/play/widgets/color_comparison.dart';
import 'package:artists_eye/src/play/widgets/pick_from_gradient.dart';
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

  late Color colorLeft;
  late Color colorRight;
  late double answer;
  double? picked;

  final random = Random();

  @override
  void initState() {
    super.initState();
    score.start();

    if (widget.colorLeft != null && widget.colorRight != null) {
      colorLeft = widget.colorLeft!;
      colorRight = widget.colorRight!;
      answer = random.nextDouble();
    } else {
      newPuzzle();
    }
  }

  void newPuzzle() {
    colorLeft = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    colorRight = Color.fromARGB(
      0xFF,
      random.nextInt(0xFF),
      random.nextInt(0xFF),
      random.nextInt(0xFF),
    );

    answer = random.nextDouble();
    picked = null;
  }

  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      thumb: ThumbWidget(
        text: 'Find me!',
        heroTag: 'findme${widget.challenge.id}',
        color: Color.lerp(colorLeft, colorRight, answer)!,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          Text('Match the color:\n (${score.correct} / 10)',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
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
                    onSelect: (value) {
                      setState(() {
                        picked = value;
                        score.addMatch(getScore());
                      });
                      if (widget.challenge.finished(score)) {
                        score.end();
                      }
                      showComparisonModal();
                    },
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
                    duration: widget.challenge.time,
                    onDone: timeUp,
                  ),
                ),
              ],
            ),
          ),
        ].reversed.toList(),
      ),
    );
  }

  void timeUp() {
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

  void showComparisonModal() async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.grey[400]!.withOpacity(0.1),
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, ___) {
          return FadeTransition(
            opacity: animation,
            child: ColorComparison(
              pickedColor: Color.lerp(colorLeft, colorRight, picked!)!,
              correctColor: Color.lerp(colorLeft, colorRight, answer)!,
              match: getScore(),
              challengeId: widget.challenge.id,
            ),
          );
        },
      ),
    );

    setState(() {
      newPuzzle();
    });
  }

  double labColorDistance(Color a, Color b) {
    final labA = OklabColor.fromColor(a);
    final labB = OklabColor.fromColor(b);

    final adist = labA.a - labB.a;
    final bdist = labA.b - labB.b;
    final ldist = labA.lightness - labB.lightness;

    return sqrt(adist * adist + bdist * bdist + ldist * ldist);
  }

  double getScore() {
    final correctColor = Color.lerp(colorLeft, colorRight, answer)!;
    final pickedColor = Color.lerp(colorLeft, colorRight, picked!)!;

    return (1 - labColorDistance(correctColor, pickedColor) * 8)
        .clamp(0.0, 1.0);
  }
}
