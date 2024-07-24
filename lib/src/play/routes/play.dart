import 'package:flutter/material.dart';

class Play extends StatelessWidget {
  const Play({super.key});

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
          const Text('Match the color:'),
          Align(
            alignment: Alignment.centerRight,
            child: Hero(
              tag: 'findme',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(42),
                  color: Colors.red,
                ),
                child: const SizedBox(
                  height: 100,
                  width: 100,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Expanded(
            child: Hero(
              tag: 'gradient',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(42.0)),
                  gradient: LinearGradient(colors: [
                    Colors.red,
                    Colors.black,
                  ]),
                ),
              ),
            ),
          ),
        ].reversed.toList(),
      ),
    );
  }
}
