import 'package:flutter/material.dart';

/// A transition used when navigating between slides.
abstract class SlickTransition {
  /// Creates a transition used when navigating between slides.
  const SlickTransition({
    required this.duration,
  });

  /// The duration of the transition.
  final Duration duration;

  /// Builds the [PageRoute] used to render the transition.
  PageRoute buildPageRoute(WidgetBuilder slideBuilder);
}
