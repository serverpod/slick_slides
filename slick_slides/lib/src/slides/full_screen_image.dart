import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

/// A slide that displays a title and subtitle centered on the slide.
class FullScreenImageSlide extends Slide {
  /// Creates a slide that displays a title and subtitle centered on the slide.
  FullScreenImageSlide({
    required ImageProvider image,
    String? title,
    String? subtitle,
    Alignment alignment = Alignment.center,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
    Duration? autoplayDuration,
    Source? audioSource,
  }) : super(
          builder: (context) {
            return TitleLayout(
              title: title == null ? null : Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
              alignment: alignment,
              background: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            );
          },
          onPrecache: (context) async {
            await precacheImage(
              image,
              context,
            );
          },
          notes: notes,
          transition: transition,
          theme: theme,
          autoplayDuration: autoplayDuration,
          audioSource: audioSource,
        );

  /// Creates a slide that displays a title and subtitle centered on the slide.
  /// This constructor uses [TextSpan]s instead of [String]s for the title and
  /// subtitle to allow for rich text.
  FullScreenImageSlide.rich({
    required ImageProvider image,
    TextSpan? title,
    TextSpan? subtitle,
    Alignment alignment = Alignment.center,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
    Duration? autoplayDuration,
    Source? audioSource,
  }) : super(
          builder: (context) {
            return TitleLayout(
              title: title == null ? null : Text.rich(title),
              subtitle: subtitle == null ? null : Text.rich(subtitle),
              alignment: alignment,
              background: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            );
          },
          onPrecache: (context) async {
            await precacheImage(
              image,
              context,
            );
          },
          notes: notes,
          transition: transition,
          theme: theme,
          autoplayDuration: autoplayDuration,
          audioSource: audioSource,
        );
}
