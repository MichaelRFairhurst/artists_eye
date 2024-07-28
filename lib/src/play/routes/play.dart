import 'dart:math';

import 'package:artists_eye/src/color/widgets/color_wheel.dart';
import 'package:artists_eye/src/play/widgets/color_comparison.dart';
import 'package:artists_eye/src/play/widgets/pick_from_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:artists_eye/src/scaffold/widgets/primary_area_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';

class Play extends StatefulWidget {
  const Play({
    required this.challengeId,
    required this.colorLeft,
    required this.colorRight,
    this.isWheel = false,
    super.key,
  });

  final String challengeId;
  final bool isWheel;
  final Color colorLeft;
  final Color colorRight;

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  int correct = 0;
  int tests = 0;

  late Color colorLeft;
  late Color colorRight;
  late double answer;
  double? picked;

  final random = Random();

  @override
  void initState() {
    super.initState();

    colorLeft = widget.colorLeft;
    colorRight = widget.colorRight;
    answer = random.nextDouble();
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
        heroTag: 'findme${widget.challengeId}',
        color: Color.lerp(colorLeft, colorRight, answer)!,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          Text('Match the color:\n ($correct / $tests)',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  child: PrimaryAreaGradient(
                    heroTag: 'gradient${widget.challengeId}',
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
                        tests++;
                        if (getScore() > 0.9) {
                          correct++;
                        }
                      });
                      showComparisonModal();
                    },
                  ),
                ),
                if (widget.isWheel)
                  const Positioned.fill(
                    child: FadeIn(
                      child: ColorWheel(),
                    ),
                  ),
              ],
            ),
          ),
        ].reversed.toList(),
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
              challengeId: widget.challengeId,
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
    final labA = LabColor.fromColor(a);
    final labB = LabColor.fromColor(b);

    final adist = labA.a - labB.a;
    final bdist = labA.b - labB.b;
    final ldist = labA.lightness - labB.lightness;

    return sqrt(adist * adist + bdist * bdist + ldist * ldist);
  }

  double getScore() {
    final correctColor = Color.lerp(colorLeft, colorRight, answer)!;
    final pickedColor = Color.lerp(colorLeft, colorRight, picked!)!;

	return (1 - labColorDistance(correctColor, pickedColor) / 80).clamp(0, 1);
  }
}
