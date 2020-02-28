import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    const radius = 270.0;

    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: CircleStack(
              width: radius,
              height: radius,
              children: <Widget>[
                // Outline
                Circle(
                  colors: [Colors.yellow, Colors.deepOrange],
                  style: CircleStyle.fill(),/**/
                  shader: CircleShader.linearGradientFrom(-45.0),
                ),
                // Left eye
                CircleContainer(
                  width: radius / 6,
                  height: radius / 6,
                  degree: 310.0,
                  distance: 47.0,
                  child: Circle(style: CircleStyle.fill()),
                ),
                // Right eye
                CircleContainer(
                  width: radius / 6,
                  height: radius / 6,
                  degree: 50.0,
                  distance: 47.0,
                  child: Circle(style: CircleStyle.fill()),
                ),
                // Mouth
                CircleContainer(
                  width: radius / 1.9,
                  height: radius / 2.2,
                  degree: 180.0,
                  distance: 10.0,
                  child: Circle(
                    style: CircleStyle.stroke(
                      begin: 90.0,
                      end: 270.0,
                      strokeWidth: radius / 12,
                      round: RoundCap.both,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
