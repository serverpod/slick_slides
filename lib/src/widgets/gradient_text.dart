import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText({
    required this.child,
    this.gradient,
    super.key,
  });

  final Widget child;
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
