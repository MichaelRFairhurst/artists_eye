import 'dart:math';
import 'package:artists_eye/src/color/models/primary.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';

class PositionedAround extends StatelessWidget {
  const PositionedAround({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox.square(
          dimension: constraints.maxWidth,
          child: Stack(
            children: [
              for (var i = 0; i < children.length; ++i)
                childAt(i, constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }

  Widget childAt(int i, double dim) {
    final radius = dim / 2 - circleSize / 2;
    final child = children[i];
    return Positioned(
      top:
          sin(2 * pi * i / children.length) * radius + dim / 2 - circleSize / 2,
      left:
          cos(2 * pi * i / children.length) * radius + dim / 2 - circleSize / 2,
      child: child,
    );
  }
}

const circleSize = 52.0;

class ComplimentaryTutorialP2 extends StatelessWidget {
  const ComplimentaryTutorialP2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'These three colors can be arranged in a circle, equal distance from'
          ' each other.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Center(
          child: SizedBox(
            width: 200,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(circleSize / 2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(
                          color: Colors.grey,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: PositionedAround(
                    children: [
                      heroCircle(softRed),
                      FadeIn(
                        delay: const Duration(seconds: 1),
                        child: heroCircle(softYellow),
                      ),
                      heroCircle(softGreen),
                      FadeIn(
                        delay: const Duration(seconds: 1),
                        child: heroCircle(softCyan),
                      ),
                      heroCircle(softBlue),
                      FadeIn(
                        delay: const Duration(seconds: 1),
                        child: heroCircle(softMagenta),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FadeIn(
          delay: const Duration(seconds: 3),
          child: Text(
            'All color tones exist somewhere along this ring, called the color wheel.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('p3');
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
