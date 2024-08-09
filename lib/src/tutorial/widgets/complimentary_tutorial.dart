import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial_p1.dart';
import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial_p2.dart';
import 'package:artists_eye/src/tutorial/widgets/complimentary_tutorial_p3.dart';
import 'package:flutter/material.dart';

class ComplimentaryTutorial extends StatelessWidget {
  ComplimentaryTutorial({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Understanding the color wheel',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: 'p1',
			observers: [HeroController()],
            onGenerateRoute: (routeSettings) {
              if (routeSettings.name == 'p1') {
                return TutorialPageRoute(
                  builder: (_) => const ComplimentaryTutorialP1(),
                );
              } else if (routeSettings.name == 'p2') {
                return TutorialPageRoute(
                  builder: (_) => const ComplimentaryTutorialP2(),
                );
              } else if (routeSettings.name == 'p3') {
                return TutorialPageRoute(
                  builder: (_) => const ComplimentaryTutorialP3(),
                );
              }
              throw 'unreachable';
            },
          ),
        ),
      ],
    );
  }
}

class TutorialPageRoute extends MaterialPageRoute {
  TutorialPageRoute({
    required super.builder,
  });

  @override
  final Duration transitionDuration = const Duration(milliseconds: 500);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
