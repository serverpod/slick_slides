import 'package:flutter/material.dart';

import 'package:slick_slides/slick_slides.dart';

class PersonSlide extends Slide {
  PersonSlide({
    required String title,
    required String name,
    required ImageProvider image,
    String? notes,
    WidgetBuilder? backgroundBuilder,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super(
          builder: (context) {
            return PersonLayout(
              title: Text(title),
              name: Text(name),
              background: backgroundBuilder?.call(context),
              image: Image(
                image: image,
              ),
            );
          },
          onPrecache: (context) {
            precacheImage(
              image,
              context,
            );
          },
          notes: notes,
          transition: transition,
          theme: theme,
        );

  PersonSlide.rich({
    required TextSpan title,
    required TextSpan name,
    required ImageProvider image,
    String? notes,
    WidgetBuilder? backgroundBuilder,
    SlickTransition? transition,
    final SlideThemeData? theme,
  }) : super(
          builder: (context) {
            return PersonLayout(
              title: Text.rich(title),
              name: Text.rich(name),
              background: backgroundBuilder?.call(context),
              image: Image(
                image: image,
              ),
            );
          },
          onPrecache: (context) {
            precacheImage(
              image,
              context,
            );
          },
          notes: notes,
          transition: transition,
          theme: theme,
        );
}
