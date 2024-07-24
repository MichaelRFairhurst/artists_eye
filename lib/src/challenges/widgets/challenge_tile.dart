import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:flutter/material.dart';
import 'package:artists_eye/src/util/widgets/changing_color.dart';

class ChallengeTile extends StatelessWidget {
  const ChallengeTile({
    required this.name,
	this.tileColorEffect = ColorEffect.none,
	this.rightColorEffect = ColorEffect.none,
    super.key,
  });

  final String name;
  final ColorEffect tileColorEffect;
  final ColorEffect rightColorEffect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: ChangingColors(
          builder: (context, colorLeft, colorRight, _) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                gradient: LinearGradient(
                  colors: [colorLeft, rightColorEffect.perform(colorRight)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: tileColorEffect.perform(Color.lerp(colorLeft, colorRight, 0.6)!),
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
            );
          },
        ),
      ),
    );
  }
}
