import 'package:artists_eye/src/challenges/models/challenge.dart';
import 'package:artists_eye/src/color/models/color_match.dart';
import 'package:flutter/material.dart';

class ColorComparison extends StatelessWidget {
  const ColorComparison({
    required this.match,
    required this.challenge,
    super.key,
  });

  final Challenge challenge;
  final ColorMatch match;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  targetColorBubble(true),
                  Padding(
                    padding: const EdgeInsets.all(48),
                    child: scoreBubble(context),
                  ),
                  targetColorBubble(false),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Text(
              'tap anywhere to continue',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget scoreBubble(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Hero(
        tag: 'picked',
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: match.pickedColor,
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
              Text('${scoreText()}!',
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
      ),
    );
  }

  Widget targetColorBubble(bool shadowOnly) {
    final shadowColor = Colors.black.withOpacity(0.15);
    final bubble = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(300),
        color: shadowOnly ? shadowColor : match.targetColor,
        boxShadow: [
          if (shadowOnly)
            BoxShadow(
              color: shadowColor,
              blurRadius: 3,
            ),
        ],
      ),
      child: const SizedBox(
        height: 100,
        width: 100,
      ),
    );

    return Positioned(
      right: 30,
      bottom: 30,
      child: shadowOnly
          ? bubble
          : Hero(
              tag: 'findme${challenge.id}',
              child: bubble,
            ),
    );
  }

  int get scorePercent => (match.percentage * 100).floor();
  String getScoreString() => '$scorePercent% match';

  String scoreText() => challenge.isCorrect(match.type)
      ? match.type.scoringString
      : match.type.mistakeString;
}
