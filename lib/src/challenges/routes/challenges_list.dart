import 'package:artists_eye/src/challenges/widgets/challenge_tile.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/util/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class ChallengesList extends StatelessWidget {
  const ChallengesList({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(
            title: Text("Artist's Eye"),
            backgroundColor: Colors.transparent,
          ),
          SliverList.list(
            children: const [
              ChallengeTile(
                id: 'color',
                name: 'Match Color',
              ),
              ChallengeTile(
                id: 'hue',
                name: 'Match Hue',
                tileColorEffect: AddHSL(
                  deltaSaturation: 0.1,
                  deltaLightness: -0.1,
                ),
                rightColorEffect: AddHSL(
                  deltaSaturation: -0.1,
                  deltaLightness: 0.1,
                ),
              ),
              ChallengeTile(
                id: 'brightness',
                name: 'Match Brightness',
                tileColorEffect: AddHSL(
                  deltaHue: 80,
                  deltaSaturation: -0.3,
                ),
                rightColorEffect: AddHSL(
                  deltaLightness: -0.3,
                ),
              ),
              ChallengeTile(
                id: 'complimentary',
                name: 'Complimentary',
                tileColorEffect: AddHSL(
                  deltaHue: 180,
                ),
              ),
              ChallengeTile(
                id: 'wheel',
                name: 'Color Wheel',
              ),
              ChallengeTile(
                id: 'vocab',
                name: 'Vocabulary',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
