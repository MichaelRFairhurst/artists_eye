import 'package:artists_eye/src/scaffold/widgets/changing_background_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/gradient_to_primary_area.dart';
import 'package:artists_eye/src/scaffold/widgets/primary_area_gradient.dart';
import 'package:artists_eye/src/scaffold/widgets/thumb_widget.dart';
import 'package:flutter/material.dart';

class ArtistsEyeScaffold extends StatefulWidget {
  const ArtistsEyeScaffold({
    required this.body,
    this.thumb,
    this.primaryAreaGradient,
    super.key,
  });

  final Widget? thumb;
  final Widget? primaryAreaGradient;
  final Widget body;

  @override
  ArtistsEyeScaffoldState createState() => ArtistsEyeScaffoldState();
}

class ArtistsEyeScaffoldState extends State<ArtistsEyeScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  Text("Artist's Eye",
                      style: Theme.of(context).appBarTheme.titleTextStyle),
                  const Spacer(),
                  if (widget.thumb != null) widget.thumb!,
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ChangingBackgroundGradient(),
                ),
                if (widget.primaryAreaGradient != null)
                  Positioned.fill(
                    child: widget.primaryAreaGradient!,
                  ),
                Positioned.fill(
                  child: widget.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ArtistsEyeScaffold(
      thumb: ThumbWidget(
        color: Colors.green[200]!,
        text: 'Find me!',
      ),
      primaryAreaGradient: PrimaryAreaGradient(
        heroTag: 'ignore',
        colorLeft: Colors.blue[400]!,
        colorRight: Colors.blue[200]!,
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: GradientToPrimaryArea(
            heroTag: 'hero',
            colorLeft: Colors.green[200]!,
            colorRight: Colors.green[400]!,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 3),
                  pageBuilder: (context, _, __) {
                    return ArtistsEyeScaffold(
                      primaryAreaGradient: PrimaryAreaGradient(
                        heroTag: 'hero',
                        colorLeft: Colors.green[200]!,
                        colorRight: Colors.green[400]!,
                      ),
                      thumb: ThumbWidget(
                        color: Colors.green[200]!,
                        text: 'Find me!',
                      ),
                      body: const SizedBox(),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
