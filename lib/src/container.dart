import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'stack.dart';

class CircleContainer extends ParentDataWidget<CircleStack> {
  const CircleContainer({
    Key key,
    this.width,
    this.height,
    @required Widget child,
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
        super(key: key, child: child);

  final double width;
  final double height;
  final double distance;
  final double degree;
  final double rotate;
  final Alignment align;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is StackParentData);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width, defaultValue: null));
    properties.add(DoubleProperty('height', height, defaultValue: null));
  }

  static CircleContainer of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CircleContainer>();
  }
}
