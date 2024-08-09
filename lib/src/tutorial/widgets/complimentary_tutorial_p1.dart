import 'package:artists_eye/src/color/models/primary.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial_circle.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial_page_body.dart';
import 'package:flutter/material.dart';

class ComplimentaryTutorialP1 extends StatelessWidget {
  const ComplimentaryTutorialP1({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialPageBody(
      parts: [
        const ReadTime(
          duration: Duration(seconds: 1),
          child: Group(
            [
              Text(
                'Our eyes can see three primary colors: red, green, and blue.',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TutorialCircle(softRed, isHero: true),
                  TutorialCircle(softGreen, isHero: true),
                  TutorialCircle(softBlue, isHero: true),
                ],
              ),
            ],
          ),
        ),
        const Text(
          'Every color that we see is a combination of red, green, and blue'
          ' light.',
        ),
        Group([
          const Text('For instance:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const TutorialCircle(softGreen),
              Text('+', style: Theme.of(context).textTheme.displaySmall),
              const TutorialCircle(softBlue),
              Text('=', style: Theme.of(context).textTheme.displaySmall),
              const TutorialCircle(softCyan),
            ],
          ),
        ]),
      ],
    );
  }
}
