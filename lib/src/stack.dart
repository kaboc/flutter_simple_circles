import 'package:flutter/rendering.dart';
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
                      ? _circleContainer(width, height, child)
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

  static Widget _circleContainer(
    double width,
    double height,
    CircleContainer container,
  ) {
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
      left: offset.dx + width / 2,
      top: offset.dy + height / 2,
      child: _CircleContainerAlign(child: rotatedChild),
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

class _CircleContainerAlign extends SingleChildRenderObjectWidget {
  const _CircleContainerAlign({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  @override
  _RenderPositionedBox createRenderObject(BuildContext context) {
    return _RenderPositionedBox();
  }
}

class _RenderPositionedBox extends _RenderAligningShiftedBox {
  @override
  void performLayout() {
    child.layout(constraints.loosen(), parentUsesSize: true);
    size = constraints.constrain(Size(child.size.width, child.size.height));
    alignChild();
  }

  @override
  void debugPaintSize(PaintingContext context, Offset offset) {
    super.debugPaintSize(
      context,
      offset - Offset(child.size.width / 2, child.size.height / 2),
    );
  }
}

abstract class _RenderAligningShiftedBox extends RenderShiftedBox {
  _RenderAligningShiftedBox() : super(null);

  final Alignment _resolvedAlignment =
      Alignment.center.resolve(TextDirection.ltr);

  @protected
  void alignChild() {
    assert(!child.debugNeedsLayout);
    assert(child.hasSize);
    assert(hasSize);
    final BoxParentData childParentData = child.parentData as BoxParentData;
    childParentData.offset = _resolvedAlignment
        .alongOffset(Offset(-child.size.width, -child.size.height));
  }
}
