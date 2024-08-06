import 'package:artists_eye/src/challenges/models/difficulty.dart';
import 'package:artists_eye/src/color/models/color_match.dart';
import 'package:artists_eye/src/color/models/match_type.dart';

class Score {
  /// How many matches are at least as good as a certain match type.
  ///
  /// For example, 3 excellent + 1 perfect = 4 matches that were excellent
  /// or better.
  final matchesInclusive = {
    for (final type in colorMatchTypes) type: 0,
  };

  /// How many matches are exactly described by a certain match type.
  ///
  /// See [_matchesInclusive]. This will not count a perfect match as an
  /// excellent match, for example.
  final _matchesExact = {
    for (final type in colorMatchTypes) type: 0,
  };

  /// Sum of all match percentages observed, so that we may compute an average
  double _sum = 0.0;

  /// When the round started.
  DateTime? _start;

  /// When the round ended.
  DateTime? _end;

  /// The average match score for this round.
  double get averageMatch => total == 0 ? 1 : _sum / total;

  /// How many matches were "correct" given a difficulty setting.
  int correct(Difficulty difficulty) =>
      matchesInclusive[difficulty.requiredMatch]!;

  /// How many matches were exactly of this type (e.g., [perfectMatch]).
  int matchesOfExactType(MatchType type) => _matchesExact[type]!;

  /// How many matches were "incorrect" given a difficulty setting.
  int incorrect(Difficulty difficulty) => total - correct(difficulty);

  /// Total matches observed.
  int get total => _matchesExact.values.reduce((a, b) => a + b);

  /// Time elapsed, assumes the round has ended.
  Duration get time => _end!.difference(_start!);

  /// Start the round.
  void start() {
    _start = DateTime.now();
  }

  /// End the round.
  void end() {
    _end = DateTime.now();
  }

  /// Report a match
  void addMatch(ColorMatch match) {
    _sum += match.percentage;

    for (final matchType in colorMatchTypes) {
      if (match.type == matchType) {
        _matchesExact.update(matchType, (v) => v + 1);
      }

      if (match.type >= matchType) {
        matchesInclusive.update(matchType, (v) => v + 1);
      }
    }
  }
}
