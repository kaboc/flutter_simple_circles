import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/clock.dart';
import 'screens/gradients.dart';
import 'screens/oval_layout.dart';
import 'screens/percentage.dart';
import 'screens/pie_chart.dart';
import 'screens/smiley.dart';
import 'screens/spinner.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Simple Circles';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 250.0,
                    maxWidth: 500.0,
                  ),
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
                        label: 'Oval layout',
                        builder: (_) => const OvalLayoutScreen(),
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
