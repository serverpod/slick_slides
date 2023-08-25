import 'package:flutter/material.dart';

class SlideTheme extends InheritedWidget {
  const SlideTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final SlideThemeData data;

  @override
  bool updateShouldNotify(SlideTheme oldWidget) => oldWidget.data != data;

  static SlideThemeData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SlideTheme>()?.data;
  }
}

class SlideThemeData {
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

  final Brightness brightness;
  final EdgeInsets borderPadding;
  final double subtitleSpacing;
  final double titleSpacing;
  final double horizontalSpacing;
  final BorderRadiusGeometry imageBorderRadius;
  final List<BoxShadow>? imageBoxShadow;
  final SlideTextThemeData textTheme;
  final WidgetBuilder? _backgroundBuilder;

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

class SlideTextThemeData {
  const SlideTextThemeData.dark({
    this.title = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 90.0,
      fontWeight: FontWeight.w900,
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
      height: 1.1,
    ),
    this.subtitleGradient,
    this.body = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
    ),
    this.code = const TextStyle(
      fontFamily: 'JetBrains Mono',
      color: Color(0xffabdafc),
      fontWeight: FontWeight.normal,
      fontSize: 32.0,
    ),
  });

  const SlideTextThemeData.light({
    this.title = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.white,
      fontSize: 90.0,
      fontWeight: FontWeight.w900,
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
      height: 1.1,
    ),
    this.subtitleGradient,
    this.body = const TextStyle(
      fontFamily: 'Inter',
      color: Colors.black,
      fontSize: 45.0,
      fontWeight: FontWeight.w400,
    ),
    this.code = const TextStyle(
      fontFamily: 'JetBrains Mono',
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 32.0,
    ),
  });

  final TextStyle title;
  final Gradient? titleGradient;
  final TextStyle subtitle;
  final Gradient? subtitleGradient;
  final TextStyle body;
  final TextStyle code;
}
