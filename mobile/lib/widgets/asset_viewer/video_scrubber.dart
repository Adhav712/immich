import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/providers/asset_viewer/video_player_controls_provider.dart';
import 'package:immich_mobile/providers/asset_viewer/video_player_value_provider.dart';

class VideoScrubber extends ConsumerWidget {
  final double height;
  final Duration duration;

  const VideoScrubber({super.key, this.height = 60.0, required this.duration});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(videoPlaybackValueProvider.select((value) => value.position));

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final scrollPosition = notification.metrics.pixels;
            final maxScroll = notification.metrics.maxScrollExtent;
            final progress = scrollPosition / maxScroll;
            final seekPosition = (duration.inMilliseconds * progress).toInt();

            ref.read(videoPlayerControlsProvider.notifier).seek(Duration(milliseconds: seekPosition));
          }
          return true;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 100, // Number of thumbnail frames
          itemBuilder: (context, index) {
            final progress = index / 100;
            final frameTime = (duration.inMilliseconds * progress).toInt();
            final isCurrentFrame = (position.inMilliseconds - frameTime).abs() < duration.inMilliseconds / 100;

            return Container(
              width: height * 16 / 9, // Maintain aspect ratio
              decoration: BoxDecoration(
                border: isCurrentFrame ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
              ),
              child: _buildThumbnail(frameTime),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThumbnail(int timeInMs) {
    // TODO: Implement video thumbnail generation
    // For now just showing a placeholder
    return Container(
      color: Colors.black26,
      child: Center(
        child: Text(
          '${(timeInMs / 1000).toStringAsFixed(1)}s',
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ),
    );
  }
}
