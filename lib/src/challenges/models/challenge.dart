import 'package:artists_eye/src/challenges/models/record_history.dart';
import 'package:artists_eye/src/color/models/color_effect.dart';
import 'package:artists_eye/src/play/models/score.dart';

class Challenge {
  Challenge({
	required this.name,
	required this.id,
    required this.time,
    required this.goal,
    required this.maxMistakes,
	this.isWheel = false,
	this.tilePreviewEffect = ColorEffect.none,
	this.rightColorPreviewEffect = ColorEffect.none,
  }) : recordHistory = RecordHistory(
    mistakesAllowed: maxMistakes,
  );

  final String name;
  final String id;
  final Duration time;
  final bool isWheel;
  final int goal;
  final int maxMistakes;
  final RecordHistory recordHistory;

  final ColorEffect tilePreviewEffect;
  final ColorEffect rightColorPreviewEffect;

  bool isWin(Score score) {
    return score.correct >= goal && score.incorrect <= maxMistakes;
  }

  bool finished(Score score) {
	return score.correct >= goal || score.incorrect >= maxMistakes;
  }

  List<RecordValue> getNewRecords(Score newScore) {
	if (!isWin(newScore)) {
	  return const [];
	}
	return recordHistory.getNewRecords(newScore);
  }
}
