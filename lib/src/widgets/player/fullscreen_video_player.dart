import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_video_player/src/navigation/route_aware_listener.dart';
import 'package:omni_video_player/src/widgets/adaptive_video_player_display.dart';
import 'package:omni_video_player/src/widgets/video_overlay_controls.dart';
import 'package:omni_video_player/omni_video_player/controllers/omni_playback_controller.dart';
import 'package:omni_video_player/omni_video_player/models/video_player_callbacks.dart';
import 'package:omni_video_player/omni_video_player/models/video_player_configuration.dart';

/// A full-screen video player widget that manages system UI, device orientation,
/// and overlays interactive video controls.
///
/// This widget locks the device orientation based on the video's rotation and aspect ratio,
/// enters immersive full-screen mode, and restores system UI overlays when dismissed.
///
/// It integrates with a [OmniPlaybackController] for video playback control,
/// uses [VideoPlayerConfiguration] for configuration, and reports events through [VideoPlayerCallbacks].
class FullscreenVideoPlayer extends StatefulWidget {
  /// The controller managing media playback state and logic.
  final OmniPlaybackController controller;

  /// Configuration options for the video player appearance and behavior.
  final VideoPlayerConfiguration options;

  /// Callbacks to respond to video player events and user interactions.
  final VideoPlayerCallbacks callbacks;

  const FullscreenVideoPlayer({
    super.key,
    required this.controller,
    required this.options,
    required this.callbacks,
  });

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer>
    with WidgetsBindingObserver {
  late Orientation currentOrientation;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    final orientation = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .orientation;
    currentOrientation = orientation;

    _lockOrientation(currentOrientation);
  }

  void _lockOrientation(Orientation orientation) {
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void didChangeMetrics() {
    final orientation = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first)
        .orientation;

    if (orientation != currentOrientation) {
      setState(() {
        currentOrientation = orientation;
      });
      _lockOrientation(currentOrientation);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RouteAwareListener(
      onPop: () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      },
      child: Material(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: VideoOverlayControls(
                playerBarPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                controller: widget.controller,
                options: widget.options,
                callbacks: widget.callbacks,
                child: AdaptiveVideoPlayerDisplay(
                  controller: widget.controller,
                  isFullScreenDisplay: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
