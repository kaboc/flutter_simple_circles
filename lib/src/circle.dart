import 'dart:math';
import 'package:flutter/widgets.dart';

import 'cap.dart';
import 'container.dart';
import 'degree.dart';
import 'enums.dart';
import 'stack.dart';
import 'style.dart';

part 'gradient.dart';
part 'shader.dart';

class Circle extends StatelessWidget {
  const Circle({
    Key key,
    this.width,
    this.height,
    this.colors,
    this.shader,
    this.maskFilter,
    this.style = const CircleStyle.stroke(begin: 0.0, end: 360.0),
  })  : assert(width == null || width > 0.0),
        assert(height == null || height > 0.0),
        super(key: key);

  final double width;
  final double height;
  final List<Color> colors;
  final Shader shader;
  final MaskFilter maskFilter;
  final CircleStyle style;

  @override
  Widget build(BuildContext context) {
    double w = width;
    double h = height;

    if (w == null || h == null) {
      final CircleContainer container = CircleContainer.of(context);
      if (container != null) {
        w ??= container.width;
        h ??= container.height;
      }
    }
    if (w == null || h == null) {
      final CircleStack stack = CircleStack.of(context);
      if (stack != null) {
        w ??= stack.width - stack.padding.horizontal;
        h ??= stack.height - stack.padding.vertical;
      }
    }

    return width == null && w == null
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return _paint(constraints.maxWidth, constraints.maxHeight);
            },
          )
        : _paint(w, h);
  }

  Widget _paint(double width, double height) {
    return CustomPaint(
      painter: _Painter(
        width: width,
        height: height,
        colors: colors == null || colors.isEmpty
            ? const <Color>[Color(0xFF000000)]
            : colors,
        shader: shader ?? const CircleShader.linearGradient(),
        maskFilter: maskFilter,
        style: style,
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({
    @required this.width,
    @required this.height,
    @required this.colors,
    @required this.shader,
    @required MaskFilter maskFilter,
    @required CircleStyle style,
  })  : _circlePaint = Paint()
          ..isAntiAlias = true
          ..maskFilter = maskFilter,
        type = style.type,
        begin = style.begin,
        end = style.end,
        degree = style.degree == null ? null : Degree(style.degree),
        strokeWidth = style.strokeWidth,
        endStrokeWidth = style.endStrokeWidth,
        length = style.length,
        step = style.step,
        round = style.round;

  final Paint _circlePaint;
  final double width;
  final double height;
  final List<Color> colors;
  final Shader shader;
  final CircleStyleType type;
  final double begin;
  final double end;
  final Degree degree;
  final double strokeWidth;
  final double endStrokeWidth;
  final double length;
  final double step;
  final RoundCap round;

  @override
  void paint(Canvas canvas, Size size) {
    if (type == CircleStyleType.stroke ||
        type == CircleStyleType.dashed ||
        type == CircleStyleType.line ||
        type == CircleStyleType.dashedLine) {
      _circlePaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
    }

    if (shader is CircleShader) {
      _setShader(shader as CircleShader);
    } else {
      _circlePaint.shader = shader;
    }

    switch (type) {
      case CircleStyleType.stroke:
        round == RoundCap.none
            ? _drawArc(canvas, begin, end)
            : _drawArcWithRoundEnds(canvas);
        break;
      case CircleStyleType.fill:
        _drawArc(canvas, begin, end);
        break;
      case CircleStyleType.dashed:
        _drawDash(canvas);
        break;
      case CircleStyleType.dotted:
        _drawDots(canvas);
        break;
      case CircleStyleType.line:
        round == RoundCap.none
            ? _drawLine(canvas, begin, end)
            : _drawLineWithRoundEnds(canvas);
        break;
      case CircleStyleType.dashedLine:
        _drawDashedLine(canvas);
        break;
      case CircleStyleType.dottedLine:
        _drawDottedLine(canvas);
        break;
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return true;
  }

  void _drawArc(Canvas canvas, double begin, double end) {
    canvas.drawArc(
      Rect.fromLTWH(0, 0, width, height),
      Degree(begin).adjustedRadian(),
      Degree(end - begin).radian(),
      type == CircleStyleType.fill,
      _circlePaint,
    );
  }

  void _drawArcWithRoundEnds(Canvas canvas) {
    if (strokeWidth <= 1.0) {
      _drawArc(canvas, begin, end);
      return;
    }

    final double capInset = Degree.fromLength(width, height, strokeWidth).value;

    bool bRounded = round == RoundCap.begin || round == RoundCap.both;
    final bool eRounded = round == RoundCap.end || round == RoundCap.both;

    final bool isClockwise = begin <= end;
    double b = bRounded ? begin + (isClockwise ? capInset : -capInset) : begin;
    double e = eRounded ? end - (isClockwise ? capInset : -capInset) : end;

    final Offset center = Offset(width / 2, height / 2);
    final double innerWidth = width - strokeWidth;
    final double innerHeight = height - strokeWidth;
    final double outerWidth = width + strokeWidth;
    final double outerHeight = height + strokeWidth;
    final double capRadius = strokeWidth / 2;

    final Degree Function(Degree, Offset, bool, bool) getEdgeDegree =
        (Degree d, Offset o, bool isOuter, bool isEnd) {
      Degree deg = isOuter
          ? Degree.fromOffsets(
              center,
              d
                  .forOvalArc(width, height)
                  .offsetOnArc(strokeWidth, strokeWidth, o),
            )
          : Degree.fromOffsets(
              center,
              (d + 180)
                  .forOvalArc(width, height)
                  .offsetOnArc(strokeWidth, strokeWidth, o),
            );

      if ((deg.value - d.value).abs() > 90.0) {
        deg += d < 0 ? -360.0 : 360.0;
      }

      return (isClockwise && isEnd) || (!isClockwise && !isEnd)
          ? Degree(min(d.value, deg.value))
          : Degree(max(d.value, deg.value));
    };

    Offset bOffset = Degree(b).offsetOnArc(width, height, center);
    Offset eOffset = Degree(e).offsetOnArc(width, height, center);

    Degree bInnerDegree = getEdgeDegree(Degree(b), bOffset, false, false);
    Degree bOuterDegree = getEdgeDegree(Degree(b), bOffset, true, false);
    Degree eInnerDegree = getEdgeDegree(Degree(e), eOffset, false, true);
    Degree eOuterDegree = getEdgeDegree(Degree(e), eOffset, true, true);

    if ((isClockwise && bInnerDegree > eInnerDegree) ||
        (!isClockwise && bInnerDegree < eInnerDegree)) {
      if (bRounded && eRounded) {
        bRounded = false;
        b = begin;

        bOffset = Degree(b).offsetOnArc(width, height, center);
        bInnerDegree = getEdgeDegree(Degree(b), bOffset, false, false);
        bOuterDegree = getEdgeDegree(Degree(b), bOffset, true, false);
      }

      if ((isClockwise && b > e) || (!isClockwise && b < e)) {
        e = b;
        eOffset = Degree(b).offsetOnArc(width, height, center);
        eInnerDegree = bInnerDegree;
        eOuterDegree = bOuterDegree;
      }
    }

    final Path path = Path();

    if (bRounded) {
      final double beginRad = Degree(b).radian();
      final double beginRadOnArc = Degree(b).forOvalArc(width, height).radian();
      final double beginCapRadius = cos(beginRad - beginRadOnArc) * capRadius;

      path.arcTo(
        Rect.fromCircle(center: bOffset, radius: beginCapRadius),
        Degree(b + 180.0).forOvalArc(width, height).adjustedRadian(),
        const Degree(180.0).radian() * (isClockwise ? 1.0 : -1.0),
        false,
      );
    }

    path.arcTo(
      Rect.fromLTWH(-capRadius, -capRadius, outerWidth, outerHeight),
      bOuterDegree.adjustedRadian(),
      (eOuterDegree - bOuterDegree).radian(),
      false,
    );

    if (eRounded) {
      final double endRad = Degree(e).radian();
      final double endRadOnArc = Degree(e).forOvalArc(width, height).radian();
      final double endCapRadius = cos(endRad - endRadOnArc) * capRadius;

      path.arcTo(
        Rect.fromCircle(center: eOffset, radius: endCapRadius),
        Degree(e).forOvalArc(width, height).adjustedRadian(),
        const Degree(180.0).radian() * (isClockwise ? 1.0 : -1.0),
        false,
      );
    }

    if ((isClockwise && bInnerDegree < eInnerDegree) ||
        (!isClockwise && bInnerDegree > eInnerDegree)) {
      path.arcTo(
        Rect.fromLTWH(capRadius, capRadius, innerWidth, innerHeight),
        eInnerDegree.adjustedRadian(),
        (bInnerDegree - eInnerDegree).radian(),
        false,
      );
    }

    _circlePaint.style = PaintingStyle.fill;
    canvas.drawPath(path, _circlePaint);
  }

  void _drawDash(Canvas canvas) {
    final Offset center = Offset(width / 2, height / 2);

    final Path path = Path();
    for (double d = begin; d < end; d += step) {
      final Offset from = Degree(d).offsetOnArc(width, height, center);
      final Offset to = Degree(d + length).offsetOnArc(width, height, center);
      path
        ..moveTo(from.dx, from.dy)
        ..arcToPoint(to);
    }
    canvas.drawPath(path, _circlePaint);
  }

  void _drawDots(Canvas canvas) {
    final Offset center = Offset(width / 2, height / 2);

    double b = begin;
    double e = end;
    if (begin > end) {
      b = end;
      e = begin;
    }

    final Path path = Path();
    for (double d = b; d < e; d += step) {
      final Offset offset = Degree(d).offsetOnArc(width, height, center);
      path.addOval(Rect.fromCircle(
        center: offset,
        radius: strokeWidth +
            (endStrokeWidth - strokeWidth) * (d - begin) / (end - begin),
      ));
    }
    canvas.drawPath(path, _circlePaint);
  }

  void _drawLine(Canvas canvas, double begin, double end) {
    final Offset center = Offset(width / 2, height / 2);

    canvas.drawLine(
      degree.offsetAtDistance(width, height, begin, center),
      degree.offsetAtDistance(width, height, end, center),
      _circlePaint,
    );
  }

  void _drawLineWithRoundEnds(Canvas canvas) {
    final double distance = degree.distance(width, height);
    final double capInset = strokeWidth / 2 / distance * 100;

    bool bRounded = round == RoundCap.begin || round == RoundCap.both;
    final bool eRounded = round == RoundCap.end || round == RoundCap.both;

    final bool isOutward = begin < end;
    double b = bRounded ? begin + (isOutward ? capInset : -capInset) : begin;
    double e = eRounded ? end - (isOutward ? capInset : -capInset) : end;

    if ((isOutward && b > e) || (!isOutward && b < e)) {
      if (bRounded && eRounded) {
        bRounded = false;
        b = begin;
      }

      if ((isOutward && b > e) || (!isOutward && b < e)) {
        e = b;
      }
    }

    final Offset center = Offset(width / 2, height / 2);
    final Offset bOffset = degree.offsetAtDistance(width, height, b, center) +
        (degree + 90.0).offsetOnArc(strokeWidth, strokeWidth);

    final Offset offset1 = (degree - 90.0)
        .forOvalArc(width, height)
        .offsetOnArc(strokeWidth * 2, strokeWidth * 2);

    final Offset offset2 = degree.offsetAtDistance(width, height, e - b);

    final Path path = Path();
    path.moveTo(bOffset.dx, bOffset.dy);

    if (bRounded) {
      path.relativeArcToPoint(
        offset1,
        radius: Radius.circular(strokeWidth / 2),
        clockwise: isOutward,
      );
    } else {
      path.relativeLineTo(offset1.dx, offset1.dy);
    }

    path.relativeLineTo(offset2.dx, offset2.dy);

    if (eRounded) {
      path.relativeArcToPoint(
        -offset1,
        radius: Radius.circular(strokeWidth / 2),
        clockwise: isOutward,
      );
    } else {
      path.relativeLineTo(-offset1.dx, -offset1.dy);
    }

    _circlePaint.style = PaintingStyle.fill;
    canvas.drawPath(path, _circlePaint);
  }

  void _drawDashedLine(Canvas canvas) {
    final Offset center = Offset(width / 2, height / 2);

    final Path path = Path();
    for (double i = begin; i < end; i += step) {
      final Offset from = degree.offsetAtDistance(width, height, i, center);
      final Offset to =
          degree.offsetAtDistance(width, height, i + length, center);
      path
        ..moveTo(from.dx, from.dy)
        ..lineTo(to.dx, to.dy);
    }
    canvas.drawPath(path, _circlePaint);
  }

  void _drawDottedLine(Canvas canvas) {
    final Offset center = Offset(width / 2, height / 2);

    double b = begin;
    double e = end;
    if (begin > end) {
      b = end;
      e = begin;
    }

    final Path path = Path();
    for (double i = b; i < e; i += step) {
      final Offset offset =
          degree.offsetOnArc(width * i / 100, height * i / 100, center);
      path.addOval(Rect.fromCircle(
        center: offset,
        radius: strokeWidth +
            (endStrokeWidth - strokeWidth) * (i - begin) / (end - begin),
      ));
    }
    canvas.drawPath(path, _circlePaint);
  }

  void _setShader(CircleShader shader) {
    if (shader._type != CircleShaderType.customGradient && colors.length == 1) {
      _circlePaint.color = colors.first;
      return;
    }

    final Rect rect = Rect.fromLTWH(0, 0, width, height);

    switch (shader._type) {
      case CircleShaderType.customGradient:
        _circlePaint.shader = shader._gradient.createShader(rect);
        break;

      case CircleShaderType.radialGradient:
        _circlePaint.shader =
            _Gradient.radial(colors, shader._stops).createShader(rect);
        break;

      case CircleShaderType.sweepGradient:
        if (begin == end ||
            type == CircleStyleType.line ||
            type == CircleStyleType.dashedLine ||
            type == CircleStyleType.dottedLine) {
          _circlePaint.color = colors.first;
        } else {
          _circlePaint.shader =
              _Gradient.sweep(colors, shader._stops, begin, end)
                  .createShader(rect);
        }
        break;

      case CircleShaderType.linearGradient:
        if (type == CircleStyleType.line) {
          _circlePaint.shader = _Gradient.line(
                  colors, shader._stops, width, height, degree, begin, end)
              .createShader(rect);
        } else {
          final double d = shader._degree ?? 0.0;
          _circlePaint.shader =
              _Gradient.linear(colors, shader._stops, width, height, Degree(d))
                  .createShader(rect);
        }
        break;
    }
  }
}
