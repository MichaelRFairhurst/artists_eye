import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/challenges/widgets/challenge_tile.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:flutter/material.dart';

class ChallengesList extends StatelessWidget {
  const ChallengesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      thumb: ThumbWidget(
        color: Colors.grey[400]!,
        text: 'Sign in',
      ),
      scrollable: true,
      body: Column(
        children: [
          const SizedBox(height: 24),
          ...[
            Challenge(
              time: const Duration(seconds: 60),
              goal: 10,
              maxMistakes: 5,
              id: 'color',
              name: 'Match Color',
            ),
            Challenge(
              time: const Duration(seconds: 20),
              goal: 5,
              maxMistakes: 3,
              id: 'speed',
              name: 'Speed run',
            ),
            Challenge(
              time: const Duration(seconds: 5),
              goal: 1,
              maxMistakes: 10,
              id: 'test',
              name: 'Test final screen',
            ),
            Challenge(
              time: const Duration(seconds: 60),
              goal: 10,
              maxMistakes: 5,
              id: 'hue',
              name: 'Match Hue',
              tilePreviewEffect: const AddHSL(
                deltaSaturation: 0.1,
                deltaLightness: -0.1,
              ),
              rightColorPreviewEffect: const AddHSL(
                deltaSaturation: -0.1,
                deltaLightness: 0.1,
              ),
            ),
            Challenge(
              time: const Duration(seconds: 60),
              goal: 10,
              maxMistakes: 5,
              id: 'brightness',
              name: 'Match Brightness',
              tilePreviewEffect: const AddHSL(
                deltaHue: 80,
                deltaSaturation: -0.3,
              ),
              rightColorPreviewEffect: const AddHSL(
                deltaLightness: -0.3,
              ),
            ),
            Challenge(
              time: const Duration(seconds: 60),
              goal: 10,
              maxMistakes: 5,
              id: 'complimentary',
              name: 'Complimentary',
              tilePreviewEffect: const AddHSL(
                deltaHue: 180,
              ),
            ),
            Challenge(
              time: const Duration(seconds: 60),
              goal: 10,
              maxMistakes: 5,
              id: 'wheel',
              name: 'Color Wheel',
            ),
            Challenge(
              time: const Duration(seconds: 60),
              goal: 10,
              maxMistakes: 5,
              id: 'vocab',
              name: 'Vocabulary',
            ),
          ].map((challenge) => ChallengeTile(challenge: challenge)),
        ],
      ),
    );
  }
}
