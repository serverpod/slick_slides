import 'package:flutter/material.dart';

/// Controls for navigating between slides in a [SlideDeck]. The controls fade
/// in and out based on the [visible] property.
class DeckControls extends StatefulWidget {
  /// Creates a [DeckControls].
  const DeckControls({
    required this.onPrevious,
    required this.onNext,
    this.visible = true,
    super.key,
  });

  /// Called when the previous button is pressed.
  final VoidCallback onPrevious;

  /// Called when the next button is pressed.
  final VoidCallback onNext;

  /// Whether the controls are visible.
  final bool visible;

  @override
  State<DeckControls> createState() => _DeckControlsState();
}

class _DeckControlsState extends State<DeckControls>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _visible = widget.visible;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _visible ? 1 : 0,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(DeckControls oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.visible != oldWidget.visible) {
      setState(() {
        _visible = widget.visible;
        if (_visible) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _controller.value,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(4),
              ),
              onPressed: widget.onPrevious,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(4),
              ),
              onPressed: widget.onNext,
              child: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
