# Examples

## Smiley face

[lib/main_smiley.dart](lib/main_smiley.dart)

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

Just run the files below that you can find in the [lib](lib) directory.

- [main_pie.dart](lib/main_pie.dart)
- [main_gradients.dart](lib/main_gradients.dart)
- [main_loading.dart](lib/main_loading.dart)
- [main_clock.dart](lib/main_clock.dart)
- [main_percentage.dart](lib/main_pie.dart)
- [main_oval_text.dart](lib/main_oval_text.dart)
