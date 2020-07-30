import 'dart:math';
import 'dart:ui';
import 'package:meta/meta.dart';

@immutable
class Degree {
  const Degree(this.value) : assert(value != null);

  final double value;

  @override
  String toString() => value.toString();

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is Degree && value == other.value);

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode;

  Degree operator +(Object other) {
    if (other is Degree) {
      return Degree(value + other.value);
    } else if (other is num) {
      return Degree(value + other);
    }
    return null;
  }

  Degree operator -(Object other) {
    if (other is Degree) {
      return Degree(value - other.value);
    } else if (other is num) {
      return Degree(value - other);
    }
    return null;
  }

  Degree operator *(Object other) {
    if (other is Degree) {
      return Degree(value * other.value);
    } else if (other is num) {
      return Degree(value * other);
    }
    return null;
  }

  Degree operator /(Object other) {
    if (other is Degree) {
      return Degree(value / other.value);
    } else if (other is num) {
      return Degree(value / other);
    }
    return null;
  }

  bool operator >(Object other) =>
      (other is Degree && value > other.value) ||
      (other is num && value > other);

  bool operator <(Object other) =>
      (other is Degree && value < other.value) ||
      (other is num && value < other);

  double radian() {
    return value * pi / 180.0;
  }

  double tiltedRadian() {
    return value * pi / 180.0 - pi / 2;
  }

  Offset offsetOnArc(
    double width,
    double height, [
    Offset center = const Offset(0.0, 0.0),
  ]) {
    final rad = tiltedRadian();
    return Offset(
      center.dx + width / 2 * cos(rad),
      center.dy + height / 2 * sin(rad),
    );
  }

  Offset offsetAtDistance(
    double width,
    double height,
    double distance, [
    Offset center = const Offset(0.0, 0.0),
  ]) {
    return offsetOnArc(
      width * distance / 100,
      height * distance / 100,
      center,
    );
  }

  double distance(double width, double height) {
    final offset = offsetOnArc(width, height);
    return sqrt(pow(offset.dx, 2) + pow(offset.dy, 2));
  }

  double arcLength(double width, double height) {
    return value * _circumference(width, height) / 360.0;
  }

  Degree forOval(double width, double height) {
    final offset1 = offsetAtDistance(width, height, 0.0);
    final offset2 = offsetAtDistance(width, height, 100.0);
    return fromOffsets(offset1, offset2);
  }

  Degree forOvalArc(double width, double height) {
    final offset1 = offsetOnArc(width, height);
    final offset2 = Degree(value + 0.01).offsetOnArc(width, height);
    return fromOffsets(offset1, offset2) - 90.0;
  }

  static Degree fromRadian(double radian) {
    return Degree(radian / pi * 180.0);
  }

  static Degree fromLength(double width, double height, double length) {
    return Degree(length * 360.0 / _circumference(width, height));
  }

  static Degree fromOffsets(Offset offset1, Offset offset2) {
    final rad = atan2(offset2.dy - offset1.dy, offset2.dx - offset1.dx);
    return fromRadian(rad) + 90.0;
  }

  static double _circumference(double width, double height) {
    if (width == height) {
      return 2 * pi * width;
    }
    return 2 * pi * sqrt((pow(width, 2) + pow(height, 2)) / 2);
  }
}
