import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;

import 'package:simple_circles/simple_circles.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen();

  static const _imagePath = 'assets/clock_texture.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<ImageShader>(
            future: _getImageShader(),
            initialData: null,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: _Clock(snapshot.data),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<ImageShader> _getImageShader() {
    if (kIsWeb) {
      // ImageShader is not implemented in Flutter web yet
      // https://github.com/flutter/flutter/issues/33616
      return Future<ImageShader>(null);
    }

    final completer = Completer<ImageShader>();
    const AssetImage(_imagePath)
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
          (info, _) => completer.complete(
            ImageShader(
              info.image,
              TileMode.repeated,
              TileMode.repeated,
              Matrix4.identity().storage,
            ),
          ),
        ));
    return completer.future;
  }
}

class _Clock extends StatelessWidget {
  const _Clock(this._imageShader);

  final ImageShader _imageShader;

  @override
  Widget build(BuildContext context) {
    const radius = 270.0;
    const bgColor = Color(0xFFFAF5EA);
    const rimColor = Color(0xFF332222);
    const textColor = Color(0xFF333333);
    const pivotGrey = Color(0xFF888888);

    return CircleStack(
      width: radius,
      height: radius,
      children: <Widget>[
        // Dial face
        Circle(
          style: const CircleStyle.fill(),
          colors: const [bgColor],
          shader: _imageShader,
        ),
        // 60 indicator marks
        const Circle(
          width: radius - 16.0,
          height: radius - 16.0,
          colors: [rimColor],
          style: CircleStyle.dashed(begin: -0.3, strokeWidth: 6.0, step: 6.0),
        ),
        // 12 indicator marks
        const Circle(
          width: radius - 16.0,
          height: radius - 16.0,
          colors: [rimColor],
          style: CircleStyle.dashed(
            begin: -0.8,
            strokeWidth: 12.0,
            length: 2.0,
            step: 30.0,
          ),
        ),
        // Periphery
        const Circle(
          colors: [rimColor],
          style: CircleStyle.stroke(strokeWidth: 10.0),
          maskFilter: MaskFilter.blur(BlurStyle.solid, 1.5),
        ),
        // Numerals
        for (int i = 1; i <= 12; i++)
          CircleContainer(
            width: 50.0,
            height: 50.0,
            degree: i * 30.0,
            distance: 75.0,
            align: Alignment.center,
            child: Text(
              i.toString(),
              style: const TextStyle(fontSize: 27.0, color: textColor),
            ),
          ),
        // Hour hand
        const Circle(
          colors: [Colors.black],
          style: CircleStyle.line(
            degree: 301.5,
            strokeWidth: 8.0,
            begin: -8.0,
            end: 55.0,
            round: RoundCap.begin,
          ),
        ),
        // Minute hand
        const Circle(
          colors: [Colors.black],
          style: CircleStyle.line(
            degree: 62.7,
            strokeWidth: 4.0,
            begin: -15.0,
            end: 83.0,
            round: RoundCap.begin,
          ),
        ),
        // Second hand
        const Circle(
          colors: [Colors.red],
          style: CircleStyle.line(
            degree: 162,
            strokeWidth: 1.0,
            begin: -15.0,
            end: 87.0,
          ),
        ),
        // Pivot
        const Circle(
          width: 4.0,
          height: 4.0,
          colors: [pivotGrey],
          style: CircleStyle.fill(),
        ),
      ],
    );
  }
}
