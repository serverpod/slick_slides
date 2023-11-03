// import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';
import 'package:slick_slides/src/deck/slide_config.dart';
import 'package:slick_slides/src/extensions/text_span.dart';

const _defaultBulletSpacing = 0.8;

/// A widget that displays a list of bullets. [numVisibleBullets] can be used to
/// control how many bullets should be displayed. The rest of the bullets will
/// be hidden, but will still take up space.
class Bullets extends StatefulWidget {
  /// Creates a widget that displays a list of bullets. [numVisibleBullets] can
  /// be used to control how many bullets should be displayed. The rest of the
  /// bullets will be hidden, but will still take up space.
  factory Bullets({
    required List<String> bullets,
    int? numVisibleBullets,
    double bulletSpacing = _defaultBulletSpacing,
    EdgeInsets? padding,
    bool animateLastVisibleBullet = false,
    Key? key,
  }) {
    var richBullets = bullets.map((e) => TextSpan(text: e)).toList();
    return Bullets.rich(
      bullets: richBullets,
      numVisibleBullets: numVisibleBullets,
      bulletSpacing: bulletSpacing,
      padding: const EdgeInsets.symmetric(vertical: 50),
      animateLastVisibleBullet: animateLastVisibleBullet,
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
    this.animateLastVisibleBullet = false,
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

  /// If true, fade in the last bullet.
  final bool animateLastVisibleBullet;

  @override
  State<Bullets> createState() => _BulletsState();
}

class _BulletsState extends State<Bullets> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.animateLastVisibleBullet) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _controller!.addListener(() {
        setState(() {});
      });
      _controller!.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;
    var config = SlideConfig.of(context)!;
    var defaultTextColor = theme.textTheme.body.color!;

    var animate = config.animateIn && _controller != null;

    var joinedBulletsList = <TextSpan>[];
    for (var i = 0; i < widget.bullets.length; i++) {
      if (animate) {
        // Animating last bullet.
        if (widget.numVisibleBullets != null &&
            i >= widget.numVisibleBullets!) {
          // Draw bullets with transparent color if they are not visible.
          joinedBulletsList.add(
            TextSpan(
              style: const TextStyle(color: Colors.transparent),
              children: [widget.bullets[i].copyWithOpacity(0)],
            ),
          );
        } else if (widget.numVisibleBullets != null &&
            i == widget.numVisibleBullets! - 1) {
          // Fade in the last bullet.
          var opacity = _controller!.value;

          joinedBulletsList.add(
            TextSpan(
              style: TextStyle(
                color: defaultTextColor.withOpacity(opacity),
              ),
              children: [
                widget.bullets[i].copyWithOpacity(opacity),
              ],
            ),
          );
        } else {
          // Draw bullets with normal color if they are visible.
          joinedBulletsList.add(widget.bullets[i]);
        }
      } else {
        // Do not animate last bullet.
        if (widget.numVisibleBullets != null &&
            i >= widget.numVisibleBullets!) {
          // Draw bullets with transparent color if they are not visible.
          joinedBulletsList.add(
            TextSpan(
              style: const TextStyle(color: Colors.transparent),
              children: [widget.bullets[i]],
            ),
          );
        } else {
          // Draw bullets with normal color if they are visible.
          joinedBulletsList.add(widget.bullets[i]);
        }
      }

      // Add a new line between bullets.
      if (i != widget.bullets.length - 1) {
        joinedBulletsList.addAll([
          const TextSpan(
            text: '\n',
          ),
          TextSpan(
            text: '\n',
            style: TextStyle(
              height: widget.bulletSpacing,
            ),
          ),
        ]);
      }
    }

    var joinedBullets = TextSpan(
      children: joinedBulletsList,
    );

    return Padding(
      padding: widget.padding,
      child: DefaultTextStyle(
        style: theme.textTheme.body,
        child: AutoSizeText.rich(joinedBullets),
      ),
    );
  }
}
