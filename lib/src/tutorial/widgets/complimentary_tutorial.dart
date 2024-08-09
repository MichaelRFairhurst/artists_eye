import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial_p1.dart';
import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial_p2.dart';
import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial_p3.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial.dart';
import 'package:flutter/material.dart';

class ComplimentaryTutorial extends StatelessWidget {
  const ComplimentaryTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return const Tutorial(
      title: 'Understanding the color wheel',
      pages: [
        ComplimentaryTutorialP1(),
        ComplimentaryTutorialP2(),
        ComplimentaryTutorialP3(),
      ],
    );
  }
}
