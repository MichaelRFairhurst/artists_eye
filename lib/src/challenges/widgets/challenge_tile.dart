import 'package:artists_eye/src/challenges/widgets/hero_background_gradient.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/play/routes/play.dart';
import 'package:flutter/material.dart';
import 'package:artists_eye/src/util/widgets/changing_color.dart';

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    required this.name,
    required this.id,
    this.tileColorEffect = ColorEffect.none,
    this.rightColorEffect = ColorEffect.none,
    super.key,
  });

  final String name;
  final String id;
  final ColorEffect tileColorEffect;
  final ColorEffect rightColorEffect;

  Widget background(Color colorLeft, Color colorRight) {
    return HeroBackgroundGradient(
      tag: 'gradient$id',
      colorLeft: colorLeft,
      colorRight: colorRight,
      borderRadius: 42,
      rightColorEffect: rightColorEffect,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: ChangingColors(
        builder: (context, colorLeft, colorRight, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: background(colorLeft, colorRight),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(42),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 1),
                          reverseTransitionDuration: const Duration(seconds: 1),
                          pageBuilder: (_, __, ___) => Play(
                            challengeId: id,
                            colorLeft: colorLeft,
                            colorRight: colorRight,
                            isWheel: name == 'Color Wheel',
                          ),
                        ));
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Hero(
                          tag: 'findme$id',
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              color: tileColorEffect.perform(
                                  Color.lerp(colorLeft, colorRight, 0.6)!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const SizedBox(
                              height: 80,
                              width: 80,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
