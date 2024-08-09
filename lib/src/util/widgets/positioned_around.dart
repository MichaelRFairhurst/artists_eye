import 'dart:math';

import 'package:flutter/material.dart';

/// A widget to circularly place its children within the available space.
///
/// Used by the tutorial for color wheel visuals. Currently only handles
/// positioning children of a known size (set by [childSize]). Coded in a way
/// that is compatible with Hero animations.
class PositionedAround extends StatelessWidget {
  const PositionedAround({
    required this.children,
    required this.childSize,
    super.key,
  });

  final List<Widget> children;
  final double childSize;

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
    final radius = dim / 2 - childSize / 2;
    final child = children[i];
    return Positioned(
      top: sin(2 * pi * i / children.length) * radius + dim / 2 - childSize / 2,
      left:
          cos(2 * pi * i / children.length) * radius + dim / 2 - childSize / 2,
      child: child,
    );
  }
}
