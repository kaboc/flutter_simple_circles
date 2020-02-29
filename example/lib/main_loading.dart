import 'dart:async';

import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200.0,
              height: 200.0,
              child: _Indicator(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Indicator extends StatefulWidget {
  const _Indicator();

  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<_Indicator> {
  final ValueNotifier<int> count = ValueNotifier<int>(0);
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      count.value = t.tick;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const step = 16.0;

    return ValueListenableBuilder<int>(
      valueListenable: count,
      builder: (_, c, greyCircle) {
        final deg = c * step % 360;
        return Circle(
          colors: const <Color>[Color(0xCCE53935), Color(0x77E53935)],
          shader: CircleShader.linearGradientFrom(deg),
          style: CircleStyle.dotted(
            begin: deg - 180.0,
            end: deg,
            strokeWidth: 2.0,
            endStrokeWidth: 10.0,
            step: step,
          ),
        );
      },
    );
  }
}
