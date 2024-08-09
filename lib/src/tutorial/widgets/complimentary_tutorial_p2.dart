import 'package:artists_eye/src/color/models/primary.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial_circle.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial_page_body.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:artists_eye/src/util/widgets/positioned_around.dart';
import 'package:flutter/material.dart';

class ComplimentaryTutorialP2 extends StatelessWidget {
  const ComplimentaryTutorialP2({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialPageBody(
      parts: [
        const Text(
          'These three colors can be arranged in a circle, equal distance from'
          ' each other.',
        ),
		ShowImmediately(
		  child: colorCircle(),
		),
        const Text(
          'All color tones exist somewhere along this ring, called the color'
          ' wheel.',
        ),
      ],
    );
  }

  Widget colorCircle() => Center(
        child: SizedBox(
          width: 200,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(TutorialCircle.size / 2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      border: Border.all(
                        color: Colors.grey,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned.fill(
                child: PositionedAround(
                  childSize: TutorialCircle.size,
                  children: [
                    TutorialCircle(softRed, isHero: true),
                    FadeIn(
                      delay: Duration(seconds: 1),
                      child: TutorialCircle(softYellow, isHero: true),
                    ),
                    TutorialCircle(softGreen, isHero: true),
                    FadeIn(
                      delay: Duration(seconds: 1),
                      child: TutorialCircle(softCyan, isHero: true),
                    ),
                    TutorialCircle(softBlue, isHero: true),
                    FadeIn(
                      delay: Duration(seconds: 1),
                      child: TutorialCircle(softMagenta, isHero: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
