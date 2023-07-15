import 'package:flutter/material.dart';
import 'package:slick_slides/src/deck/theme.dart';
import 'package:slick_slides/src/widgets/gradient_text.dart';

class TitleSlide extends StatelessWidget {
  const TitleSlide({
    required this.title,
    this.subtitle,
    this.background,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    return Stack(
      children: [
        background ?? theme.backgroundBuilder(context),
        Padding(
          padding: theme.borderPadding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: theme.textTheme.title,
                  textAlign: TextAlign.center,
                  child: GradientText(
                    gradient: theme.textTheme.titleGradient,
                    child: title,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DefaultTextStyle(
                      style: theme.textTheme.subtitle,
                      textAlign: TextAlign.center,
                      child: GradientText(
                        gradient: theme.textTheme.subtitleGradient,
                        child: subtitle!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
