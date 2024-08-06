import 'dart:ui' show lerpDouble;
import 'dart:math';
import 'package:flutter_color_models/flutter_color_models.dart';

class Cam16Parameters {
  const Cam16Parameters.custom({
    required this.whitepoint,
    required this.adaptingLuminance,
    required this.backgroundLuminance,
    required this.surround,
    required this.discounting,
  });

  static const defaults = Cam16Parameters.custom(
    whitepoint: d65,
    adaptingLuminance: 40,
    backgroundLuminance: 20,
    surround: surroundAverage,
    discounting: false,
  );

  static const d65 = XyzColor(0.9504, 1.0000, 1.0888);
  static const d50 = XyzColor(0.9642, 1.0000, 0.8251);

  static const surroundDark = 0.0;
  static const surroundDim = 1.0;
  static const surroundAverage = 2.0;

  final XyzColor whitepoint;

  // Luminance L_A
  final double adaptingLuminance;

  // Y_b; relaive to Y_w = 100
  final double backgroundLuminance;

  // Number for 0 to 2
  final double surround;

  final bool discounting;
}

class Cam16Color {
  // Lightness
  final double j;

  // chroma
  final double c;

  // hue
  final double h;

  // brightness
  final double q;

  // colorfulness
  final double m;

  // saturation
  final double s;

  const Cam16Color({
    required this.j,
    required this.c,
    required this.h,
    required this.q,
    required this.m,
    required this.s,
  });

  factory Cam16Color.fromXYZ(XyzColor xyz,
      [Cam16Parameters params = Cam16Parameters.defaults]) {
    // https://observablehq.com/@jrus/cam16
    List<double> elemMul(List<double> a, List<double> b) =>
        List.generate(a.length, (i) => a[i] * b[i]);

    List<double> m16(XyzColor xyz) => [
          0.401288 * xyz.x + 0.650173 * xyz.y - 0.051461 * xyz.z,
          -0.250268 * xyz.x + 1.204414 * xyz.y + 0.045854 * xyz.z,
          -0.002079 * xyz.x + 0.048952 * xyz.y + 0.953127 * xyz.z
        ];

    double clip(double a, double b, double t) => min(max(t, a), b);

    double degrees(double rads) => (rads * (180 / pi)) % 360;

    final xyzW = params.whitepoint;
    final yW = xyzW.y;
    final lA = params.adaptingLuminance;
    final yB = params.backgroundLuminance;

    final k = 1 / (5 * lA + 1);
    final k4 = k * k * k * k;
    final fL = // Luminance adaptation factor
        (k4 * lA + 0.1 * (1 - k4) * (1 - k4) * pow(5 * lA, 1 / 3));
    final fL4 = pow(fL, 0.25);

    final c = params.surround >= 1
        ? lerpDouble(0.59, 0.69, params.surround - 1)!
        : lerpDouble(0.525, 0.59, params.surround)!;

    final n = yB / yW;

    final nbb = 0.725 * pow(n, -0.2); // Chromatic induction factors
    final z =
        1.48 + sqrt(n); // Lightness non-linearity exponent (modified by `c`)

    final f = c >= 0.59
        ? lerpDouble(0.9, 1.0, (c - 0.59) / .1)!
        : lerpDouble(0.8, 0.9, (c - 0.525) / 0.065)!;

    double adapt(double component) {
      final x = pow(fL * component.abs() * 0.01, 0.42);
      return component.sign * 400 * x / (x + 27.13);
    }

    // Illuminant discounting (adaptation). Fully adapted = 1
    final d = !params.discounting
        ? clip(0, 1, f * (1 - 1 / 3.6 * exp((-lA - 42) / 92)))
        : 1.0;

    final wRgb = m16(xyzW); // Cone responses of the white point
    final dRgb = wRgb.map((cW) => lerpDouble(1, yW / cW, d)!).toList();

    final cwRgb = [wRgb[0] * dRgb[0], wRgb[1] * dRgb[1], wRgb[2] * dRgb[2]];

    final awRgb = cwRgb.map(adapt).toList();
    final aw = nbb * (2 * awRgb[0] + awRgb[1] + 0.05 * awRgb[2]);

    final aRgb = elemMul(m16(xyz), dRgb).map(adapt).toList();
    final rA = aRgb[0];
    final gA = aRgb[1];
    final bA = aRgb[1];
    final a = rA + (-12 * gA + bA) / 11; // redness-greenness
    final b = (rA + gA - 2 * bA) / 9; // yellowness-blueness
    final hRad = atan2(b, a); // hue in radians
    final h = degrees(hRad); // hue in degrees
    final eT = 0.25 * (cos(hRad + 2) + 3.8);
    final A = nbb * (2 * rA + gA + 0.05 * bA);
    final jRoot = pow(A / aw, 0.5 * c * z);
    final J = 100.0 * jRoot * jRoot; // lightness
    final Q = (4 / c * jRoot * (aw + 4) * fL4); // brightness
    final t = (5e4 /
        13 *
        f *
        nbb *
        eT *
        sqrt(a * a + b * b) /
        (rA + gA + 1.05 * bA + 0.305));
    final alpha = pow(t, 0.9) * pow(1.64 - pow(0.29, n), 0.73).toDouble();
    final C = alpha * jRoot; // chroma
    final M = C * fL4; // colorfulness
    final s = 50 * sqrt(c * alpha / (aw + 4)); // saturation
    return Cam16Color(j: J, c: C, h: h, q: Q, m: M, s: s);
  }

  double _radians(double degrees) => (degrees % 360) * (pi / 180);

  double get jUcs => 1.7 * j / (1 + 0.007 * j);
  double get a => m * cos(_radians(h));
  double get b => m * sin(_radians(h));

  double distanceTo(Cam16Color other) {
    final dJ = jUcs - other.jUcs, da = a - other.a, db = b - other.b;
    return 1.41 * pow(dJ * dJ + da * da + db * db, 0.315);
  }
}
