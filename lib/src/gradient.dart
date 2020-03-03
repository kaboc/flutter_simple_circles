part of 'circle.dart';

abstract class _Gradient {
  static Gradient radial(
    List<Color> colors,
    List<double> stops,
  ) =>
      _Radial(colors, stops).gradient;

  static Gradient sweep(
    List<Color> colors,
    List<double> stops,
    double begin,
    double end,
  ) =>
      _Sweep(colors, stops, begin, end).gradient;

  static Gradient line(
    List<Color> colors,
    List<double> stops,
    double width,
    double height,
    Degree degree,
    double begin,
    double end,
  ) =>
      _Line(colors, stops, width, height, degree, begin, end).gradient;

  static Gradient linear(
    List<Color> colors,
    List<double> stops,
    double width,
    double height,
    Degree degree,
  ) =>
      _Linear(colors, stops, width, height, degree).gradient;

  Gradient get gradient;
}

class _Radial extends _Gradient {
  _Radial(
    List<Color> colors,
    List<double> stops,
  ) {
    _gradient = RadialGradient(colors: colors, stops: stops);
  }

  Gradient _gradient;

  @override
  Gradient get gradient => _gradient;
}

class _Sweep extends _Gradient {
  _Sweep(
    List<Color> colors,
    List<double> stops,
    double begin,
    double end,
  ) {
    final double b = begin;
    final double e = end;

    final Degree smaller = Degree(min(b, e));
    final Degree larger = Degree(max(b, e));

    _gradient = SweepGradient(
      colors: e < b ? colors.reversed.toList() : colors,
      stops: stops,
      startAngle: 0,
      endAngle: larger.tiltedRadian() - smaller.tiltedRadian(),
      transform: GradientRotation(smaller.tiltedRadian()),
    );
  }

  Gradient _gradient;

  @override
  Gradient get gradient => _gradient;
}

class _Line extends _Gradient {
  _Line(
    List<Color> colors,
    List<double> stops,
    double width,
    double height,
    Degree degree,
    double begin,
    double end,
  ) {
    final double baseDistance = width / 2 * end / 100 - width / 2 * begin / 100;
    final Offset offset1 = degree.offsetAtDistance(width, height, begin);
    final Offset offset2 = degree.offsetAtDistance(width, height, end);
    final double distance = sqrt(
      pow(offset2.dx - offset1.dx, 2) + pow(offset2.dy - offset1.dy, 2),
    );
    final double ratio = distance / baseDistance;

    _gradient = LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment(begin * ratio / -100, 0.0),
      end: Alignment(end * ratio / -100, 0.0),
      transform: GradientRotation(
        (degree + const Degree(180.0)).forOval(width, height).tiltedRadian(),
      ),
    );
  }

  Gradient _gradient;

  @override
  Gradient get gradient => _gradient;
}

class _Linear extends _Gradient {
  _Linear(
    List<Color> colors,
    List<double> stops,
    double width,
    double height,
    Degree degree,
  ) {
    degree += const Degree(180.0);

    final Offset offset = degree.offsetOnArc(width, height);
    final double distance = sqrt(pow(offset.dx, 2) + pow(offset.dy, 2));
    final double ratio = distance / (width / 2);

    _gradient = LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment(ratio * -1.0, 0.0),
      end: Alignment(ratio, 0.0),
      transform: GradientRotation(degree.tiltedRadian()),
    );
  }

  Gradient _gradient;

  @override
  Gradient get gradient => _gradient;
}
