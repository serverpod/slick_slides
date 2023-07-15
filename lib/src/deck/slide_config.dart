import 'package:flutter/material.dart';

class SlideConfigData {
  const SlideConfigData({
    required this.animateIn,
  });

  final bool animateIn;
}

class SlideConfig extends InheritedWidget {
  const SlideConfig({
    required this.data,
    required super.child,
    super.key,
  });

  final SlideConfigData data;

  @override
  bool updateShouldNotify(SlideConfig oldWidget) => oldWidget.data != data;

  static SlideConfigData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SlideConfig>()?.data;
  }
}
