import 'package:flutter/material.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({
    required this.color,
    required this.text,
    this.height = 100,
    this.width = 110,
	this.heroTag = 'thumb',
    super.key,
  });

  final double height;
  final double width;
  final Color color;
  final String text;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
	  tag: heroTag,
	child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(height),
          bottomLeft: Radius.circular(height),
        ),
        color: color,
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: height,
            height: height,
            child: Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
      ),
	  ),
    );
  }
}
