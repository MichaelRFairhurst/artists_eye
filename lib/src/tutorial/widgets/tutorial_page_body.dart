import 'package:artists_eye/src/tutorial/widgets/tutorial.dart';
import 'package:artists_eye/src/util/widgets/fade_in.dart';
import 'package:flutter/material.dart';

class TutorialPageBody extends StatelessWidget {
  const TutorialPageBody({
    required this.parts,
    this.defaultReadTime = const Duration(milliseconds: 1500),
    super.key,
  });

  final List<Widget> parts;
  final Duration defaultReadTime;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var delay = Duration.zero;

    for (var i = 0; i < parts.length; ++i) {
      final widget = parts[i];
      if (i != 0) {
        children.add(const SizedBox(height: 24));
      }

      if (i == 0 || widget is ShowImmediately) {
        children.add(parts[i]);
      } else {
        children.add(FadeIn(
          delay: delay,
          child: parts[i],
        ));
      }

      delay +=
          widget is ReadTime ? widget.duration : const Duration(seconds: 2);
    }

    final currentPage = CurrentTutorialPage.of(context);

    return Scaffold(
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...children,
            const Spacer(),
            Row(
              children: [
                if (currentPage.isFirst)
                  ElevatedButton(
                    onPressed: () {
                      Tutorial.of(context)!.skip();
                    },
                    child: const Text('skip tutorial'),
                  ),
                const Spacer(),
                FadeIn(
                  delay: delay,
                  child: ElevatedButton(
                    onPressed: () {
                      Tutorial.of(context)!.next();
                    },
                    child: CurrentTutorialPage.of(context).hasNext
                        ? const Text('next')
                        : const Text('start playing'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReadTime extends StatelessWidget {
  const ReadTime({
    required this.duration,
    required this.child,
    super.key,
  });

  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class ShowImmediately extends StatelessWidget {
  const ShowImmediately({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class Group extends StatelessWidget {
  const Group(this.children, {super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; ++i)
          if (i == 0)
            children[i]
          else ...[
            const SizedBox(height: 24),
            children[i],
          ],
      ],
    );
  }
}
