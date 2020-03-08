import 'package:flutter/material.dart';

import 'package:simple_circles/simple_circles.dart';

class PieChartScreen extends StatelessWidget {
  const PieChartScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie chart'),
      ),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32.0),
            child: _PieChart(),
          ),
        ),
      ),
    );
  }
}

class _PieChart extends StatelessWidget {
  const _PieChart();

  @override
  Widget build(BuildContext context) {
    const radius = 260.0;

    return CircleStack(
      width: radius,
      height: radius,
      children: <Widget>[
        const CircleContainer(
          width: radius + 10.0,
          height: radius + 10.0,
          degree: 15 * 3.6,
          distance: 4.0,
          child: Circle(
            colors: [Colors.red],
            style: CircleStyle.fill(end: 30 * 3.6),
          ),
        ),
        _text(0, 30, 'A'),
        const Circle(
          colors: [Colors.orange],
          style: CircleStyle.fill(begin: 30 * 3.6, end: 58 * 3.6),
        ),
        _text(30, 58, 'B'),
        _divider(58),
        const Circle(
          colors: [Colors.lightGreen],
          style: CircleStyle.fill(begin: 58 * 3.6, end: 77 * 3.6),
        ),
        _text(58, 77, 'C'),
        _divider(77),
        const Circle(
          colors: [Colors.blue],
          style: CircleStyle.fill(begin: 77 * 3.6, end: 92 * 3.6),
        ),
        _text(77, 92, 'D'),
        _divider(92),
        const Circle(
          colors: [Colors.indigo],
          style: CircleStyle.fill(begin: 92 * 3.6, end: 100 * 3.6),
        ),
        _text(92, 100, 'E'),
      ],
    );
  }

  Widget _divider(double percentage) {
    return Circle(
      colors: const [Colors.white],
      style: CircleStyle.line(
        degree: percentage * 3.6,
        begin: 0.0,
        strokeWidth: 2.0,
      ),
    );
  }

  Widget _text(double percentage1, double percentage2, String text) {
    return CircleContainer(
      width: 30.0,
      height: 30.0,
      degree: (percentage1 + (percentage2 - percentage1) / 2) * 3.6,
      distance: 70.0,
      align: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
