import 'package:flutter/material.dart';

/// Configuration used when building a [Slide].
class SlideConfigData {
  /// Creates a [SlideConfigData]. This is typically done by the [SlideDeck].
  const SlideConfigData({
    required this.animateIn,
  });

  /// Whether the slide should animate in or be rendered in its final state
  /// immediately.
  final bool animateIn;
}

/// Inherited widget used to pass [SlideConfigData] down the widget tree. The
/// configuration can be accessed using [SlideConfig.of] when building a
/// [Slide].
class SlideConfig extends InheritedWidget {
  /// Creates a [SlideConfig]. This is typically done by the [SlideDeck].
  const SlideConfig({
    required this.data,
    required super.child,
    super.key,
  });

  /// The build configuration for the slide.
  final SlideConfigData data;

  @override
  bool updateShouldNotify(SlideConfig oldWidget) => oldWidget.data != data;

  /// Returns the [SlideConfigData] for the given [context].
  static SlideConfigData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SlideConfig>()?.data;
  }
}
