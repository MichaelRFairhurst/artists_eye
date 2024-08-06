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
              goal: 10,
              maxMistakes: 5,
              id: 'color',
              name: 'Match Color Tone',
			  makeColorTest: Challenge.matchColor,
            ),
            Challenge(
              goal: 10,
              maxMistakes: 5,
              id: 'brightness',
              name: 'Match Lightness',
			  makeColorTest: Challenge.matchBrightness,
            ),
            Challenge(
              goal: 5,
              maxMistakes: 3,
              id: 'saturation',
              name: 'Match Intensity',
			  makeColorTest: Challenge.matchSaturation,
            ),
          ].map((challenge) => ChallengeTile(challenge: challenge)),
        ],
      ),
    );
  }
}
