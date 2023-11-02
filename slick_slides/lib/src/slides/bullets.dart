import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

/// A slide that displays a list of bullet points.
class BulletsSlide extends Slide {
  /// Creates a slide that displays a list of bullet points based on [String]s.
  /// The [bullets] can either be shown all at once or one at a time by setting
  /// [bulletByBullet] to true.
  BulletsSlide({
    String? title,
    String? subtitle,
    required List<String> bullets,
    bool bulletByBullet = false,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super.withSubSlides(
          builder: (context, index) {
            return ContentLayout(
              title: title == null ? null : Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
              background: backgroundBuilder?.call(context),
              content: Bullets(
                bullets: bullets,
                numVisibleBullets: bulletByBullet ? index : null,
              ),
            );
          },
          subSlideCount: bulletByBullet ? bullets.length + 1 : 1,
          notes: notes,
          transition: transition,
          theme: theme,
        );

  /// Creates a slide that displays a list of bullet points based on [TextSpan]s.
  /// The [bullets] can either be shown all at once or one at a time by setting
  /// [bulletByBullet] to true.
  BulletsSlide.rich({
    TextSpan? title,
    TextSpan? subtitle,
    required List<TextSpan> bullets,
    bool bulletByBullet = false,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super.withSubSlides(
          builder: (context, index) {
            return ContentLayout(
              title: title == null ? null : Text.rich(title),
              subtitle: subtitle == null ? null : Text.rich(subtitle),
              background: backgroundBuilder?.call(context),
              content: Bullets.rich(
                bullets: bullets,
                numVisibleBullets: bulletByBullet ? index : null,
              ),
            );
          },
          subSlideCount: bulletByBullet ? bullets.length + 1 : 1,
          notes: notes,
          transition: transition,
          theme: theme,
        );
}
