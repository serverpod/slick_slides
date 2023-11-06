import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

/// A basic layout for a slide. It can have a title, subtitle, and content.
class ContentLayout extends StatelessWidget {
  /// Creates a basic layout for a slide. It can have a title, subtitle, and
  /// content. This layout is used by most types of slides.
  const ContentLayout({
    this.title,
    this.subtitle,
    this.content,
    this.background,
    super.key,
  });

  /// The title of the slide.
  final Widget? title;

  /// The subtitle of the slide.
  final Widget? subtitle;

  /// The background of the slide.
  final Widget? background;

  /// The content of the slide.
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    return Stack(
      children: [
        Positioned.fill(
          child: background ?? theme.backgroundBuilder(context),
        ),
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
