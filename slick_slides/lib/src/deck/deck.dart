import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:slick_slides/slick_slides.dart';
import 'package:slick_slides/src/deck/deck_controls.dart';
import 'package:slick_slides/src/deck/slide_config.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

/// Builds the content of a slide, when there are more than one sub-slide.
typedef SubSlideWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// A class that initializes the `slick_slides` package, by loading required
/// resources.
class SlickSlides {
  /// A [Map] of all code highlighters accessible by [SlickSlides].
  static final highlighters = <String, Highlighter>{};

  /// Initializes the `slick_slides` package, by loading required resources.
  /// Typically called in the `main()` function of the application, after
  /// `WidgetsFlutterBinding.ensureInitialized()` has been called.
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Highlighter.initialize(['dart', 'yaml']);
    var theme = await HighlighterTheme.loadDarkTheme();

    highlighters['dart'] = Highlighter(
      language: 'dart',
      theme: theme,
    );

    highlighters['yaml'] = Highlighter(
      language: 'yaml',
      theme: theme,
    );
  }
}

/// Represents a single slide in a [SlideDeck]. A slide has a [builder] that
/// builds the content of the slide, and an optional [notes] field that can be
/// used to add presenter notes to the slide. By default, a slide uses the
/// main theme of the [SlideDeck], but a [theme] can be specified to override
/// the theme for a single slide. You can also specify a [transition] to use
/// when transitioning to the slide.
class Slide {
  /// Creates a new slide with a [builder] that builds the content of the slide.
  /// The [onPrecache] callback is called when the slide is about to be shown,
  /// and can be used to load resources that are needed for the slide.
  const Slide({
    required WidgetBuilder builder,
    this.notes,
    this.transition,
    this.theme,
    this.onPrecache,
    this.autoplayDuration,
  })  : _builder = builder,
        _subSlideBuilder = null,
        subSlideCount = 1,
        hasSubSlides = false;

  /// Creates a new slide with a [builder] that builds the content of the slide
  /// consisting of sub slides which are built step-by-step. The [onPrecache]
  /// callback is called when the slide is about to be shown, and can be used to
  /// load resources that are needed for the slide.
  const Slide.withSubSlides({
    required SubSlideWidgetBuilder builder,
    required this.subSlideCount,
    this.notes,
    this.transition,
    this.theme,
    this.onPrecache,
    this.autoplayDuration,
  })  : _subSlideBuilder = builder,
        _builder = null,
        hasSubSlides = true;

  final WidgetBuilder? _builder;
  final SubSlideWidgetBuilder? _subSlideBuilder;

  /// The presenter notes for the slide.
  final String? notes;

  /// The transition to use when transitioning to the slide.
  final SlickTransition? transition;

  /// The theme to use for the slide. If not specified, the main theme of the
  /// [SlideDeck] is used.
  final SlideThemeData? theme;

  /// Called when the slide is about to be shown, and can be used to load
  /// resources that are needed for the slide.
  final void Function(BuildContext context)? onPrecache;

  /// The number of sub slides in the slide. Will always be 1 if the slide
  /// doesn't have sub slides.
  final int subSlideCount;

  /// Whether the slide has sub slides.
  final bool hasSubSlides;

  /// The duration to wait before automatically advancing to the next slide.
  /// If null, the [SlideDeck] will fallback to use the
  /// [SlideDeck.autoplayDuration].
  final Duration? autoplayDuration;
}

/// A deck of slides. It takes a list of [Slide]s, and builds the content of the
/// slides using the [Slide.builder] callback. The [SlideDeck] widget also
/// handles navigation between the slides, and provides a default theme for the
/// slides.
class SlideDeck extends StatefulWidget {
  /// Creates a new slide deck with the given [slides]. The [theme] is the
  /// default theme for all slides, and can be overridden for individual slides
  /// by specifying a [Slide.theme]. The [size] represents the coordinate space
  /// of the slides, and is used to scale the slides to fit the screen.
  const SlideDeck({
    required this.slides,
    this.theme = const SlideThemeData.dark(),
    this.size = const Size(1920, 1080),
    this.autoplay = false,
    this.autoplayDuration = const Duration(seconds: 5),
    super.key,
  });

