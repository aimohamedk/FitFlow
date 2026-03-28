import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullscreenExerciseVideo extends StatefulWidget {
  final String videoPath;
  final bool isPaused;

  const FullscreenExerciseVideo({
    super.key,
    required this.videoPath,
    required this.isPaused,
  });

  @override
  State<FullscreenExerciseVideo> createState() => _FullscreenExerciseVideoState();
}

class _FullscreenExerciseVideoState extends State<FullscreenExerciseVideo> {
  VideoPlayerController? _controller;
  String? _activePath;

  @override
  void initState() {
    super.initState();
    _loadVideo(widget.videoPath);
  }

  @override
  void didUpdateWidget(covariant FullscreenExerciseVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoPath != widget.videoPath) {
      _loadVideo(widget.videoPath);
      return;
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (widget.isPaused) {
      controller.pause();
    } else if (!controller.value.isPlaying) {
      controller.play();
    }
  }

  Future<void> _loadVideo(String path) async {
    if (_activePath == path) return;

    final previous = _controller;
    _activePath = path;

    final controller = VideoPlayerController.asset(path);
    _controller = controller;

    setState(() {});

    await controller.initialize();
    await controller.setLooping(true);

    if (!widget.isPaused) {
      await controller.play();
    }

    if (mounted) {
      setState(() {});
    }

    await previous?.dispose();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFFE53935)),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
