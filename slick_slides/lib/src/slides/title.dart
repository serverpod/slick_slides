import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

/// A slide that displays a title and subtitle centered on the slide.
class TitleSlide extends Slide {
  /// Creates a slide that displays a title and subtitle centered on the slide.
  TitleSlide({
    required String title,
    String? subtitle,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super(
          builder: (context) {
            return TitleLayout(
              title: Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
              background: backgroundBuilder?.call(context),
            );
          },
          notes: notes,
          transition: transition,
          theme: theme,
        );

  /// Creates a slide that displays a title and subtitle centered on the slide.
  /// This constructor uses [TextSpan]s instead of [String]s for the title and
  /// subtitle to allow for rich text.
  TitleSlide.rich({
    required TextSpan title,
    TextSpan? subtitle,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super(
          builder: (context) {
            return TitleLayout(
              title: Text.rich(title),
              subtitle: subtitle == null ? null : Text.rich(subtitle),
              background: backgroundBuilder?.call(context),
            );
          },
          notes: notes,
          transition: transition,
          theme: theme,
        );
}
