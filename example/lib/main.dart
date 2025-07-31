import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_video_player/omni_video_player.dart';

void main() {
  runApp(
    MaterialApp(
      home: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Omni Video Players'),
            bottom: const TabBar(
              padding: EdgeInsets.zero,
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              tabs: [
                Tab(text: 'YT'),
                Tab(text: 'YT Live'),
                Tab(text: 'Network Link'),
                Tab(text: 'Asset Link'),
                Tab(text: 'Vimeo'),
                Tab(text: 'YT Error'),
              ],
            ),
          ),
          body: BlocProvider(
            create: (_) => GlobalPlaybackController(),
            child: TabBarView(
              children: [
                YT(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                SizedBox(),
                // YTLive(),
                // NetworkLink(),
                // AssetLink(),
                // Vimeo(),
                // YTError(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget YT() {
  return OmniVideoPlayer(
    options: VideoPlayerConfiguration(
      videoSourceConfiguration: VideoSourceConfiguration.youtube(
        videoUrl: Uri.parse('https://youtu.be/LBlIRiwVIuM'),
        preferredQualities: [OmniVideoQuality.high720, OmniVideoQuality.low144],
      ),
    ),
    callbacks: VideoPlayerCallbacks(
      onControllerCreated: (controller) {
        controller.play();
      },
    ),
  );
}
