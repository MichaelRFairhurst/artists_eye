import 'package:artists_eye/src/play/models/score.dart';

enum RecordKind {
  fastestTime,
  mostExcellent,
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

  List<RecordValue> getNewRecords(Score newScore) => [
        if (fastestTime.adopt(newScore.time)) fastestTime,
        if (mostExcellent.adopt(newScore.excellent)) mostExcellent,
        if (mostPerfect.adopt(newScore.perfect)) mostPerfect,
        if (fewestMistakes.adopt(newScore.incorrect)) fewestMistakes,
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