  /// The slides in the deck.
  final List<Slide> slides;

  /// The default theme for the slides.
  final SlideThemeData theme;

  /// The size of the slides.
  final Size size;

  /// Whether the slides should automatically advance to the next slide.
  final bool autoplay;

  /// The duration to wait before automatically advancing to the next slide.
  final Duration autoplayDuration;

  @override
  State<SlideDeck> createState() => SlideDeckState();
}

class _SlideIndex {
  const _SlideIndex(this.index, this.subIndex);

  _SlideIndex.fromString(String value)
      : index = int.parse(value.split(':')[0]),
        subIndex = int.parse(value.split(':')[1]);

  const _SlideIndex.first()
      : index = 0,
        subIndex = 0;

  final int index;
  final int subIndex;

  _SlideIndex next({
    required List<Slide> slides,
    bool loop = false,
  }) {
    var subSlideCount = slides[index].subSlideCount;

    if (subIndex + 1 < subSlideCount) {
      return _SlideIndex(index, subIndex + 1);
    } else if (index + 1 < slides.length) {
      return _SlideIndex(index + 1, 0);
    } else if (loop) {
      return const _SlideIndex.first();
    } else {
      return this;
    }
  }

  _SlideIndex prev({
    required List<Slide> slides,
  }) {
    if (index > 0) {
      return _SlideIndex(index - 1, slides[index - 1].subSlideCount - 1);
    } else {
      return this;
    }
  }

  @override
  String toString() {
    return '$index:$subIndex';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SlideIndex &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          subIndex == other.subIndex;

  @override
  int get hashCode => index.hashCode ^ subIndex.hashCode * 5179;
}

class _SlideArguments {
  const _SlideArguments({
    required this.animateContents,
    required this.animateTransition,
  });

  final bool animateContents;
  final bool animateTransition;
}

/// The state of a [SlideDeck].
class SlideDeckState extends State<SlideDeck> {
  _SlideIndex _index = const _SlideIndex(0, 0);

  final _navigatorKey = GlobalKey<NavigatorState>();

  final _focusNode = FocusNode();
  Timer? _controlsTimer;
  Timer? _autoplayTimer;
  bool _mouseMovedRecently = false;
  bool _mouseInsideControls = false;

