import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

class SmileyScreen extends StatelessWidget {
  const SmileyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smiley'),
      ),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32.0),
            child: _Smiley(),
          ),
        ),
      ),
    );
  }
}

class _Smiley extends StatelessWidget {
  const _Smiley();

  @override
  Widget build(BuildContext context) {
    const radius = 250.0;

    return CircleStack(
      width: radius,
      height: radius,
      children: const <Widget>[
        // Outline
        Circle(
          colors: [Colors.yellow, Colors.deepOrange],
          style: CircleStyle.fill(),
          // The angle specified here is ignored on web due to
          // insufficient implementation on the Flutter side.
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
    );
  }
}
