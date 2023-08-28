import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slick_slides/slick_slides.dart';
import 'package:slick_slides/src/deck/deck_controls.dart';
import 'package:slick_slides/src/deck/slide_config.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class SlickSlides {
  static final highlighters = <String, Highlighter>{};

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

class Slide {
  const Slide({
    required this.builder,
    this.name,
    this.transition,
    this.theme,
    this.onPrecache,
  });

  final WidgetBuilder builder;
  final String? name;
  final SlickTransition? transition;
  final SlideThemeData? theme;
  final void Function(BuildContext context)? onPrecache;
}

class SlideDeck extends StatefulWidget {
  const SlideDeck({
    required this.slides,
    this.theme = const SlideThemeData.dark(),
    this.size = const Size(1920, 1080),
    super.key,
  });

  final List<Slide> slides;
  final SlideThemeData theme;
  final Size size;

  @override
  State<SlideDeck> createState() => SlideDeckState();
}

class SlideDeckState extends State<SlideDeck> {
  int _index = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();

  final _focusNode = FocusNode();
  Timer? _controlsTimer;
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
  }

  void _precacheSlide(int index) {
    if (index >= widget.slides.length || index < 0) {
      return;
    }
    var slide = widget.slides[index];
    slide.onPrecache?.call(context);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void _onChangeSlide(int delta) {
    var newIndex = _index + delta;
    if (newIndex >= widget.slides.length) {
      newIndex = widget.slides.length - 1;
    } else if (newIndex < 0) {
      newIndex = 0;
    }
    if (_index != newIndex) {
      // Precache the next and previous slides.
      _precacheSlide(newIndex - 1);
      _precacheSlide(newIndex + 1);

      setState(() {
        _index = newIndex;
        _navigatorKey.currentState?.pushReplacementNamed(
          '$_index',
          arguments: delta > 0,
        );
      });
      _index = newIndex;
    }
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
    if (_index >= widget.slides.length) {
      _index = widget.slides.length - 1;
    }

    return Focus(
      focusNode: _focusNode,
      onKey: (node, event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _onChangeSlide(1);
        } else if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _onChangeSlide(-1);
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
                            initialRoute: '0',
                            onGenerateRoute: _generateRoute,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.0,
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
                        onPrevious: () {
                          _onChangeSlide(-1);
                        },
                        onNext: () {
                          _onChangeSlide(1);
                        },
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
    var index = int.tryParse(settings.name ?? '0') ?? 0;
    var slide = widget.slides[index];
    var transition = slide.transition;
    var animate = settings.arguments as bool? ?? true;

    if (transition == null || !animate) {
      return PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (context, _, __) {
            var slideWidget = slide.builder(context);
            if (slide.theme != null) {
              slideWidget = SlideTheme(
                data: slide.theme!,
                child: slideWidget,
              );
            }

            return SlideConfig(
              data: SlideConfigData(
                animateIn: animate,
              ),
              child: slideWidget,
            );
          });
    } else {
      return transition.buildPageRoute((context) {
        var slideWidget = slide.builder(context);
        if (slide.theme != null) {
          slideWidget = SlideTheme(
            data: slide.theme!,
            child: slideWidget,
          );
        }
        return slideWidget;
      });
    }
  }
}
