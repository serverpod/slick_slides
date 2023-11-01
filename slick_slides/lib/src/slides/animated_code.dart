import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

class FormattedCode {
  FormattedCode({
    required this.code,
    this.highlightedLines = const [],
  });
  final String code;
  final List<int> highlightedLines;
}

class AnimatedCodeSlide extends Slide {
  AnimatedCodeSlide({
    String? title,
    String? subtitle,
    required List<FormattedCode> formatttedCode,
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super.withSubSlides(
          builder: (context, index) {
            var highlightedLines = formatttedCode[index].highlightedLines;
            var code = formatttedCode[index].code;

            Widget content;
            if (index == 0) {
              content = ColoredCode(
                code: code,
                highlightedLines: highlightedLines,
              );
            } else {
              content = ColoredCode(
                animateFromCode: formatttedCode[index - 1].code,
                code: code,
                highlightedLines: highlightedLines,
                animateHighlightedLines: true,
              );
            }

            return ContentLayout(
              title: title == null ? null : Text(title),
              subtitle: subtitle == null ? null : Text(subtitle),
              background: backgroundBuilder?.call(context),
              content: content,
            );
          },
          subSlideCount: formatttedCode.length,
          notes: notes,
          transition: transition,
          theme: theme,
        );
}
