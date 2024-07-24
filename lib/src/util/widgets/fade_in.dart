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
  bool showing = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.delay).then((_) {
      setState(() {
        showing = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    route!.animation?.addListener(() {
      if (route.animation!.isCompleted != showing) {
        setState(() {
          showing = !showing;
        });
      }
    });
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: showing ? 1.0 : 0.0,
      child: widget.child,
    );
  }
}
