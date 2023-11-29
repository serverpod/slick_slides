import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:slick_slides/slick_slides.dart';
import 'package:video_player/video_player.dart';

/// A slide that displays a video.
class VideoSlide extends Slide {
  /// The [VideoPlayerController] to used to play the video. The slide will
  /// control the video player, so it should not be used elsewhere.
  final VideoPlayerController videoPlayerController;

  /// Creates a slide that displays a video, filling the slide.
  VideoSlide({
    required this.videoPlayerController,
    Duration playAfterDuration = Duration.zero,
    String? notes,
    SlickTransition? transition,
    final SlideThemeData? theme,
    Duration? autoplayDuration,
    Source? audioSource,
    bool loop = false,
  }) : super(
          builder: (context) {
            return VideoLayout(
              videoPlayerController: videoPlayerController,
            );
          },
          onPrecache: (context) async {
            await videoPlayerController.initialize();
            videoPlayerController.setLooping(loop);
          },
          onEnter: () async {
            await videoPlayerController.seekTo(Duration.zero);
            await Future.delayed(playAfterDuration);
            await videoPlayerController.play();
          },
          onExit: () async {
            await videoPlayerController.pause();
          },
          notes: notes,
          transition: transition,
          theme: theme,
          audioSource: audioSource,
          autoplayDuration: autoplayDuration,
        );
}
