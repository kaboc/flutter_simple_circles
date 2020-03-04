# Examples

## Smiley face

[lib/main_smiley.dart](lib/screens/smiley.dart)

```dart
CircleStack(
  width: 270.0,
  height: 270.0,
  children: const <Widget>[
    // Outline
    Circle(
      colors: [Colors.yellow, Colors.deepOrange],
      style: CircleStyle.fill(),
      shader: CircleShader.linearGradientFrom(-45.0),
    ),
    // Left eye
    CircleContainer(
      width: 46.0,
      height: 46.0,
      degree: 310.0,
      distance: 47.0,
      child: Circle(style: CircleStyle.fill()),
    ),
    // Right eye
    CircleContainer(
      width: 46.0,
      height: 46.0,
      degree: 50.0,
      distance: 47.0,
      child: Circle(style: CircleStyle.fill()),
    ),
    // Mouth
    CircleContainer(
      width: 142.0,
      height: 124.0,
      degree: 180.0,
      distance: 10.0,
      child: Circle(
        style: CircleStyle.stroke(
          begin: 90.0,
          end: 270.0,
          strokeWidth: 22.5,
          round: RoundCap.both,
        ),
      ),
    ),
  ],
)
```

## More examples

Just run `main.dart` in the [lib](lib) directory, or see the [Demo](https://kaboc.github.io/flutter_simple_circles/), which shows the following examples in addition to the smiley face above.

- [Pie chart](lib/screens/pie_chart.dart)
- [Clock](lib/screens/clock.dart)
- [Gradients](lib/screens/gradients.dart)
- [Spinner](lib/screens/spinner.dart)
- [Percentage](lib/screens/percentage.dart)
- [Oval text](lib/screens/oval_text.dart) 
