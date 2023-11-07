import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

/// The layout used by [PersonSlide].
class PersonLayout extends StatelessWidget {
  /// Creates a layout for a slide with a person's name, title, and image.
  const PersonLayout({
    required this.name,
    required this.title,
    this.background,
    required this.image,
    Key? key,
  }) : super(key: key);

  /// The name of the person.
  final Widget name;

  /// The title of the person.
  final Widget title;

  /// The background of the slide.
  final Widget? background;

  /// The image of the person.
  final Widget image;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: background ?? theme.backgroundBuilder(context),
        ),
        Padding(
          padding: theme.borderPadding,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 512,
                  height: 512,
                  decoration: BoxDecoration(
                    borderRadius: theme.imageBorderRadius,
                    boxShadow: theme.imageBoxShadow,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: image,
                  ),
                ),
                SizedBox(width: theme.horizontalSpacing),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.title,
                      textAlign: TextAlign.start,
                      child: GradientText(
                        gradient: theme.textTheme.titleGradient,
                        child: name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: DefaultTextStyle(
                        style: theme.textTheme.subtitle,
                        textAlign: TextAlign.start,
                        child: GradientText(
                          gradient: theme.textTheme.subtitleGradient,
                          child: title,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
