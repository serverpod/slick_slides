import 'package:flutter/material.dart';

abstract class SlickTransition {
  const SlickTransition({
    required this.duration,
  });

  final Duration duration;

  PageRoute buildPageRoute(WidgetBuilder slideBuilder);
}
