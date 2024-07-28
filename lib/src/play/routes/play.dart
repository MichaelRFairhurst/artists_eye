import 'dart:math';

import 'package:artists_eye/src/color/widgets/color_wheel.dart';
import 'package:artists_eye/src/play/widgets/color_comparison.dart';
import 'package:artists_eye/src/play/widgets/pick_from_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:artists_eye/src/scaffold/widgets/primary_area_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';

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
      body: GestureDetector(
        onTap: () {
          if (picked != null) {
            setState(() {
              newPuzzle();
            });
          }
        },
        child: Column(
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

  double colorDistance(Color a, Color b) {
    const gamma = 2.2;
    num gammaCorrect(int a) => a; // pow(a / 255, 1 / gamma);

    num componentDist(int a, int b) {
      return pow(gammaCorrect(a) - gammaCorrect(b), 2);
    }

    final rmean = (gammaCorrect(a.red) + gammaCorrect(b.red)) / 2;
    final red = componentDist(a.red, b.red);
    final green = componentDist(a.green, b.green);
    final blue = componentDist(a.blue, b.blue);

    return sqrt((((512 + rmean) * red * red) / 256) +
        4 * green * green +
        (((767 - rmean) * blue * blue) / 256));
    //num cubeRoot(num a) => pow(a, 1 / 3);

    //return 1 -
    //    cubeRoot(componentDist(a.red, b.red) +
    //            componentDist(a.green, b.green) +
    //            componentDist(a.blue, b.blue)) /
    //        (cubeRoot(componentDist(0, 255) * 3));
  }

  double getScore() {
    final correctColor = Color.lerp(colorLeft, colorRight, answer)!;
    final pickedColor = Color.lerp(colorLeft, colorRight, picked!)!;

    return (1 - colorDistance(correctColor, pickedColor) / 3000)
        .clamp(0.0, 1.0);
  }

}
