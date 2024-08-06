const perfectMatchGTE = 1.00;
const excellentMatchGTE = 0.97;
const goodMatchGTE = 0.9;

class Score {
  int _perfect = 0;
  int _excellent = 0;
  int _good = 0;
  int _total = 0;
  double _sum = 0.0;
  DateTime? _start;
  DateTime? _end;

  double get averageMatch => _total == 0 ? 1 : _sum / _total;
  int get perfect => _perfect;
  int get excellent => _excellent;
  int get good => _good;
  int get correct => perfect + excellent + good;
  int get incorrect => _total - correct;
  int get total => _total;
  Duration get time => _end!.difference(_start!);

  void start() {
    _start = DateTime.now();
  }

  void end() {
    _end = DateTime.now();
  }

  bool addMatch(double match) {
    _total++;
    _sum += match;

    if (match >= perfectMatchGTE) {
      _perfect++;
      return true;
    } else if (match >= excellentMatchGTE) {
      _excellent++;
      return true;
    } else if (match >= goodMatchGTE) {
      _good++;
      return true;
    }

    return false;
  }
}
