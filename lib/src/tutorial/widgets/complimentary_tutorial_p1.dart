import 'package:artists_eye/src/color/models/primary.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';

class ComplimentaryTutorialP1 extends StatelessWidget {
  const ComplimentaryTutorialP1({super.key});

  static const circleSize = 52.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Our eyes can see three primary colors: red, green, and blue.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            heroCircle(softRed),
            heroCircle(softGreen),
            heroCircle(softBlue),
          ],
        ),
        const SizedBox(height: 32),
        FadeIn(
          delay: const Duration(seconds: 2),
          child: Text(
            'Every color that we see is a combination of red, green, and blue light.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 24),
        FadeIn(
          delay: const Duration(seconds: 5),
          child: Text(
            'For instance:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 24),
        FadeIn(
          delay: const Duration(seconds: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              circle(softGreen),
              Text('+', style: Theme.of(context).textTheme.displaySmall),
              circle(softBlue),
              Text('=', style: Theme.of(context).textTheme.displaySmall),
              circle(softCyan),
            ],
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('p2');
            },
            child: const Text('next'),
          ),
        ),
      ],
    );
  }

  Widget heroCircle(Color color) => Hero(
        tag: color,
        child: circle(color),
      );

  Widget circle(Color color) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(circleSize),
          color: color,
        ),
        child: const SizedBox(
          width: circleSize,
          height: circleSize,
        ),
      );
}
