import 'package:flutter/material.dart';
import 'package:slick_slides/slick_slides.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SlickSlides().initialize();
  runApp(const MyApp());
}

const _defaultTransition = SlickFadeTransition(
  color: Colors.black,
);

const _codeExampleA = '''class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
  }
}''';

const _codeExampleB = '''class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideDeck(
      slides: [
        Slide(
          builder: (context) {
            return const TitleSlide(
              title: Text('Slick Slides'),
              subtitle: Text('Stunning presentations in Flutter'),
            );
          },
        ),
      ],
    );
  }
}''';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slick Slides Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlideDeck(
      slides: [
        Slide(
          builder: (context) {
            return const TitleSlide(
              title: Text('Slick Slides'),
              subtitle: Text('Stunning presentations in Flutter'),
            );
          },
        ),
        Slide(
          transition: _defaultTransition,
          builder: (context) {
            return ContentSlide(
              title: const Text('What is Slick Slides?'),
              content: Bullets(
                bullets: const [
                  'Slick Slides was born out of the need to make nice looking '
                      'slides for Serverpod at the FlutterCon conference.',
                  'It comes with many built-in slide types, and is easy to '
                      'extend with your own.',
                  'Browse through the slides in this presentation to see '
                      'what it can do.',
                  'If you use Slick Slides for your presentation, please '
                      'give some credit to Serverpod for the work we put into '
                      'this package. Also, check out Serverpod if you haven\'t '
                      'already, it\'s a great way to build your backend in '
                      'Dart.',
                ],
              ),
            );
          },
        ),
        Slide(
          transition: _defaultTransition,
          builder: (context) {
            return PersonSlide(
              name: const Text('Philippa Flutterista'),
              title: const Text('Rockstar Flutter Developer'),
              image: Image.asset('assets/portrait.jpg'),
            );
          },
          onPrecache: (context) {
            precacheImage(
              const AssetImage('assets/portrait.jpg'),
              context,
            );
          },
        ),
        Slide(
          transition: _defaultTransition,
          theme: const SlideThemeData.light(),
          builder: (context) {
            return ContentSlide(
              title: const Text('Themes'),
              content: Bullets(
                bullets: const [
                  'Use the built in themes or create your own.',
                  'This is the default light theme.',
                ],
              ),
            );
          },
        ),
        Slide(
          transition: _defaultTransition,
          builder: (context) {
            return const ContentSlide(
              title: Text('Animated code'),
              content: ColoredCode(
                code: _codeExampleA,
              ),
            );
          },
        ),
        Slide(
          builder: (context) {
            return const ContentSlide(
              title: Text('Animated code'),
              content: ColoredCode(
                animateFromCode: _codeExampleA,
                code: _codeExampleB,
                animateHighlightedLines: true,
                highlightedLines: [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
              ),
            );
          },
        ),
      ],
    );
  }
}
