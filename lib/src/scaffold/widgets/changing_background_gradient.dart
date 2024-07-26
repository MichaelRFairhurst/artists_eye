import 'package:artists_eye/src/util/widgets/changing_color.dart';
import 'package:flutter/material.dart';

class ChangingBackgroundGradient extends StatelessWidget {
  const ChangingBackgroundGradient({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangingColor.valueBuilder(
      builder: (context, value, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                value.withOpacity(0.25),
              ],
              stops: const [
                0.2,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

