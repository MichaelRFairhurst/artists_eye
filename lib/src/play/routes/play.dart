import 'package:artists_eye/src/color/widgets/color_wheel.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';

class Play extends StatelessWidget {
  const Play({
    required this.colorLeft,
    required this.colorRight,
    this.isWheel = false,
    super.key,
  });

  final bool isWheel;
  final Color colorLeft;
  final Color colorRight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artist's Eye"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Text('Match the color:',
                  style: Theme.of(context).textTheme.titleLarge),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 70,
                    height: 100,
                    child: OverflowBox(
                      minWidth: 200,
                      maxWidth: 200,
                      minHeight: 100,
                      maxHeight: 100,
                      child: Hero(
                        tag: 'findme',
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(42),
                            color: colorRight,
                          ),
                          child: SizedBox(
                            height: 100,
                            width: 200,
                            child: Center(
                              child: Text('Find me!',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: 'gradient',
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(42.0)),
                        gradient: LinearGradient(
                          begin: isWheel
                              ? Alignment.topCenter
                              : Alignment.centerLeft,
                          end: isWheel
                              ? Alignment.bottomCenter
                              : Alignment.centerRight,
                          colors: [
                            if (!isWheel) ...[
                              colorLeft,
                              colorRight,
                            ] else ...[
                              Colors.grey[200]!,
                              Colors.grey[100]!,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (isWheel)
                  const Positioned.fill(
                    child: FadeIn(
                      child: ColorWheel(),
                    ),
                  ),
              ],
            ),
          ),
        ].reversed.toList(),
      ),
    );
  }
}
