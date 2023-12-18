# Slick Slides

![Slick Slides Cover](https://raw.githubusercontent.com/serverpod/slick_slides/main/slick_slides/misc/cover.jpg)

Use this package to create slick presentations for your tech talk and presentations. It's great for beautifully formatting and animating code but also has support for title slides, images, or any other Flutter Widgets.

Slick Slides is created and maintained by the [Serverpod](https://serverpod.dev) team. Serverpod is a server written in Dart for the Flutter community, check it out if you haven't.

## Getting started
It's quick to setup Slick Slides. Just add the `slick_slides` package to your `pubspec.yaml` file, then follow the guide below.

### Include fonts
By default, Slick Slides uses _Inter_ and _Jetbrains Mono_ to display text and code. You will need to add them to your pubspec to make them accessible to the Slick Slides package. This is an example of what your `flutter` section in the `pubspec.yaml` file can look like with the fonts included. The fonts will be loaded to the package, so there is nothing more you need to do other than add the font references to your pubspec file.

```yaml
flutter:
  uses-material-design: true

  # Include fonts from slick_slides package.
  fonts:
    - family: Inter
      fonts:
        - asset: packages/slick_slides/fonts/inter.ttf
    - family: JetbrainsMono
      fonts:
        - asset: packages/slick_slides/fonts/jetbrainsmono.ttf

  # Include all assets from the assets directory.
  assets:
    - assets/
```

### Flutter code setup
Before using Slick Slides, you need to initialize it. This loads code formaters and any other required resources. If you initialize Slick Slides before you call `runApp`, you will need to call `WidgetsFlutterBinding.ensureInitialized()` before you call the `initialize` method.

```dart
WidgetsFlutterBinding.ensureInitialized();
await SlickSlides.initialize();
```

Now, you can add the `SlideDeck` widget anywhere in your widget tree, but for the normal use case, you use it as the home of your `MaterialApp`. The `SlideDeck` maintains its own navigator and theme for the slides.

To build your presentation, pass a number of `Slide` objects to the `SlideDeck` widget. The `Slide` objects contain builder methods for the slides, theme data, information about transitions, and other properties. There are a number of pre-made slides that you can very easily drop into your presentation, e.g., `TitleSlide`, `BulletsSlide`, `AnimatedCodeSlide`, and `PersonSlide`, but you can also create custom slides with any type of layout and content.

This is an example of a simple `SlideDeck` with two slides:

```dart
// Setup a default transition.
const _defaultTransition = SlickFadeTransition(
  color: Colors.black,
);

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Create a new SlideDeck with a TitleSlide and a BulletsSlide.
    return SlideDeck(
      slides: [
        TitleSlide(
          title: 'Slick Slides',
          subtitle: 'Stunning presentations in Flutter',
          transition: _defaultTransition,
        ),
        BulletsSlide(
          title: 'What is Slick Slides?',
          bulletByBullet: true,
          bullets: const [
            'Bullet number 1',
            'A second bullet',
          ],
          transition: _defaultTransition,
        ),
      ],
    );
  }
}
```

## Displaying and animating code
To display or animate code, use the `AnimatedCodeSlide`. Slick Slides will do a diff between your code snippets and animate the changes in the code as if you were typing. You can also highlight lines in the code to bring extra attention to them. This is a simple example:

```dart
const _codeExampleA = '''class MyClass {

}
''';

const _codeExampleB = '''class MyClass {
  String methodToAnimateIn() {
    return 'Hello world!';
  }
}
''';

@override
Widget build(BuildContext context) {
  // Create a new SlideDeck with a TitleSlide and a BulletsSlide.
  return SlideDeck(
    slides: [
      AnimatedCodeSlide(
        formattedCode: [
          FormattedCode(
            code: _codeExampleA,
          ),
          FormattedCode(
            code: _codeExampleB,
            highlightedLines: [1, 2, 3],
          ),
        ],
      ),
    ],
  );
}
```

## Creating custom types of slides
Slick Slides allows you to create custom types of slides with any Flutter widgets. You can even create interactive slides in your deck. For slides that use custom assets, such as images or animations, that need to be loaded, you can use the `onPrecache` property to provide code that loads the slide ahead of time. This is an example of a custom slide that displays an animated Serverpod logo (from the `made_with_serverpod` package):

```dart
Slide(
  builder: (context) {
    return const ContentLayout(
      content: Center(
        child: SizedBox(
          width: 600,
          child: AnimatedServerpodLogo(
            brightness: Brightness.dark,
            animate: true,
           loop: false,
          ),
        ),
      ),
    );
  },
  transition: const SlickFadeTransition(),
  onPrecache: (context) async {
    AnimatedServerpodLogo.precache();
  },
)
```

Tip! You can also override the `Slide` class if you want to make more reusable types of slides. Have a look at the source code for the default set of slides to see how you do this.

## Other cool features
These are some sweet things you can do with Slick Slides:

- Create slides with rich text.
- Do hero animations (just add heroes as you would in any Flutter transition).
- Create interactive slides with custom widgets.
- Add custom themes. A default dark and light theme is provided, but you can easily create and customize your own.
- Autoplaying decks.
- Audio files associated with slides and played when a slide is shown.

## Known issues
Slick Slides works well, but there are a couple of known issues that we hope to fix in the future (conrtributions are very welcome):

- The custom font for displaying highlighted code (by default Jetbrains Mono) doesn't work on Flutter web.
- Hero animations gets 'stuck' if interrupted, e.g. by moving quickly to another slide when the animation is running.
- Video slides does not fade out correctly when leaving a slide using a fade transition.