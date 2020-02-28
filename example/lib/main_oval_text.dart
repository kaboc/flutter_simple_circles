import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: _CircularText(),
          ),
        ),
      ),
    );
  }
}

class _CircularText extends StatelessWidget {
  const _CircularText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text(
          'Letters are angled along the lines\nfrom the oval center.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.0),
        _Oval(
          description: 'rotate: degree',
        ),
        SizedBox(height: 64.0),
        Text(
          'Letters are angled vertically to\nthe oval arc.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24.0),
        _Oval(
          description: 'rotate: Degree(degree)\n.forOvalArc(w, h).value',
          verticalToArc: true,
        ),
      ],
    );
  }
}

class _Oval extends StatelessWidget {
  const _Oval({@required this.description, this.verticalToArc = false});

  final String description;
  final bool verticalToArc;

  @override
  Widget build(BuildContext context) {
    const width = 270.0;
    const height = 150.0;

    return CircleStack(
      width: width,
      height: height,
      overflow: Overflow.visible,
      children: <Widget>[
        const Circle(
          colors: [Color(0xFFD5EACA)],
          style: CircleStyle.stroke(strokeWidth: 20.0),
        ),
        const Circle(
          colors: [Color(0xFFAACCAA)],
          style: CircleStyle.dashed(
            length: 0.5,
            strokeWidth: 20.0,
            begin: 5.0,
            step: 10.0,
          ),
        ),
        const Circle(
          colors: [Color(0xFFAACCAA)],
          style: CircleStyle.dashedLine(
            degree: 50.0,
            begin: -90.0,
            end: 90.0,
            length: 3.0,
            step: 6.0,
          ),
        ),
        const Circle(
          colors: [Color(0xFFAACCAA)],
          style: CircleStyle.dashedLine(
            degree: 130.0,
            begin: -90.0,
            end: 90.0,
            length: 3.0,
            step: 6.0,
          ),
        ),
        CircleContainer(
          height: 40,
          align: Alignment.center,
          child: Text(description),
        ),
        for (double d = 0.0; d < 360.0; d += 10.0)
          CircleContainer(
            width: 30.0,
            height: 30.0,
            degree: d,
            distance: 100.0,
            rotate:
                verticalToArc ? Degree(d).forOvalArc(width, height).value : d,
            align: Alignment.center,
            child: Text((d ~/ 10 % 10).toString()),
          ),
      ],
    );
  }
}
