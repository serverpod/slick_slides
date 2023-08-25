import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

class PersonSlide extends StatelessWidget {
  const PersonSlide({
    required this.name,
    required this.title,
    this.background,
    required this.image,
    Key? key,
  }) : super(key: key);

  final Widget name;
  final Widget title;
  final Widget? background;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    return Stack(
      children: [
        background ?? theme.backgroundBuilder(context),
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
