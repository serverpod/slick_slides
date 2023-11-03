import 'package:flutter/material.dart';

/// An extension which adds extra functionality to [TextSpan].
extension TextSpanExtension on TextSpan {
  /// Returns a copy of this [TextSpan] with the given [opacity] applied.
  TextSpan copyWithOpacity(double opacity) {
    TextStyle? newStyle;
    if (style != null && style!.color != null) {
      var oldOpacity = style!.color!.opacity;
      newStyle = style!.copyWith(
        color: style!.color!.withOpacity(opacity * oldOpacity),
      );
    }

    List<InlineSpan>? newChildren;
    if (children != null) {
      newChildren = children!.map((child) {
        if (child is TextSpan) {
          return child.copyWithOpacity(opacity);
        }
        return child;
      }).toList();
    }

    return TextSpan(
      text: text,
      children: newChildren,
      style: newStyle,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
      mouseCursor: mouseCursor,
      onEnter: onEnter,
      onExit: onExit,
      locale: locale,
      spellOut: spellOut,
    );
  }
}
