import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  const FadeIn({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.afterDuration = const Duration(milliseconds: 250),
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Duration afterDuration;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  var _visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(widget.afterDuration, () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
