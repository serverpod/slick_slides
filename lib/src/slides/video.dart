import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';

class VideoSlide extends StatefulWidget {
  const VideoSlide({
    required this.asset,
    super.key,
  });

  final String asset;

  @override
  State<VideoSlide> createState() => _VideoSlideState();
}

class _VideoSlideState extends State<VideoSlide> {
  final _playerController = MeeduPlayerController(
    controlsStyle: ControlsStyle.primary,
    enabledControls: const EnabledControls(
      doubleTapToSeek: false,
      seekArrows: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  void _init() {
    _playerController.setDataSource(
      DataSource(type: DataSourceType.asset, source: widget.asset),
      autoplay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeeduVideoPlayer(
      controller: _playerController,
      customControls: (context, controller, controls) {
        return const SizedBox();
      },
    );
  }
}
