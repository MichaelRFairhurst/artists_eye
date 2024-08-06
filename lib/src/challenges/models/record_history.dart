import 'package:artists_eye/src/challenges/models/difficulty.dart';
import 'package:artists_eye/src/color/models/match_type.dart';
import 'package:artists_eye/src/play/models/score.dart';

enum RecordKind {
  fastestTime,
  mostExcellent,
  mostSuperb,
  mostPerfect,
  fewestMistakes,
  highestAverageMatch,
}

class RecordHistory {
  RecordHistory({
    required int mistakesAllowed,
  }) {
    fewestMistakes.value = mistakesAllowed;
  }

  final fastestTime = RecordValue<Duration>(
    kind: RecordKind.fastestTime,
    preferLower: true,
  );

  final mostExcellent = RecordValue<int>(
    kind: RecordKind.mostExcellent,
    value: 0,
    preferLower: false,
  );

  final mostSuperb = RecordValue<int>(
    kind: RecordKind.mostExcellent,
    value: 0,
    preferLower: false,
  );

  final mostPerfect = RecordValue<int>(
    kind: RecordKind.mostPerfect,
    value: 0,
    preferLower: false,
  );

  final fewestMistakes = RecordValue<int>(
    kind: RecordKind.fewestMistakes,
    preferLower: true,
  );

  final highestAverageMatch = RecordValue<double>(
    kind: RecordKind.highestAverageMatch,
    preferLower: false,
  );

  List<RecordValue> getNewRecords(Score newScore, Difficulty difficulty) => [
        if (fastestTime.adopt(newScore.time)) fastestTime,
        if (difficulty.isCorrect(excellentMatch) &&
            mostExcellent.adopt(newScore.matchesOfExactType(excellentMatch)))
          mostExcellent,
        if (mostSuperb.adopt(newScore.matchesOfExactType(superbMatch)))
          mostSuperb,
        if (mostPerfect.adopt(newScore.matchesOfExactType(perfectMatch)))
          mostPerfect,
        if (fewestMistakes.adopt(newScore.incorrect(difficulty)))
          fewestMistakes,
        if (highestAverageMatch.adopt(newScore.averageMatch))
          highestAverageMatch,
      ];
}

class RecordValue<T extends Comparable> {
  RecordValue({required this.kind, required this.preferLower, this.value});

  final RecordKind kind;
  final bool preferLower;
  T? value;

  bool adopt(T latest) {
    if (value == null) {
      value = latest;
      return true;
    }

    final cmp = latest.compareTo(value!);
    final better = cmp == (preferLower ? -1 : 1);
    if (better) {
      value = latest;
    }

    return better;
  }
}
