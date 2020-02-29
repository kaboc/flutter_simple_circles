import 'package:meta/meta.dart';

import 'cap.dart';
import 'enums.dart';

class CircleStyle {
  const CircleStyle._({
    @required this.type,
    @required this.begin,
    @required this.end,
    this.strokeWidth,
    this.length,
    this.step,
    double endStrokeWidth,
    RoundCap round,
  })  : assert(type != null),
        assert(begin != null),
        assert(end != null),
        assert((strokeWidth == null && endStrokeWidth == null) ||
            strokeWidth > 0.0),
        assert(endStrokeWidth == null || endStrokeWidth > 0.0),
        assert(length == null || length > 0.0),
        assert(step == null || step > 0.0),
        endStrokeWidth = endStrokeWidth ?? strokeWidth,
        round = round ?? RoundCap.none,
        degree = null;

  const CircleStyle._line({
    @required this.type,
    @required this.degree,
    @required this.begin,
    @required this.end,
    this.strokeWidth,
    this.length,
    this.step,
    double endStrokeWidth,
    RoundCap round,
  })  : assert(type != null),
        assert(degree != null),
        assert(begin != null),
        assert(end != null),
        assert((strokeWidth == null && endStrokeWidth == null) ||
            strokeWidth > 0.0),
        assert(endStrokeWidth == null || endStrokeWidth > 0.0),
        assert(length == null || length > 0.0),
        assert(step == null || step > 0.0),
        endStrokeWidth = endStrokeWidth ?? strokeWidth,
        round = round ?? RoundCap.none;

  const CircleStyle.stroke({
    double begin = 0.0,
    double end = 360.0,
    double strokeWidth = 1.0,
    RoundCap round,
  }) : this._(
          type: CircleStyleType.stroke,
          begin: begin,
          end: end,
          strokeWidth: strokeWidth,
          round: round,
        );

  const CircleStyle.fill({
    double begin = 0.0,
    double end = 360.0,
  }) : this._(
          type: CircleStyleType.fill,
          begin: begin,
          end: end,
        );

  const CircleStyle.dashed({
    double begin = 0.0,
    double end = 360.0,
    double strokeWidth = 1.0,
    double length = 1.0,
    double step = 10.0,
  }) : this._(
          type: CircleStyleType.dashed,
          begin: begin,
          end: end,
          strokeWidth: strokeWidth,
          length: length,
          step: step,
        );

  const CircleStyle.dotted({
    double begin = 0.0,
    double end = 360.0,
    double strokeWidth = 1.0,
    double endStrokeWidth,
    double step = 10.0,
  }) : this._(
          type: CircleStyleType.dotted,
          begin: begin,
          end: end,
          strokeWidth: strokeWidth,
          endStrokeWidth: endStrokeWidth ?? strokeWidth,
          step: step,
        );

  const CircleStyle.line({
    double degree = 0.0,
    double begin = -100.0,
    double end = 100.0,
    double strokeWidth = 1.0,
    RoundCap round,
  }) : this._line(
          type: CircleStyleType.line,
          degree: degree,
          begin: begin,
          end: end,
          strokeWidth: strokeWidth,
          round: round,
        );

  const CircleStyle.dashedLine({
    double degree = 0.0,
    double begin = -100.0,
    double end = 100.0,
    double strokeWidth = 1.0,
    double length = 1.0,
    double step = 10.0,
  }) : this._line(
          type: CircleStyleType.dashedLine,
          degree: degree,
          begin: begin,
          end: end,
          strokeWidth: strokeWidth,
          length: length,
          step: step,
        );

  const CircleStyle.dottedLine({
    double degree = 0.0,
    double begin = -100.0,
    double end = 100.0,
    double strokeWidth = 1.0,
    double endStrokeWidth,
    double step = 10.0,
  }) : this._line(
          type: CircleStyleType.dottedLine,
          degree: degree,
          begin: begin,
          end: end,
          strokeWidth: strokeWidth,
          endStrokeWidth: endStrokeWidth ?? strokeWidth,
          step: step,
        );

  final CircleStyleType type;
  final double begin;
  final double end;
  final double degree;
  final double length;
  final double strokeWidth;
  final double endStrokeWidth;
  final double step;
  final RoundCap round;
}
