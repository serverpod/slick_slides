import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

/// A transition that fades between slides. If [color] is specified, the
/// transition will fade through that color.
class SlickFadeTransition extends SlickTransition {
  /// Creates a transition that fades between slides. If [color] is specified,
  /// the transition will fade through that color.
  const SlickFadeTransition({
    super.duration = const Duration(milliseconds: 500),
    this.color,
  });

  /// The color to fade through. If null, the transition will fade between the
  /// two slides.
  final Color? color;

  @override
  PageRoute buildPageRoute(WidgetBuilder slideBuilder) {
    if (color == null) {
      return _FadePageRoute(
        builder: slideBuilder,
        duration: duration,
      );
    } else {
      return _FadeThroughColorPageRoute(
        builder: slideBuilder,
        duration: duration,
        color: color!,
      );
    }
  }
}

class _FadePageRoute<T> extends PageRoute<T> {
  _FadePageRoute({
    required this.builder,
    required this.duration,
  });
  final WidgetBuilder builder;
  final Duration duration;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => 'barrier';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}

class _FadeThroughColorPageRoute<T> extends PageRoute<T> {
  _FadeThroughColorPageRoute({
    required this.builder,
    required this.duration,
    required this.color,
  });
  final WidgetBuilder builder;
  final Duration duration;
  final Color color;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => 'barrier';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    var child = builder(context);
    return _FadeThroughColorTransition(
      color: color,
      animation: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}

class _FadeThroughColorTransition extends StatefulWidget {
  const _FadeThroughColorTransition({
    required this.child,
    required this.color,
    required this.animation,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final Animation<double> animation;

  @override
  _FadeThroughColorTransitionState createState() =>
      _FadeThroughColorTransitionState();
}

class _FadeThroughColorTransitionState extends State<
    _FadeThroughColorTransition> /*with SingleTickerProviderStateMixin*/ {
  @override
  void initState() {
    super.initState();

    widget.animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation.value == 1.0) {
      return widget.child;
    } else if (widget.animation.value < 0.5) {
      var opacity = widget.animation.value * 2;
      return Container(
        color: widget.color.withOpacity(opacity),
      );
    } else {
      var opacity = (1 - widget.animation.value) * 2;
      return Stack(
        children: [
          widget.child,
          Container(
            color: widget.color.withOpacity(opacity),
          )
        ],
      );
    }
  }
}
