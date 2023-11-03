import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

/// The position of an image in a [BulletsSlide].
enum BulletsImageLocation {
  /// The image is on the left side of the slide.
  left,

  /// The image is on the right side of the slide.
  right,
}

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
    BulletsImageLocation imageLocation = BulletsImageLocation.right,
    AssetImage? image,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super.withSubSlides(
          builder: (context, index) {
            Widget content;
            if (image == null) {
              content = Bullets(
                bullets: bullets,
                animateLastVisibleBullet: bulletByBullet,
                numVisibleBullets: bulletByBullet ? index : null,
              );
            } else {
              content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageLocation == BulletsImageLocation.left)
                    Expanded(
                      child: Image(
                        image: image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  Expanded(
                    child: Bullets(
                      bullets: bullets,
                      numVisibleBullets: bulletByBullet ? index : null,
                      animateLastVisibleBullet: bulletByBullet,
                    ),
                  ),
                  if (imageLocation == BulletsImageLocation.right)
                    Expanded(
                      child: Image(
                        image: image,
                        fit: BoxFit.contain,
                      ),
                    ),
                ],
              );
            }

            return ContentLayout(
              title: title == null ? null : Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
              background: backgroundBuilder?.call(context),
              content: content,
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
    BulletsImageLocation imageLocation = BulletsImageLocation.right,
    AssetImage? image,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super.withSubSlides(
          builder: (context, index) {
            Widget content;
            if (image == null) {
              content = Bullets.rich(
                bullets: bullets,
                animateLastVisibleBullet: bulletByBullet,
                numVisibleBullets: bulletByBullet ? index : null,
              );
            } else {
              content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageLocation == BulletsImageLocation.left)
                    Expanded(
                      child: Image(
                        image: image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  Expanded(
                    child: Bullets.rich(
                      bullets: bullets,
                      numVisibleBullets: bulletByBullet ? index : null,
                      animateLastVisibleBullet: bulletByBullet,
                    ),
                  ),
                  if (imageLocation == BulletsImageLocation.right)
                    Expanded(
                      child: Image(
                        image: image,
                        fit: BoxFit.contain,
                      ),
                    ),
                ],
              );
            }

            return ContentLayout(
              title: title == null ? null : Text.rich(title),
              subtitle: subtitle == null ? null : Text.rich(subtitle),
              background: backgroundBuilder?.call(context),
              content: content,
            );
          },
          subSlideCount: bulletByBullet ? bullets.length + 1 : 1,
          notes: notes,
          transition: transition,
          theme: theme,
        );
}
