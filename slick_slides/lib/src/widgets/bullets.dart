// import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

const _defaultBulletSpacing = 0.8;

/// A widget that displays a list of bullets. [numVisibleBullets] can be used to
/// control how many bullets should be displayed. The rest of the bullets will
/// be hidden, but will still take up space.
class Bullets extends StatelessWidget {
  /// Creates a widget that displays a list of bullets. [numVisibleBullets] can
  /// be used to control how many bullets should be displayed. The rest of the
  /// bullets will be hidden, but will still take up space.
  factory Bullets({
    required List<String> bullets,
    int? numVisibleBullets,
    double bulletSpacing = _defaultBulletSpacing,
    EdgeInsets? padding,
    Key? key,
  }) {
    var richBullets = bullets.map((e) => TextSpan(text: e)).toList();
    return Bullets.rich(
      bullets: richBullets,
      numVisibleBullets: numVisibleBullets,
      bulletSpacing: bulletSpacing,
      padding: const EdgeInsets.symmetric(vertical: 50),
      key: key,
    );
  }

  /// Creates a widget that displays a list of bullets. [numVisibleBullets] can
  /// be used to control how many bullets should be displayed. The rest of the
  /// bullets will be hidden, but will still take up space. This constructor
  /// uses [TextSpan]s instead of [String]s for the bullets to allow for rich
  /// text.
  const Bullets.rich({
    required this.bullets,
    this.numVisibleBullets,
    this.bulletSpacing = _defaultBulletSpacing,
    this.padding = const EdgeInsets.symmetric(vertical: 50),
    super.key,
  });

  /// The bullets to display.
  final List<TextSpan> bullets;

  /// The number of bullets to display. The rest of the bullets will be hidden,
  /// but will still take up space.
  final int? numVisibleBullets;

  /// The spacing between bullets.
  final double bulletSpacing;

  /// The padding around the bullets.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    var joinedBulletsList = <TextSpan>[];
    for (var i = 0; i < bullets.length; i++) {
      if (numVisibleBullets != null && i >= numVisibleBullets!) {
        joinedBulletsList.add(TextSpan(
          style: const TextStyle(color: Colors.transparent),
          children: [bullets[i]],
        ));
      } else {
        joinedBulletsList.add(bullets[i]);
      }

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
