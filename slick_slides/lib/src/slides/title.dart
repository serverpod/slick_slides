import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

class TitleSlide extends Slide {
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
