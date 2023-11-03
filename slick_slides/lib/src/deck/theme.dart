import 'dart:ui';

import 'package:flutter/material.dart';

/// The theme used to style a [Slide]. A default theme is provided by the
/// [SlideDeck], but can be overridden by providing a custom [SlideTheme] to a
/// specific [Slide].
class SlideThemeData {
  /// Creates a default dark theme.
  const SlideThemeData.dark({
    this.brightness = Brightness.dark,
    this.borderPadding = const EdgeInsets.symmetric(
      horizontal: 100.0,
      vertical: 60.0,
    ),
    this.titleSpacing = 40.0,
    this.subtitleSpacing = 0.0,
    this.horizontalSpacing = 80.0,
    this.imageBorderRadius = const BorderRadius.all(
      Radius.circular(100),
    ),
    this.imageBoxShadow = const [
      BoxShadow(
        color: Colors.black38,
        blurRadius: 40.0,
        offset: Offset(0.0, 30.0),
      ),
    ],
    this.textTheme = const SlideTextThemeData.dark(),
    WidgetBuilder? backgroundBuilder,
  }) : _backgroundBuilder = backgroundBuilder;

  /// Creates a default light theme.
  const SlideThemeData.light({
    this.brightness = Brightness.light,
    this.borderPadding = const EdgeInsets.symmetric(
      horizontal: 100.0,
      vertical: 60.0,
    ),
    this.titleSpacing = 20.0,
    this.subtitleSpacing = 0.0,
    this.horizontalSpacing = 80.0,
    this.imageBorderRadius = const BorderRadius.all(
      Radius.circular(100),
    ),
    this.imageBoxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 40.0,
        offset: Offset(0.0, 30.0),
      ),
    ],
    this.textTheme = const SlideTextThemeData.light(),
    WidgetBuilder? backgroundBuilder,
  }) : _backgroundBuilder = backgroundBuilder;

  /// Creates an alternate dark theme, without the title gradient. This is
  /// useful for slides that have a background image.
  const SlideThemeData.darkAlt({
    this.brightness = Brightness.dark,
    this.borderPadding = const EdgeInsets.symmetric(
      horizontal: 100.0,
      vertical: 60.0,
    ),
    this.titleSpacing = 40.0,
    this.subtitleSpacing = 0.0,
    this.horizontalSpacing = 80.0,
    this.imageBorderRadius = const BorderRadius.all(
      Radius.circular(100),
    ),
    this.imageBoxShadow = const [
      BoxShadow(
        color: Colors.black38,
        blurRadius: 40.0,
        offset: Offset(0.0, 30.0),
      ),
    ],
    this.textTheme = const SlideTextThemeData.dark(
      titleGradient: null,
      subtitle: TextStyle(
        fontFamily: 'Inter',
        color: Colors.white70,
        fontSize: 55.0,
        fontWeight: FontWeight.w600,
        fontVariations: [
          FontVariation('wght', 600),
        ],
        height: 1.1,
      ),
    ),
    WidgetBuilder? backgroundBuilder,
  }) : _backgroundBuilder = backgroundBuilder;

  /// The brightness of the theme.
  final Brightness brightness;

  /// The padding around the content of the slide.
  final EdgeInsets borderPadding;

  /// The spacing between the title and the subtitle.
  final double subtitleSpacing;

  /// The spacing between the title/subtitle and the content.
  final double titleSpacing;

  /// The horizontal spacing between pieces of content on a slide.
  final double horizontalSpacing;

  /// The border radius of an image, e.g. on a [PersonSlide].
  final BorderRadiusGeometry imageBorderRadius;

  /// The box shadow of an image, e.g. on a [PersonSlide].
  final List<BoxShadow>? imageBoxShadow;

  /// The text theme used to style text on a slide.
  final SlideTextThemeData textTheme;

  final WidgetBuilder? _backgroundBuilder;

  /// The background builder used to build the background of a slide. By default
  /// this is a gradient that depends on the brightness of the theme.
  WidgetBuilder get backgroundBuilder {
    if (brightness == Brightness.dark) {
      return _backgroundBuilder ??
          (context) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade800,
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          };
    } else {
      return _backgroundBuilder ??
          (context) => Container(
                color: Colors.white,
              );
    }
  }
}

/// The text theme used to style text on a slide.
class SlideTextThemeData {
  /// Creates a default dark text theme.
  const SlideTextThemeData.dark({
    this.title = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 90.0,
      fontWeight: FontWeight.w800,
      fontVariations: [
        FontVariation('wght', 800),
      ],
      height: 1.1,
    ),
    this.titleGradient = const LinearGradient(
      colors: [
        Colors.orange,
        Colors.red,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.subtitle = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 55.0,
      fontWeight: FontWeight.w600,
      fontVariations: [
        FontVariation('wght', 600),
      ],
      height: 1.1,
    ),
    this.subtitleGradient,
    this.body = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
      fontVariations: [
        FontVariation('wght', 400),
      ],
    ),
    this.code = const TextStyle(
      fontFamily: 'JetBrainsMono',
      color: Color(0xffabdafc),
      fontSize: 32.0,
      fontWeight: FontWeight.w400,
      fontVariations: [
        FontVariation('wght', 400),
      ],
    ),
  });

  /// Creates a default light text theme.
  const SlideTextThemeData.light({
    this.title = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 90.0,
      fontWeight: FontWeight.w800,
      fontVariations: [
        FontVariation('wght', 800),
      ],
      height: 1.1,
    ),
    this.titleGradient = const LinearGradient(
      colors: [
        Colors.orange,
        Colors.red,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.subtitle = const TextStyle(
      fontFamily: 'Inter',
      color: Color(0xff666666),
      fontSize: 55.0,
      fontWeight: FontWeight.w600,
      fontVariations: [
        FontVariation('wght', 600),
      ],
      height: 1.1,
    ),
    this.subtitleGradient,
    this.body = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.black,
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
      fontVariations: [
        FontVariation('wght', 400),
      ],
    ),
    this.code = const TextStyle(
      fontFamily: 'JetBrainsMono',
      color: Colors.black,
      fontSize: 32.0,
      fontWeight: FontWeight.w400,
      fontVariations: [
        FontVariation('wght', 400),
      ],
    ),
  });

  /// The style of the title text.
  final TextStyle title;

  /// The optional gradient used to draw the title text. If used, it will
  /// override the color property of the [title] style.
  final Gradient? titleGradient;

  /// The style of the subtitle text.
  final TextStyle subtitle;

  /// The optional gradient used to draw the subtitle text. If used, it will
  /// override the color property of the [subtitle] style.
  final Gradient? subtitleGradient;

  /// The style of the body text.
  final TextStyle body;

  /// The base style of the code text. Coloring is overridden by the
  /// [ColoredCode] widget.
  final TextStyle code;
}

/// Inherited widget used to pass [SlideThemeData] down the widget tree. The
/// configuration can be accessed using [SlideTheme.of] when building a
/// [Slide].
class SlideTheme extends InheritedWidget {
  /// Creates a [SlideTheme]. This is typically done by the [SlideDeck].
  const SlideTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The theme data for the slide.
  final SlideThemeData data;

  @override
  bool updateShouldNotify(SlideTheme oldWidget) => oldWidget.data != data;

  /// Returns the [SlideThemeData] for the given [context].
  static SlideThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SlideTheme>()?.data;
  }
}