  final _heroController = MaterialApp.createMaterialHeroController();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheSlide(1);
    });

    if (widget.autoplay) {
      _startAutoplay();
    }
  }

  @override
  void didUpdateWidget(SlideDeck oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.autoplay != oldWidget.autoplay) {
      if (widget.autoplay) {
        _startAutoplay();
      } else {
        _stopAutoplay();
      }
    }
  }

  void _precacheSlide(int index) {
    if (index >= widget.slides.length || index < 0) {
      return;
    }
    var slide = widget.slides[index];
    slide.onPrecache?.call(context);
  }

  Duration get _currentSubSlideDuration {
    var currentSlide = widget.slides[_index.index];
    var slideDuration =
        currentSlide.autoplayDuration ?? widget.autoplayDuration;
    var numSubSlides = currentSlide.subSlideCount;
    return slideDuration ~/ numSubSlides;
  }

  void _startAutoplay() {
    var duration = _currentSubSlideDuration;
    _autoplayTimer = Timer(duration, () {
      _onNext();
      _startAutoplay();
    });
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controlsTimer?.cancel();
    _autoplayTimer?.cancel();
  }

  @override
  void reassemble() {
    super.reassemble();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _navigatorKey.currentState?.pushReplacement(
        _generateRoute(RouteSettings(name: '$_index')),
      );
    });
  }

  void _onChangeSlide(_SlideIndex newIndex, _SlideArguments arguments) {
    if (_index != newIndex) {
      // Precache the next and previous slides.
      _precacheSlide(newIndex.index - 1);
      _precacheSlide(newIndex.index + 1);

      setState(() {
        _index = newIndex;
        _navigatorKey.currentState?.pushReplacementNamed(
          '$_index',
          arguments: arguments,
        );
      });
      _index = newIndex;
    }
  }

  void _onNext() {
    var nextIndex = _index.next(
      slides: widget.slides,
      loop: widget.autoplay,
    );

    _onChangeSlide(
      nextIndex,
      _SlideArguments(
        animateContents: true,
        animateTransition: _index.index != nextIndex.index,
      ),
    );
  }

  void _onPrevious() {
    _onChangeSlide(
      _index.prev(
        slides: widget.slides,
      ),
      const _SlideArguments(
        animateContents: false,
        animateTransition: false,
      ),
    );
  }

  void _onMouseMoved() {
    if (_controlsTimer != null) {
      _controlsTimer!.cancel();
    }
    _controlsTimer = Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) {
          return;
        }
        setState(() {
          _mouseMovedRecently = false;
        });
      },
    );
    if (!_mouseMovedRecently) {
      setState(() {
        _mouseMovedRecently = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_index.index >= widget.slides.length) {
      _index = _SlideIndex(widget.slides.length - 1, 1);
    }

    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _onNext();
        } else if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _onPrevious();
        }
        return KeyEventResult.handled;
      },
      child: MouseRegion(
        onEnter: (event) => _onMouseMoved(),
        onHover: (event) => _onMouseMoved(),
        child: Container(
          color: Colors.black,
          child: Center(
            child: AspectRatio(
              aspectRatio: widget.size.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: widget.size.width,
                      height: widget.size.height,
                      child: SlideTheme(
                        data: widget.theme,
                        child: HeroControllerScope(
                          controller: _heroController,
                          child: Navigator(
                            key: _navigatorKey,
                            initialRoute: '${const _SlideIndex.first()}',
                            onGenerateRoute: _generateRoute,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!widget.autoplay)
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: MouseRegion(
                        onEnter: (event) {
                          setState(() {
                            _mouseInsideControls = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            _mouseInsideControls = false;
                          });
                        },
                        child: DeckControls(
                          visible: _mouseMovedRecently || _mouseInsideControls,
                          onPrevious: _onPrevious,
                          onNext: _onNext,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Route _generateRoute(RouteSettings settings) {
    var index = _SlideIndex.fromString(
      settings.name ?? '${const _SlideIndex.first()}',
    );
    var slide = widget.slides[index.index];
    var transition = slide.transition;
    var arguments = settings.arguments as _SlideArguments? ??
        const _SlideArguments(animateContents: false, animateTransition: false);

    if (transition == null || !arguments.animateTransition) {
      return PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, _, __) {
            var slideWidget = slide.hasSubSlides
                ? slide._subSlideBuilder!(context, index.subIndex)
                : slide._builder!(context);
            if (slide.theme != null) {
              slideWidget = SlideTheme(
                data: slide.theme!,
                child: slideWidget,
              );
            }

            return SlideConfig(
              data: SlideConfigData(
                animateIn: arguments.animateContents,
              ),
              child: slideWidget,
            );
          });
    } else {
      return transition.buildPageRoute((context) {
        var slideWidget = slide.hasSubSlides
            ? slide._subSlideBuilder!(context, index.subIndex)
            : slide._builder!(context);
        if (slide.theme != null) {
          slideWidget = SlideTheme(
            data: slide.theme!,
            child: slideWidget,
          );
        }
        return SlideConfig(
          data: SlideConfigData(
            animateIn: arguments.animateContents,
          ),
          child: slideWidget,
        );
      });
    }
  }
}
