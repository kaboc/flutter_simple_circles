import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final _percentage = ValueNotifier<double>(0.0);

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: _Indicator(_percentage),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            _percentage.value = _percentage.value == 0.0 ? 100.0 : 0.0;
          },
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator(this._percentage);

  final ValueNotifier<double> _percentage;

  @override
  Widget build(BuildContext context) {
    const radius = 220.0;

    return ValueListenableBuilder<double>(
      valueListenable: _percentage,
      builder: (_, end, greyCircle) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: end),
          curve: Curves.easeOutQuart,
          duration: const Duration(seconds: 2),
          builder: (_, percentage, __) {
            return CircleStack(
              width: radius,
              height: radius,
              children: <Widget>[
                greyCircle,
                Circle(
                  colors: const <Color>[Color(0xFF4FC3F7), Color(0xFF1A237E)],
                  shader: const CircleShader.sweepGradient(),
                  style: CircleStyle.stroke(
                    end: percentage * 360.0 / 100,
                    strokeWidth: radius / 5.5,
                    round: RoundCap.end,
                  ),
                ),
                CircleContainer(
                  align: Alignment.center,
                  child: Text(
                    percentage.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 65.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: const Circle(
        colors: [Color(0xFFCFD8DC)],
        style: CircleStyle.stroke(strokeWidth: radius / 5.5),
      ),
    );
  }
}
