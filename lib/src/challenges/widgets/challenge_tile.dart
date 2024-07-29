import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/play/routes/play.dart';
import 'package:artists_eye/src/scaffold/widgets/gradient_to_primary_area.dart';
import 'package:artists_eye/src/scaffold/widgets/to_thumb_widget.dart';
import 'package:flutter/material.dart';
import 'package:artists_eye/src/util/widgets/changing_color.dart';

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    required this.challenge,
    super.key,
  });

  final Challenge challenge;

  void onTap(BuildContext context, Color colorLeft, Color colorRight) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        pageBuilder: (_, __, ___) => Play(
          challenge: challenge,
          colorLeft: colorLeft,
          colorRight: colorRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: ChangingColors(
        builder: (context, colorLeft, colorRight, _) {
          return GradientToPrimaryArea(
            heroTag: 'gradient${challenge.id}',
            colorLeft: colorLeft,
            colorRight: challenge.rightColorPreviewEffect.perform(colorRight),
            onTap: () {
              onTap(context, colorLeft, colorRight);
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ToThumbWidget(
                    heroTag: 'findme${challenge.id}',
                    color: challenge.tilePreviewEffect
                        .perform(Color.lerp(colorLeft, colorRight, 0.6)!),
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
