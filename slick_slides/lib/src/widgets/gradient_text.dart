import 'package:flutter/material.dart';

/// A widget that displays text with a gradient.
class GradientText extends StatelessWidget {
  /// Creates a widget that displays text with a gradient.
  const GradientText({
    required this.child,
    this.gradient,
    super.key,
  });

  /// The text to display.
  final Widget child;

  /// The gradient to use for the text.
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    if (gradient == null) {
      return child;
    }

    return ShaderMask(
      shaderCallback: (bounds) => gradient!.createShader(bounds),
      child: child,
    );
  }
}
