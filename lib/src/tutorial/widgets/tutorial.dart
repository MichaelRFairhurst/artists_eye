import 'package:flutter/material.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({
    required this.title,
    required this.pages,
    super.key,
  });

  final String title;
  final List<Widget> pages;

  static TutorialState? of(BuildContext context) {
    return context.findAncestorStateOfType<TutorialState>();
  }

  @override
  TutorialState createState() => TutorialState();
}

class TutorialState extends State<Tutorial> {
  var page = 0;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '0',
            observers: [HeroController()],
            onGenerateRoute: (routeSettings) {
              final number = int.parse(routeSettings.name!);
              return _TutorialPageRoute(
                builder: (context) => CurrentTutorialPage(
				  isFirst: number == 0,
                  hasNext: widget.pages.length > number + 1,
                  child: widget.pages[number],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool get hasNextPage => widget.pages.length > page + 1;

  void next() {
    if (hasNextPage) {
      ++page;

      _navigatorKey.currentState!.pushReplacementNamed(page.toString());
    } else {
      Navigator.of(context).pop();
    }
  }

  void skip() {
	Navigator.of(context).pop();
  }
}

class CurrentTutorialPage extends InheritedWidget {
  const CurrentTutorialPage({
    required this.hasNext,
	required this.isFirst,
    required super.child,
    super.key,
  });

  final bool isFirst;
  final bool hasNext;

  @override
  bool updateShouldNotify(CurrentTutorialPage oldWidget) =>
      hasNext != oldWidget.hasNext;

  static CurrentTutorialPage of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CurrentTutorialPage>()!;
}

class _TutorialPageRoute extends MaterialPageRoute {
  _TutorialPageRoute({
    required super.builder,
  });
  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInQuad),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutQuad))
            .animate(secondaryAnimation),
        child: child,
      ),
    );
  }
}
