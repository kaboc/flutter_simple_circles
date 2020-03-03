import 'package:flutter/material.dart';

import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:simple_circles/simple_circles.dart';

class GradientsScreen extends StatelessWidget {
  const GradientsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradients'),
      ),
      body: SafeArea(
        child: GridView.count(
          padding: const EdgeInsets.all(32.0),
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            const Circle(
              style: CircleStyle.fill(),
              colors: [Colors.yellow, Colors.green],
            ),
            const Circle(
              style: CircleStyle.fill(),
              colors: [Colors.yellow, Colors.green],
              shader: CircleShader.linearGradientFrom(50.0),
            ),
            const Circle(
              style: CircleStyle.fill(),
              colors: [Colors.yellow, Colors.green],
              shader: CircleShader.sweepGradient(),
            ),
            const Circle(
              style: CircleStyle.fill(),
              colors: [Colors.yellow, Colors.green],
              shader: CircleShader.radialGradient(stops: <double>[0.7, 1.0]),
            ),
            const Circle(
              colors: [Colors.yellow, Colors.green],
              style: CircleStyle.line(strokeWidth: 60.0),
            ),
            const Circle(
              colors: [Colors.yellow, Colors.green],
              style: CircleStyle.line(degree: 90.0, strokeWidth: 60.0),
              // Angle of gradient is ignored for CircleStyle.line
              shader: CircleShader.linearGradientFrom(45.0),
            ),
            const Circle(
              style: CircleStyle.fill(),
              colors: [Colors.yellow, Colors.green],
              shader: CircleShader.customGradient(
                RadialGradient(
                  colors: [Colors.yellow, Colors.green],
                  focal: Alignment.topLeft,
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
            Circle(
              style: const CircleStyle.fill(),
              colors: const [Colors.yellow, Colors.green],
              shader: CircleShader.customGradient(
                FlutterGradients.angelCare(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
