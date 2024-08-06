import 'package:artists_eye/src/color/models/match_type.dart';
import 'package:artists_eye/src/play/models/score.dart';

class Difficulty {
  const Difficulty({
    required this.goal,
    required this.allowedMistakes,
    required this.requiredMatch,
    required this.searchWidth,
  });

  final int goal;
  final int allowedMistakes;
  final MatchType requiredMatch;
  final double searchWidth;

  bool isWin(Score score) =>
      score.correct(this) >= goal && score.incorrect(this) <= allowedMistakes;

  bool finished(Score score) =>
      score.correct(this) >= goal || score.incorrect(this) >= allowedMistakes;

  bool isCorrect(MatchType matchType) => matchType >= requiredMatch;
}

const easy = Difficulty(
  goal: 8,
  allowedMistakes: 5,
  requiredMatch: goodMatch,
  searchWidth: 1.0,
);

const medium = Difficulty(
  goal: 10,
  allowedMistakes: 5,
  requiredMatch: greatMatch,
  searchWidth: 1.0,
);

const hard = Difficulty(
  goal: 12,
  allowedMistakes: 5,
  requiredMatch: excellentMatch,
  searchWidth: 1.0,
);
