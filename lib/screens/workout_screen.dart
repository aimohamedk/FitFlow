import 'dart:async';
import 'package:flutter/material.dart';
import '../data_exercises.dart';
import '../widgets/circular_timer.dart';
import '../widgets/fullscreen_exercise_video.dart';
import 'complete_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _exerciseIndex = 0;
  Timer? _timer;
  late int _secondsLeft;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = fitFlowExercises.first.seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _isPaused) return;

      if (_secondsLeft > 1) {
        setState(() => _secondsLeft--);
      } else {
        _goToNextExercise();
      }
    });
  }

  void _goToNextExercise() {
    _timer?.cancel();

    if (_exerciseIndex < fitFlowExercises.length - 1) {
      setState(() {
        _exerciseIndex++;
        _secondsLeft = fitFlowExercises[_exerciseIndex].seconds;
        _isPaused = false;
      });
      _startTimer();
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CompleteScreen()),
    );
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercise = fitFlowExercises[_exerciseIndex];
    final progress = _secondsLeft / exercise.seconds;
    final nextExercise = _exerciseIndex < fitFlowExercises.length - 1
        ? fitFlowExercises[_exerciseIndex + 1].name
        : 'Finish Workout';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FullscreenExerciseVideo(
              key: ValueKey(exercise.videoPath),
              videoPath: exercise.videoPath,
              isPaused: _isPaused,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xAA000000),
                    Color(0x22000000),
                    Color(0xCC000000),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _goToNextExercise,
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Exercise ${_exerciseIndex + 1}/${fitFlowExercises.length}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _togglePause,
                          icon: Icon(
                            _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    exercise.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Next: $nextExercise',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12),
                    ),
                    child: CircularTimer(
                      progress: progress,
                      secondsLeft: _secondsLeft,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Tap anywhere to skip to the next exercise',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        backgroundColor: Colors.black38,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _togglePause,
                      child: Text(_isPaused ? 'RESUME' : 'PAUSE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
