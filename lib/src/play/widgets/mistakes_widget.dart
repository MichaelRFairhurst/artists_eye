import 'package:flutter/material.dart';

class MistakesWidget extends StatelessWidget {
  const MistakesWidget({
    required this.mistakes,
    required this.allowedMistakes,
	this.noMistakeColor = const Color(0xFFE8E8E8),
	this.mistakeColor = Colors.red,
	this.newMistakeFadeInDuration = const Duration(milliseconds: 1200),
	this.newMistakeCurve = Curves.bounceIn,
    super.key,
  });

  final Duration newMistakeFadeInDuration;
  final Curve newMistakeCurve;
  final Color noMistakeColor;
  final Color mistakeColor;
  final int mistakes;
  final int allowedMistakes;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          for (var i = 0; i < allowedMistakes; ++i)
			getX(i),
        ],
      ),
    );
  }

  Widget getX(int i) {
	final Widget x;
	if (i == mistakes - 1) {
	  final colorTween = ColorTween(
		begin: noMistakeColor,
		end: mistakeColor,
	  );

	  x = TweenAnimationBuilder(
	    duration: newMistakeFadeInDuration,
		curve: newMistakeCurve,
	    tween: Tween(
		  begin: 0.0,
		  end: 1.0,
		),
		builder: (context, value, _) {
		  final color = colorTween.transform(value)!;
		  return Transform.scale(
		    scale: value,
		    child: xWithColor(color),
		  );
		}
	  );
	} else {
	  x = xWithColor(i < mistakes ? mistakeColor : noMistakeColor);
	}

	return Padding(
	  padding: const EdgeInsets.all(8.0),
	  child: x,
	);
  }

  Widget xWithColor(Color color) => Icon(Icons.close_rounded, color: color);
}
