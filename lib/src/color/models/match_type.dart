class MatchType {
  const MatchType._({
    required this.scoringString,
    required this.mistakeString,
    required this.threshold,
  });

  factory MatchType.fromDouble(double matchValue) {
    for (var i = 0; i <= colorMatchTypes.length; ++i) {
      if (colorMatchTypes[i].threshold <= matchValue) {
        return colorMatchTypes[i];
      }
    }

    assert(false);
    return notMatch;
  }

  final String scoringString;
  final String mistakeString;
  final double threshold;

  bool atLeast(MatchType other) => this >= other;

  bool operator >(MatchType other) => threshold > other.threshold;

  bool operator >=(MatchType other) => threshold >= other.threshold;

  bool operator <(MatchType other) => threshold < other.threshold;

  bool operator <=(MatchType other) => threshold <= other.threshold;
}

const perfectMatch =
    MatchType._(scoringString: 'perfect', mistakeString: '', threshold: 1.0);
const incredibleMatch = MatchType._(
    scoringString: 'incredible', mistakeString: '', threshold: 0.99);
const superbMatch = MatchType._(
    scoringString: 'superb', mistakeString: 'so close', threshold: 0.97);
const excellentMatch = MatchType._(
    scoringString: 'excellent', mistakeString: 'very close', threshold: 0.95);
const greatMatch = MatchType._(
    scoringString: 'great', mistakeString: 'close', threshold: 0.90);
const goodMatch = MatchType._(
    scoringString: 'good', mistakeString: 'almost', threshold: 0.80);
const notBadMatch = MatchType._(
    scoringString: 'not bad', mistakeString: 'not quite', threshold: 0.70);
const notMatch =
    MatchType._(scoringString: '', mistakeString: 'try again', threshold: 0.0);

const colorMatchTypes = [
  perfectMatch,
  incredibleMatch,
  superbMatch,
  excellentMatch,
  greatMatch,
  goodMatch,
  notBadMatch,
  notMatch,
];
