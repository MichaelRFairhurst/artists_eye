import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:flutter/material.dart';

class ToThumbWidget extends StatelessWidget {
  const ToThumbWidget({
    required this.color,
    required this.heroTag,
    super.key,
  });

  final Color color;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      flightShuttleBuilder: (_, animation, __, ___, ____) {
        return AnimatedBuilder(
          animation: animation,
          builder: (_, __) => buildAtProgress(animation.value),
        );
      },
      child: buildAtProgress(0),
    );
  }

  Widget buildAtProgress(double progress) {
    final radiusIn = Tween<double>(begin: 26, end: defaultThumbHeight / 2)
        .transform(progress);
    final radiusOut = Tween<double>(begin: 26, end: 0).transform(progress);
    final boxShadowOpacity =
        Tween<double>(begin: 0.5, end: 0).transform(progress);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusIn),
          bottomLeft: Radius.circular(radiusIn),
          topRight: Radius.circular(radiusOut),
          bottomRight: Radius.circular(radiusOut),
        ),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(boxShadowOpacity),
            offset: const Offset(2, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: const SizedBox(
        height: 80,
        width: 80,
      ),
    );
  }
}
