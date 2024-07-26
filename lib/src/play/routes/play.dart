import 'dart:math';

import 'package:artists_eye/src/color/widgets/color_wheel.dart';
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
                      },
                    ),
                  ),
                  if (widget.isWheel)
                    const Positioned.fill(
                      child: FadeIn(
                        child: ColorWheel(),
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    reverseDuration: const Duration(milliseconds: 250),
                    child: picked == null
                        ? const SizedBox.expand()
                        : colorComparison(),
                  ),
                  if (picked != null) ...[
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            newPuzzle();
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                      ),
                    )
                  ],
                ],
              ),
            ),
          ].reversed.toList(),
        ),
      ),
    );
  }

  Widget targetColorBubble(bool withShadow) {
    return Positioned(
      right: 30,
      bottom: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          color: Color.lerp(colorLeft, colorRight, answer),
          boxShadow: [
            if (withShadow)
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 3,
              ),
          ],
        ),
        child: const SizedBox(
          height: 100,
          width: 100,
        ),
      ),
    );
  }

  Widget colorComparison() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          targetColorBubble(true),
          Padding(
            padding: const EdgeInsets.all(48),
            child: scoreBubble(),
          ),
          targetColorBubble(false),
        ],
      ),
    );
  }

  Widget scoreBubble() {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: Color.lerp(
            colorLeft,
            colorRight,
            picked!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5000,
              spreadRadius: 20,
              offset: const Offset(0, 120),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(scoreText(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.white)),
            const SizedBox(height: 16),
            Text(getScoreString(),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  String getScoreString() => '${(getScore() * 100).floor()}% match';

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

  String scoreText() {
    final score = getScore();
    if (score == 1.0) {
      return 'Perfect!';
    } else if (score >= 0.97) {
      return 'Excellent!';
    } else if (score > 0.90) {
      return 'Great!';
    } else if (score > 0.8) {
      return 'Almost!';
    } else if (score > 0.5) {
      return 'Not quite!';
    } else {
      return 'Try again!';
    }
  }
}
