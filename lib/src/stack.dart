import 'package:flutter/widgets.dart';

import 'circle.dart';

class CircleStack extends StatelessWidget {
  const CircleStack({
    Key key,
    @required this.width,
    @required this.height,
    @required this.children,
    this.padding = EdgeInsets.zero,
    this.overflow = Overflow.clip,
  })  : assert(width != null),
        assert(height != null),
        assert(children != null),
        assert(padding != null),
        super(key: key);

  final double width;
  final double height;
  final List<Widget> children;
  final EdgeInsets padding;
  final Overflow overflow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        overflow: overflow,
        children: children
            .map((Widget child) => child is Circle ? _circle(child) : child)
            .toList(),
      ),
    );
  }

  static CircleStack of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<CircleStack>();
  }

  Positioned _circle(Circle child) {
    return Positioned(
      left: child.width == null ? padding.left : (width - child.width) / 2,
      top: child.height == null ? padding.top : (height - child.height) / 2,
      child: child,
    );
  }
}
