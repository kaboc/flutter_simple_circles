import 'package:flutter/widgets.dart';

import 'degree.dart';
import 'stack.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    Key key,
    this.width,
    this.height,
    @required this.child,
    this.degree,
    this.distance = 0.0,
    this.rotate = 0.0,
    this.align = Alignment.topLeft,
  })  : assert(width == null || width > 0.0),
        assert(height == null || height > 0.0),
        assert(child != null),
        assert(distance != null),
        assert(rotate != null),
        assert(align != null),
        super(key: key);

  final double width;
  final double height;
  final Widget child;
  final double distance;
  final double degree;
  final double rotate;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    final CircleStack stack = CircleStack.of(context);
    final double w = stack.width - stack.padding.horizontal;
    final double h = stack.height - stack.padding.vertical;

    if (width == w && height == h) {
      return stack.padding == EdgeInsets.zero
          ? _child()
          : Positioned(
              left: stack.padding.left,
              top: stack.padding.top,
              child: _child(),
            );
    }

    final double childWidth = width ?? w;
    final double childHeight = height ?? h;
    final Offset offset = degree == null
        ? const Offset(0.0, 0.0)
        : _ovalOffsetAtDistance(w, h, distance);

    return Positioned(
      left: stack.width / 2 + offset.dx - childWidth / 2,
      top: stack.height / 2 + offset.dy - childHeight / 2,
      child: SizedBox(
        width: childWidth,
        height: childHeight,
        child: align == Alignment.topLeft
            ? _child()
            : Align(
                alignment: align,
                child: _child(),
              ),
      ),
    );
  }

  static CircleContainer of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CircleContainer>();
  }

  Widget _child() {
    return rotate == 0.0
        ? child
        : Transform.rotate(
            angle: Degree(rotate).radian(),
            child: child,
          );
  }

  Offset _ovalOffsetAtDistance(double width, double height, double distance) {
    double wAdj = 1.0;
    double hAdj = 1.0;

    if (width > height) {
      wAdj = (width - (height - height * distance / 100)) /
          (width * distance / 100);
    } else if (width < height) {
      hAdj = (height - (width - width * distance / 100)) /
          (height * distance / 100);
    }

    return Degree(degree).offsetOnArc(
      width * distance / 100 * wAdj,
      height * distance / 100 * hAdj,
    );
  }
}
