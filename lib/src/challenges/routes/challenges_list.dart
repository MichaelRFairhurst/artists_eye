import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/challenges/models/difficulty.dart';
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
              difficulty: easy,
              id: 'color',
              name: 'Match Color Tone',
              isWheel: true,
              makeColorTest: Challenge.matchColor,
            ),
            Challenge(
              difficulty: easy,
              id: 'brightness',
              name: 'Match Lightness',
              makeColorTest: Challenge.matchBrightness,
            ),
            Challenge(
              difficulty: easy,
              id: 'saturation',
              name: 'Match Intensity',
              makeColorTest: Challenge.matchSaturation,
            ),
            Challenge(
              difficulty: easy,
              id: 'compliment',
              name: 'Match Compliment',
              isWheel: true,
              makeColorTest: Challenge.matchColorComplimentEasy,
			  selectedColorEffect: const AddHSL(deltaHue: 180),
            ),
            Challenge(
              difficulty: medium,
              id: 'brightness2',
              name: 'Match Lightness II',
              makeColorTest: Challenge.matchBrightness,
            ),
            Challenge(
              difficulty: medium,
              id: 'saturation2',
              name: 'Match Intensity II',
              makeColorTest: Challenge.matchSaturation,
            ),
            Challenge(
              difficulty: easy,
              id: 'compliment2',
              name: 'Match Compliment II',
              isWheel: true,
              makeColorTest: Challenge.matchColorComplimentHard,
            ),
          ].map((challenge) => ChallengeTile(challenge: challenge)),
        ],
      ),
    );
  }
}
