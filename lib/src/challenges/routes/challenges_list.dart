import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/challenges/models/difficulty.dart';
import 'package:artists_eye/src/challenges/widgets/challenge_tile.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/scaffold/widgets/artists_eye_scaffold.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial.dart';
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
              prompt: 'Match the color tone:',
			  thumbtext: 'find me!',
              isWheel: true,
              makeColorTest: Challenge.matchColor,
            ),
            Challenge(
              difficulty: easy,
              id: 'brightness',
              name: 'Match Lightness',
              prompt: 'Match the lightness:',
			  thumbtext: 'find me!',
              makeColorTest: Challenge.matchBrightness,
            ),
            Challenge(
              difficulty: easy,
              id: 'saturation',
              name: 'Match Intensity',
              prompt: 'Match the color intensity:',
			  thumbtext: 'find me!',
              makeColorTest: Challenge.matchSaturation,
            ),
            Challenge(
              difficulty: easy,
              id: 'complimentintro',
              name: 'Intro to Compliments',
              prompt: 'Select the complimentary color:',
			  thumbtext: 'match me!',
              makeColorTest: Challenge.matchColorComplimentIntro,
			  tutorialBuilder: () => ComplimentaryTutorial(),
            ),
            Challenge(
              difficulty: easy,
              id: 'compliment',
              name: 'Match Compliment',
              isWheel: true,
              prompt: 'Find the complimentary color:',
			  thumbtext: 'match me!',
              makeColorTest: Challenge.matchColorComplimentEasy,
			  selectedColorEffect: const AddHSL(deltaHue: 180),
            ),
            Challenge(
              difficulty: medium,
              id: 'brightness2',
              name: 'Match Lightness II',
              prompt: 'Match the ligtness:',
			  thumbtext: 'find me!',
              makeColorTest: Challenge.matchBrightness,
            ),
            Challenge(
              difficulty: medium,
              id: 'saturation2',
              name: 'Match Intensity II',
              prompt: 'Match the color intensity:',
			  thumbtext: 'find me!',
              makeColorTest: Challenge.matchSaturation,
            ),
            Challenge(
              difficulty: easy,
              id: 'compliment2',
              name: 'Match Compliment II',
              prompt: 'Find the complimentary color:',
			  thumbtext: 'match me!',
              isWheel: true,
              makeColorTest: Challenge.matchColorComplimentHard,
            ),
          ].map((challenge) => ChallengeTile(challenge: challenge)),
        ],
      ),
    );
  }
}
