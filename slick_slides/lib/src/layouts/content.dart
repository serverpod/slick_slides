import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

class ContentLayout extends StatelessWidget {
  const ContentLayout({
    this.title,
    this.subtitle,
    this.content,
    this.background,
    super.key,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? background;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    return Stack(
      children: [
        background ?? theme.backgroundBuilder(context),
        Padding(
          padding: theme.borderPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                DefaultTextStyle(
                  style: theme.textTheme.title,
                  child: GradientText(
                    gradient: theme.textTheme.titleGradient,
                    child: title!,
                  ),
                ),
              if (title != null && subtitle != null)
                SizedBox(height: theme.subtitleSpacing),
              if (subtitle != null)
                DefaultTextStyle(
                  style: theme.textTheme.subtitle,
                  child: GradientText(
                    gradient: theme.textTheme.subtitleGradient,
                    child: subtitle!,
                  ),
                ),
              if (title != null || subtitle != null)
                SizedBox(height: theme.titleSpacing),
              if (content != null) Expanded(child: content!),
            ],
          ),
        ),
      ],
    );
  }
}
