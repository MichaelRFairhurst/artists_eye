import 'package:artists_eye/src/color/models/primary.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial_circle.dart';
import 'package:artists_eye/src/tutorial/widgets/tutorial_page_body.dart';
import 'package:flutter/material.dart';

class ComplimentaryTutorialP3 extends StatelessWidget {
  const ComplimentaryTutorialP3({super.key});

  @override
  Widget build(BuildContext context) {
    return TutorialPageBody(
      parts: [
        const Text(
          'Colors on opposite sides of the color wheel are called'
          ' "complimentary colors."',
        ),
        ShowImmediately(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              complimentRow(context, softRed, 'red', softCyan, 'cyan'),
              const SizedBox(height: 12),
              complimentRow(
                  context, softGreen, 'green', softMagenta, 'magenta'),
              const SizedBox(height: 12),
              complimentRow(context, softBlue, 'blue', softYellow, 'yellow'),
            ],
          ),
        ),
        const Text(
          'These colors have many useful properties. For example,'
          ' they always add up to grey.',
        ),
        const Text('Memorize these three pairs and then practice them here!'),
      ],
    );
  }

  Widget complimentRow(
    BuildContext context,
    Color color1,
    String color1str,
    Color color2,
    String color2str,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TutorialCircle(color1, text: color1str, isHero: true),
          const Text('is opposite'),
          TutorialCircle(color2, text: color2str, isHero: true),
        ],
      );
}
