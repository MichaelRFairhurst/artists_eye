import 'package:artists_eye/src/color/models/primary.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';

const circleSize = 52.0;

class ComplimentaryTutorialP3 extends StatelessWidget {
  const ComplimentaryTutorialP3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Colors on opposite sides of the color wheel are called "complimentary'
          ' colors."',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Text(
          'Complimentary colors have many useful properties. For example, they'
          ' always add up to grey:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        complimentRow(context, softRed, softCyan),
        const SizedBox(height: 6),
        complimentRow(context, softGreen, softMagenta),
        const SizedBox(height: 6),
        complimentRow(context, softBlue, softYellow),
        const SizedBox(height: 24),
        FadeIn(
          delay: const Duration(seconds: 3),
          child: Text(
            'Memorize these three pairs and then practice them in this'
            ' introductory challenge!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('p1');
            },
            child: const Text('next'),
          ),
        ),
      ],
    );
  }

  Widget complimentRow(BuildContext context, Color color1, Color color2) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          heroCircle(color1),
          Text('+', style: Theme.of(context).textTheme.titleLarge),
          heroCircle(color2),
          Text('=', style: Theme.of(context).textTheme.titleLarge),
          circle(Colors.grey),
        ],
      );
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
