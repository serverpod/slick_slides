import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';
import 'package:slick_slides/src/deck/slide_config.dart';

const _dimmedCodeOpacity = 0.3;
const _dimCodeDuration = Duration(milliseconds: 500);

/// A widget that displays and optionally animates code with syntax
/// highlighting.
class ColoredCode extends StatefulWidget {
  /// Creates a widget that displays and optionally animates code with syntax
  /// highlighting. Set the [animateFromCode] property to animate between two
  /// code snippets.
  const ColoredCode({
    required this.code,
    this.animateFromCode,
    this.language = 'dart',
    this.tabSize = 2,
    this.textStyle,
    this.highlightedLines = const [],
    this.maxAnimationDuration = const Duration(milliseconds: 2000),
    this.keystrokeDuration = const Duration(milliseconds: 50),
    this.animateHighlightedLines = false,
    super.key,
  });

  /// The code to display, or the final code if [animateFromCode] is set.
  final String code;

  /// The code to animate from. The final displayed code will be [code].
  final String? animateFromCode;

  /// The language to use for syntax highlighting. Defaults to 'dart'.
  final String language;

  /// The number of spaces to use for tabs. Defaults to 2.
  final int tabSize;

  /// The text style to use for the code. Defaults to the default style of the
  /// build context.
  final TextStyle? textStyle;

  /// Maximum duration of the animation. Defaults to 2 seconds.
  final Duration maxAnimationDuration;

  /// Duration of each keystroke animation. Defaults to 50 milliseconds.
  final Duration keystrokeDuration;

  /// The lines to highlight at the end of the animation.
  final List<int> highlightedLines;

  /// Whether to animate the highlighted lines. Defaults to false.
  final bool animateHighlightedLines;

  @override
  State<ColoredCode> createState() => _ColoredCodeState();
}

