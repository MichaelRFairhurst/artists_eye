import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  const FadeIn({
    required this.child,
    this.delay = const Duration(seconds: 1),
    super.key,
  });

  final Widget child;
  final Duration delay;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.delay).then((_) {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: opacity,
      child: widget.child,
    );
  }
}
