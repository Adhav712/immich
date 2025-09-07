import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class VideoThumbnailService {
  static Future<String?> generateThumbnail({required String videoPath, required int timeMs}) async {
    try {
      final fileName = '${videoPath.hashCode}_$timeMs.jpg';
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = '${tempDir.path}/$fileName';

      // Check if thumbnail already exists
      if (await File(thumbnailPath).exists()) {
        return thumbnailPath;
      }

      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        timeMs: timeMs,
        quality: 75,
      );

      return thumbnail;
    } catch (e) {
      return null;
    }
  }
}

class VideoScrubber extends StatelessWidget {
  final String videoPath;

  VideoScrubber({required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Your scrubber implementation
      child: Row(
        children: [
          // Other widgets
          _buildThumbnail(1000), // Example usage
          // Other widgets
        ],
      ),
    );
  }

  Widget _buildThumbnail(int timeInMs) {
    return FutureBuilder<String?>(
      future: VideoThumbnailService.generateThumbnail(
        videoPath: videoPath, // You'll need to pass this to the VideoScrubber
        timeMs: timeInMs,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.file(File(snapshot.data!), fit: BoxFit.cover);
        }
        return Container(
          color: Colors.black26,
          child: Center(
            child: Text(
              '${(timeInMs / 1000).toStringAsFixed(1)}s',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ),
        );
      },
    );
  }
}
