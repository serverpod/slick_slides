import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

/// Represents a code snippet with optionally highlighted lines.
class FormattedCode {
  /// Creates a code snippet with optionally highlighted lines.
  FormattedCode({
    required this.code,
    this.highlightedLines = const [],
  });

  /// The code snippet.
  final String code;

  /// The lines to highlight.
  final List<int> highlightedLines;
}

/// A slide that displays code and optionally animates between code snippets.
class AnimatedCodeSlide extends Slide {
  /// Creates a slide that displays code and optionally animates between code
  /// snippets. Takes a list of [FormattedCode] objects, each of which contains
  /// a code snippet and optionally highlighted lines.
  AnimatedCodeSlide({
    String? title,
    String? subtitle,
    required List<FormattedCode> formattedCode,
    String language = 'dart',
    WidgetBuilder? backgroundBuilder,
    String? notes,
    SlickTransition? transition,
    SlideThemeData? theme,
    Duration? autoplayDuration,
    Source? audioSource,
  }) : super.withSubSlides(
          builder: (context, index) {
            var highlightedLines = formattedCode[index].highlightedLines;
            var code = formattedCode[index].code;

            Widget content;
            if (index == 0) {
              content = ColoredCode(
                code: code,
                language: language,
                highlightedLines: highlightedLines,
              );
            } else {
              content = ColoredCode(
                animateFromCode: formattedCode[index - 1].code,
                code: code,
                language: language,
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
          subSlideCount: formattedCode.length,
          notes: notes,
          transition: transition,
          theme: theme,
          autoplayDuration: autoplayDuration,
          audioSource: audioSource,
        );
}
