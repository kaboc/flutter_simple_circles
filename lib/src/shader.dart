part of 'circle.dart';

class CircleShader implements Shader {
  const CircleShader.customGradient(Gradient gradient)
      : _type = CircleShaderType.customGradient,
        _gradient = gradient,
        _stops = null,
        _degree = null;

  const CircleShader.radialGradient({List<double> stops})
      : _type = CircleShaderType.radialGradient,
        _gradient = null,
        _stops = stops,
        _degree = null;

  const CircleShader.sweepGradient({List<double> stops})
      : _type = CircleShaderType.sweepGradient,
        _gradient = null,
        _stops = stops,
        _degree = null;

  const CircleShader.linearGradient({List<double> stops})
      : _type = CircleShaderType.linearGradient,
        _gradient = null,
        _stops = stops,
        _degree = null;

  const CircleShader.linearGradientFrom(double degree, {List<double> stops})
      : _type = CircleShaderType.linearGradient,
        _gradient = null,
        _stops = stops,
        _degree = degree;

  final CircleShaderType _type;
  final double _degree;
  final Gradient _gradient;
  final List<double> _stops;
}
