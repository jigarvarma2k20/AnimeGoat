import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  late Future<void>? _initializeVideoPlayerFuture;

  void _initializeController() {
    setState(() {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _initializeVideoPlayerFuture =
          _videoPlayerController!.initialize().then((_) {
        if (mounted) {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            autoPlay: true,
            looping: true,
            autoInitialize: true,
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized) {
            return Chewie(controller: _chewieController!);
          } else if (snapshot.hasError) {
            return Container(
                height: 300,
                color: Colors.grey,
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
