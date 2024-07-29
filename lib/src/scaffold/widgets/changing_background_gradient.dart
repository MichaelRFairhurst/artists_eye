import 'package:artists_eye/src/util/widgets/changing_color.dart';
import 'package:flutter/material.dart';

class ChangingBackgroundGradient extends StatelessWidget {
  const ChangingBackgroundGradient({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangingColors(
      builder: (context, colorLeft, colorRight, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[100]!,
                colorRight.withOpacity(0.1),
                colorRight.withOpacity(0.25),
              ],
              stops: const [
                0.0,
                0.4,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}
