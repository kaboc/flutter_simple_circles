import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'stack.dart';

class CircleContainer extends ParentDataWidget<CircleStack> {
  const CircleContainer({
    Key key,
    @required Widget child,
    this.degree,
    this.distance = 0.0,
    this.rotate = 0.0,
  })  : assert(child != null),
        assert(distance != null),
        assert(rotate != null),
        super(key: key, child: child);

  final double degree;
  final double distance;
  final double rotate;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is StackParentData);
  }
}
