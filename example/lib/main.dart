import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/clock.dart';
import 'screens/gradients.dart';
import 'screens/oval_text.dart';
import 'screens/percentage.dart';
import 'screens/pie_chart.dart';
import 'screens/smiley.dart';
import 'screens/spinner.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple circles sample'),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _Button(
                      label: 'Smiley',
                      builder: (_) => const SmileyScreen(),
                    ),
                    _Button(
                      label: 'Pie chart',
                      builder: (_) => const PieChartScreen(),
                    ),
                    _Button(
                      label: 'Clock',
                      builder: (_) => const ClockScreen(),
                    ),
                    if (!kIsWeb)
                      _Button(
                        label: 'Gradients',
                        builder: (_) => const GradientsScreen(),
                      ),
                    _Button(
                      label: 'Spinner',
                      builder: (_) => const SpinnerScreen(),
                    ),
                    _Button(
                      label: 'Percentage',
                      builder: (_) => const PercentageScreen(),
                    ),
                    _Button(
                      label: 'Oval text',
                      builder: (_) => const OvalTextScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({@required this.label, @required this.builder});

  final String label;
  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18.0),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: builder),
        ),
      ),
    );
  }
}
