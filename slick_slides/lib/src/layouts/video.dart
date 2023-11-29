import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A layout that displays a video using the [VideoPlayer] widget.
class VideoLayout extends StatelessWidget {
  /// The [VideoPlayerController] to used to play the video.
  final VideoPlayerController videoPlayerController;

  /// Creates a layout that displays a video using the [VideoPlayer] widget.
  const VideoLayout({
    required this.videoPlayerController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(
      videoPlayerController,
    );
  }
}
