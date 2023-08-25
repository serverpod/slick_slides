// import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

const _defaultBulletSpacing = 0.8;

class Bullets extends StatelessWidget {
  factory Bullets({
    required List<String> bullets,
    double bulletSpacing = _defaultBulletSpacing,
    EdgeInsets? padding,
    Key? key,
  }) {
    var richBullets = bullets.map((e) => TextSpan(text: e)).toList();
    return Bullets.rich(
      bullets: richBullets,
      bulletSpacing: bulletSpacing,
      padding: const EdgeInsets.symmetric(vertical: 50),
      key: key,
    );
  }

  const Bullets.rich({
    required this.bullets,
    this.bulletSpacing = _defaultBulletSpacing,
    this.padding = const EdgeInsets.symmetric(vertical: 50),
    super.key,
  });

  final List<TextSpan> bullets;
  final double bulletSpacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    var joinedBulletsList = <TextSpan>[];
    for (var i = 0; i < bullets.length; i++) {
      joinedBulletsList.add(bullets[i]);

      // Add a new line between bullets.
      if (i != bullets.length - 1) {
        joinedBulletsList.addAll([
          const TextSpan(
            text: '\n',
          ),
          TextSpan(
            text: '\n',
            style: TextStyle(
              height: bulletSpacing,
            ),
          ),
        ]);
      }
    }

    var joinedBullets = TextSpan(
      children: joinedBulletsList,
    );

    return Padding(
      padding: padding,
      child: DefaultTextStyle(
        style: theme.textTheme.body,
        child: AutoSizeText.rich(joinedBullets),
      ),
    );
  }
}
