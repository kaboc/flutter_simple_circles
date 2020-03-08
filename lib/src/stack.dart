import 'package:flutter/widgets.dart';

import 'circle.dart';
import 'container.dart';
import 'degree.dart';

class CircleStack extends Stack {
  CircleStack({
    Key key,
    @required this.width,
    @required this.height,
    @required List<Widget> children,
  })  : assert(width != null),
        assert(height != null),
        assert(children != null),
        super(
          key: key,
          overflow: Overflow.visible,
          fit: StackFit.loose,
          children: children
              .map((Widget child) => child is Circle
                  ? _circle(width, height, child)
                  : (child is CircleContainer
                      ? _container(width, height, child)
                      : child))
              .toList()
                ..insert(0, SizedBox(width: width, height: height)),
        );

  final double width;
  final double height;

  static CircleStack of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CircleStack>();
  }

  static Widget _circle(double width, double height, Circle circle) {
    return circle.width == null && circle.height == null
        ? circle
        : Positioned(
            left: circle.width == null ? 0.0 : (width - circle.width) / 2,
            top: circle.height == null ? 0.0 : (height - circle.height) / 2,
            child: circle,
          );
  }

  static Widget _container(
      double width, double height, CircleContainer container) {
    if (container.width == width && container.height == height) {
      return container.child;
    }

    final double childWidth = container.width ?? width;
    final double childHeight = container.height ?? height;
    final Offset offset = container.degree == null
        ? const Offset(0.0, 0.0)
        : _ovalOffsetAtDistance(
            width,
            height,
            container.degree,
            container.distance,
          );

    final Widget rotatedChild = container.rotate == 0.0
        ? container.child
        : Transform.rotate(
            angle: Degree(container.rotate).radian(),
            child: container.child,
          );

    return Positioned(
      left: offset.dx + width / 2 - childWidth / 2,
      top: offset.dy + height / 2 - childHeight / 2,
      child: SizedBox(
        width: childWidth,
        height: childHeight,
        child: container.align == Alignment.topLeft
            ? rotatedChild
            : Align(alignment: container.align, child: rotatedChild),
      ),
    );
  }

  static Offset _ovalOffsetAtDistance(
    double width,
    double height,
    double degree,
    double distance,
  ) {
    double wRatio = 1.0;
    double hRatio = 1.0;

    if (width > height) {
      wRatio = (width - (height - height * distance / 100)) /
          (width * distance / 100);
    } else if (width < height) {
      hRatio = (height - (width - width * distance / 100)) /
          (height * distance / 100);
    }

    return Degree(degree).offsetOnArc(
      width * distance / 100 * wRatio,
      height * distance / 100 * hRatio,
    );
  }
}
