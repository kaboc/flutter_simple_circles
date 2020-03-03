import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

class PercentageScreen extends StatelessWidget {
  const PercentageScreen();

  @override
  Widget build(BuildContext context) {
    final _percentage = ValueNotifier<double>(0.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading indicator'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _PercentageIndicator(_percentage),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          _percentage.value = _percentage.value == 0.0 ? 100.0 : 0.0;
        },
      ),
    );
  }
}

class _PercentageIndicator extends StatelessWidget {
  const _PercentageIndicator(this._percentage);

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
                  colors: const [Color(0xFF4FC3F7), Color(0xFF1A237E)],
                  // SweepGradient is yet to be implemented on web in Flutter.
                  // Null here is regarded as CircleShader.linearGradient().
                  shader: kIsWeb ? null : const CircleShader.sweepGradient(),
                  style: CircleStyle.stroke(
                    end: percentage * 360.0 / 100,
                    strokeWidth: radius / 6,
                    // RoundCap on only one end looks different on web due to
                    // different implementations between platforms in Flutter.
                    // RoundCap.none is used for web here to avoid the ugly look.
                    round: kIsWeb ? RoundCap.none : RoundCap.end,
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
        style: CircleStyle.stroke(strokeWidth: radius / 6),
      ),
    );
  }
}
