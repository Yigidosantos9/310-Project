import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  Duration _selectedDuration = const Duration(minutes: 25);
  int remainingSeconds = 25 * 60;
  int missionTimeSeconds = 0;
  int breakTimeSeconds = 0;

  Timer? _timer;
  Timer? _pauseTracker;
  bool isRunning = false;
  DateTime? _lastTick;

  void _startTimer() {
    _pauseTracker?.cancel();
    _lastTick = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingSeconds--;

        final now = DateTime.now();
        final elapsed = now.difference(_lastTick!).inSeconds;
        missionTimeSeconds += elapsed;
        _lastTick = now;
      });

      if (remainingSeconds <= 0) _stopTimer();
    });

    setState(() => isRunning = true);
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;

    _pauseTracker = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        breakTimeSeconds++;
      });
    });

    setState(() => isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    _pauseTracker?.cancel();

    setState(() {
      remainingSeconds = _selectedDuration.inSeconds;
      missionTimeSeconds = 0;
      breakTimeSeconds = 0;
      isRunning = false;
    });
  }

  void _showTimeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.ms,
            initialTimerDuration: _selectedDuration,
            onTimerDurationChanged: (Duration value) {
              setState(() {
                _selectedDuration = value;
                remainingSeconds = value.inSeconds;
              });
            },
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  String _getMoonSvg() {
    final progress = 1 - (remainingSeconds / _selectedDuration.inSeconds);
    if (progress < 0.2) return 'assets/images/moon_1.svg';
    if (progress < 0.4) return 'assets/images/moon_2.svg';
    if (progress < 0.6) return 'assets/images/moon_3.svg';
    if (progress < 0.8) return 'assets/images/moon_4.svg';
    return 'assets/images/moon_5.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: "Mission Timer"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TimeDisplay(
                title: 'Mission Time',
                time: _formatTime(missionTimeSeconds),
              ),
              _TimeDisplay(
                title: 'Break Time',
                time: _formatTime(breakTimeSeconds),
              ),
            ],
          ),

          Container(
            width: 220,
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 4),
            ),
            child: SvgPicture.asset(_getMoonSvg(), fit: BoxFit.contain),
          ),

          GestureDetector(
            onTap: _showTimeSelector,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                _formatTime(remainingSeconds),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isRunning ? _stopTimer : _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Icon(
                  isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.restart_alt, color: Colors.white),
                onPressed: _resetTimer,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Image.asset('assets/images/astronaut.png', width: 150),
          ),
        ],
      ),
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final String title;
  final String time;

  const _TimeDisplay({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
