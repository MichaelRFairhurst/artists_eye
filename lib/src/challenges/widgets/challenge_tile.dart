import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/color/widgets/changing_color_test.dart';
import 'package:artists_eye/src/play/models/color_test.dart';
import 'package:artists_eye/src/play/routes/play.dart';
import 'package:artists_eye/src/scaffold/widgets/gradient_to_primary_area.dart';
import 'package:artists_eye/src/scaffold/widgets/to_thumb_widget.dart';
import 'package:flutter/material.dart';

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    required this.challenge,
    super.key,
  });

  final Challenge challenge;

  void onTap(BuildContext context, ColorTest colorTest) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        pageBuilder: (_, __, ___) => Play(
          challenge: challenge,
		  startingColorTest: colorTest,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: ChangingColorTest(
        makeColorTest: challenge.makeColorTest,
        builder: (context, colorTest, _) {
          final colorLeft = colorTest.colorLeft;
          final colorRight = colorTest.colorRight;
          return GradientToPrimaryArea(
            heroTag: 'gradient${challenge.id}',
            colorLeft: colorLeft,
            colorRight: colorRight,
            onTap: () {
              onTap(context, colorTest);
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ToThumbWidget(
                    heroTag: 'findme${challenge.id}',
                    color: colorTest.hintColor,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    challenge.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
