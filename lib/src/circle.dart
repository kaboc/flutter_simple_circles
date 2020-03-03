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
        w ??= stack.width;
        h ??= stack.height;
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
      size: Size(width, height),
      painter: _Painter(
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
      _setShader(size.width, size.height, shader as CircleShader);
    } else {
      _circlePaint.shader = shader;
    }

    switch (type) {
      case CircleStyleType.stroke:
        round == RoundCap.none
            ? _drawArc(canvas, size.width, size.height, begin, end)
            : _drawArcWithRoundEnds(canvas, size.width, size.height);
        break;
      case CircleStyleType.fill:
        _drawArc(canvas, size.width, size.height, begin, end);
        break;
      case CircleStyleType.dashed:
        _drawDash(canvas, size.width, size.height);
        break;
      case CircleStyleType.dotted:
        _drawDots(canvas, size.width, size.height);
        break;
      case CircleStyleType.line:
        round == RoundCap.none
            ? _drawLine(canvas, size.width, size.height, begin, end)
            : _drawLineWithRoundEnds(canvas, size.width, size.height);
        break;
      case CircleStyleType.dashedLine:
        _drawDashedLine(canvas, size.width, size.height);
        break;
      case CircleStyleType.dottedLine:
        _drawDottedLine(canvas, size.width, size.height);
        break;
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return true;
  }

  void _drawArc(
    Canvas canvas,
    double width,
    double height,
    double begin,
    double end,
  ) {
    canvas.drawArc(
      Rect.fromLTWH(0, 0, width, height),
      Degree(begin).adjustedRadian(),
      Degree(end - begin).radian(),
      type == CircleStyleType.fill,
      _circlePaint,
    );
  }

  void _drawArcWithRoundEnds(Canvas canvas, double width, double height) {
    if (strokeWidth <= 1.0) {
      _drawArc(canvas, width, height, begin, end);
      return;
    }

    final double capInset = Degree.fromLength(width, height, strokeWidth).value;

    bool bRounded = round == RoundCap.begin || round == RoundCap.both;
    final bool eRounded = round == RoundCap.end || round == RoundCap.both;

    final bool isClockwise = begin <= end;
    double b = bRounded ? begin + (isClockwise ? capInset : -capInset) : begin;
    double e = eRounded ? end - (isClockwise ? capInset : -capInset) : end;

    if ((isClockwise && b > e) || (!isClockwise && b < e)) {
      if (bRounded && eRounded) {
        bRounded = false;
        b = begin;
      }

      if ((isClockwise && b > e) || (!isClockwise && b < e)) {
        e = b;
      }
    }

    final Offset center = Offset(width / 2, height / 2);
    final Rect rect = Rect.fromLTWH(0.0, 0.0, width, height);

    final Path path = Path();

    if (bRounded && eRounded) {
      final Offset bOffset = Degree(b).offsetOnArc(width, height, center);
      path
        ..moveTo(bOffset.dx, bOffset.dy)
        ..arcTo(rect, Degree(b).adjustedRadian(), Degree(e - b).radian(), true);
    } else if (bRounded) {
      final double eAdj = e - (isClockwise ? 0.1 : -0.1);
      final Offset eAdjOffset = Degree(eAdj).offsetOnArc(width, height, center);
      b = b == e ? eAdj : b;
      path
        ..moveTo(eAdjOffset.dx, eAdjOffset.dy)
        ..arcTo(rect, Degree(eAdj).adjustedRadian(), Degree(e - eAdj).radian(),
            true)
        ..arcTo(
            rect, Degree(e).adjustedRadian(), Degree(b - e).radian(), false);
    } else {
      final double bAdj = b + (isClockwise ? 0.1 : -0.1);
      final Offset bAdjOffset = Degree(bAdj).offsetOnArc(width, height, center);
      e = b == e ? bAdj : e;
      path
        ..moveTo(bAdjOffset.dx, bAdjOffset.dy)
        ..arcTo(rect, Degree(bAdj).adjustedRadian(), Degree(b - bAdj).radian(),
            true)
        ..arcTo(
            rect, Degree(b).adjustedRadian(), Degree(e - b).radian(), false);
    }

    canvas.drawPath(path, _circlePaint..strokeCap = StrokeCap.round);
  }

  void _drawDash(Canvas canvas, double width, double height) {
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

  void _drawDots(Canvas canvas, double width, double height) {
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

  void _drawLine(
    Canvas canvas,
    double width,
    double height,
    double begin,
    double end,
  ) {
    final Offset center = Offset(width / 2, height / 2);

    canvas.drawLine(
      degree.offsetAtDistance(width, height, begin, center),
      degree.offsetAtDistance(width, height, end, center),
      _circlePaint,
    );
  }

  void _drawLineWithRoundEnds(Canvas canvas, double width, double height) {
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
    Offset bOffset = degree.offsetAtDistance(width, height, b, center);
    Offset eOffset = degree.offsetAtDistance(width, height, e, center);

    final Path path = Path();

    if (bRounded && eRounded) {
      path
        ..moveTo(bOffset.dx, bOffset.dy)
        ..lineTo(eOffset.dx, eOffset.dy);
    } else {
      final double distance = degree.distance(width, height);
      final double adjDistance = (isOutward ? 2 : -2) / distance;

      if (bRounded) {
        final Offset eAdjOffset =
            degree.offsetAtDistance(width, height, e - adjDistance, center);
        bOffset = b == e ? eAdjOffset : bOffset;
        path
          ..moveTo(eAdjOffset.dx, eAdjOffset.dy)
          ..lineTo(eOffset.dx, eOffset.dy)
          ..lineTo(bOffset.dx, bOffset.dy);
      } else {
        final Offset bAdjOffset =
            degree.offsetAtDistance(width, height, b + adjDistance, center);
        eOffset = b == e ? bAdjOffset : eOffset;
        path
          ..moveTo(bAdjOffset.dx, bAdjOffset.dy)
          ..lineTo(bOffset.dx, bOffset.dy)
          ..lineTo(eOffset.dx, eOffset.dy);
      }
    }

    canvas.drawPath(path, _circlePaint..strokeCap = StrokeCap.round);
  }

  void _drawDashedLine(Canvas canvas, double width, double height) {
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

  void _drawDottedLine(Canvas canvas, double width, double height) {
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

  void _setShader(double width, double height, CircleShader shader) {
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
