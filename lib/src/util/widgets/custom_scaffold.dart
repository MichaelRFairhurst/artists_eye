import 'package:artists_eye/src/util/widgets/changing_color.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    required this.body,
    super.key,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ChangingColor(
              builder: (context, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.transparent,
                            animation.value!.withOpacity(0.25),
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
              },
            ),
          ),
          Positioned.fill(
            child: body,
          ),
        ],
      ),
    );
  }
}