class _ColoredCodeState extends State<ColoredCode>
    with TickerProviderStateMixin {
  late AnimationController _typingController;
  late AnimationController _highlightController;
  int _numOperations = 0;
  List<Diff>? _diff;

  @override
  void initState() {
    super.initState();

    _typingController = AnimationController(
      vsync: this,
      value: 0.0,
    );
    _typingController.addListener(() {
      setState(() {});
      if (_typingController.isCompleted &&
          widget.animateHighlightedLines &&
          widget.highlightedLines.isNotEmpty) {
        // Start animating the highlighted lines after the typing animation
        // completes.
        _highlightController.animateTo(
          _dimmedCodeOpacity,
          duration: const Duration(milliseconds: 500),
        );
      }
    });

    _highlightController = AnimationController(
      vsync: this,
      value: 1.0,
    );
    _highlightController.addListener(() {
      setState(() {});
    });

    if (widget.animateFromCode != null ||
        (widget.highlightedLines.isNotEmpty &&
            widget.animateHighlightedLines)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimations();
      });
    } else {
      _highlightController.value = _dimmedCodeOpacity;
    }
  }

  void _startAnimations() {
    if (!_animateIn) {
      return;
    }

    if (widget.animateFromCode != null) {
      var numOperations = 0;
      _diff = DiffMatchPatch().diff(widget.animateFromCode!, widget.code);
      for (var d in _diff!) {
        if (d.operation == DIFF_DELETE) {
          numOperations += 1;
        } else if (d.operation == DIFF_INSERT) {
          numOperations += d.text.length;
        }
      }
      _numOperations = numOperations;
      var totalMs = numOperations * widget.keystrokeDuration.inMilliseconds;
      if (totalMs > widget.maxAnimationDuration.inMilliseconds) {
        totalMs = widget.maxAnimationDuration.inMilliseconds;
      }
      var duration = Duration(milliseconds: totalMs);
      _typingController.animateTo(
        1.0,
        duration: duration,
      );
    } else if (widget.highlightedLines.isNotEmpty &&
        widget.animateHighlightedLines) {
      // Start animating the highlighted lines immediately.
      _highlightController.value = 1.0;
      _highlightController.animateTo(
        _dimmedCodeOpacity,
        duration: _dimCodeDuration,
      );
    }
  }

  bool get _animateIn {
    var config = SlideConfig.of(context);
    return config?.animateIn ?? true;
  }

  @override
  void dispose() {
    _typingController.dispose();
    _highlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = SlideTheme.of(context)!;

    String animatedCode;
    if (_typingController.isAnimating &&
        widget.animateFromCode != null &&
        _diff != null) {
      animatedCode = _getAnimatedCode(
        (_typingController.value * _numOperations).floor(),
      );
    } else if (_animateIn &&
        widget.animateFromCode != null &&
        _typingController.value == 0.0) {
      animatedCode = widget.animateFromCode!;
    } else {
      animatedCode = widget.code;
    }

    var highlightedText =
        SlickSlides.highlighters[widget.language]!.highlight(animatedCode);

    var coloredCode = Text.rich(
      highlightedText,
    );

    if (widget.highlightedLines.isEmpty) {
      return DefaultTextStyle(
        style: theme.textTheme.code,
        child: coloredCode,
      );
    }

    var codeLines = animatedCode.split('\n');
    var numLines = codeLines.length;

    var fadedColoredCode = Text.rich(
      highlightedText,
    );

    if (!_animateIn || !widget.animateHighlightedLines) {
      _highlightController.value = _dimmedCodeOpacity;
    }

    return DefaultTextStyle(
      style: theme.textTheme.code,
      child: Stack(
        children: [
          ClipPath(
            clipper: _HighlightedLinesClipper(
              numLines: numLines,
              highlightedLines: widget.highlightedLines,
              invert: false,
            ),
            child: coloredCode,
          ),
          Opacity(
            opacity: _highlightController.value,
            child: ClipPath(
              clipper: _HighlightedLinesClipper(
                numLines: numLines,
                highlightedLines: widget.highlightedLines,
                invert: true,
              ),
              child: fadedColoredCode,
            ),
          ),
        ],
      ),
    );
  }

  String _getAnimatedCode(int frame) {
    frame.clamp(0, _numOperations - 1);

    // Animate insertions and deletions.
    int operationCount = 0;
    int diffIdx = 0;
    int characterIdx = 0;
    var animatedCode = '';
    bool containsNewline = false;
    while (operationCount < frame) {
      var diff = _diff![diffIdx];

      if (diff.operation == DIFF_EQUAL) {
        // Equal.
        animatedCode += diff.text;
        diffIdx += 1;
      } else if (diff.operation == DIFF_DELETE) {
        // Delete.
        diffIdx += 1;
        operationCount += 1;
      } else {
        // Insert.
        animatedCode += diff.text.substring(characterIdx, characterIdx + 1);
        if (diff.text.contains('\n')) {
          containsNewline = true;
        }

        characterIdx += 1;
        operationCount += 1;
        if (characterIdx == diff.text.length) {
          diffIdx += 1;
          characterIdx = 0;
          containsNewline = false;
        }
      }
    }

    if (containsNewline) {
      animatedCode += '\n';
    }

    // Add remaining old code.
    while (diffIdx < _diff!.length) {
      var diff = _diff![diffIdx];
      if (diff.operation == DIFF_EQUAL) {
        // Equal.
        animatedCode += diff.text;
      } else if (diff.operation == DIFF_DELETE) {
        // Delete.
        animatedCode += diff.text;
      }
      diffIdx += 1;
    }

    return animatedCode;
  }
}

class _HighlightedLinesClipper extends CustomClipper<Path> {
  _HighlightedLinesClipper({
    required this.numLines,
    required this.highlightedLines,
    required this.invert,
  });

  final int numLines;
  final List<int> highlightedLines;
  final bool invert;

  @override
  Path getClip(Size size) {
    var path = Path();
    var lineHeight = size.height / numLines;
    for (var i = 0; i < numLines; i++) {
      if (highlightedLines.contains(i) != invert) {
        var y = i * lineHeight;
        path.addRect(
          Rect.fromLTWH(0.0, y, size.width, lineHeight),
        );
      }
    }
    return path;
  }

  @override
  bool shouldReclip(_HighlightedLinesClipper oldClipper) {
    return oldClipper.highlightedLines != highlightedLines;
  }
}
