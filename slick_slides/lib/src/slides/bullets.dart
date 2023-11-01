import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

class BulletsSlide extends Slide {
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
