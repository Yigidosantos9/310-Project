import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/providers/pomodoro_provider.dart';
import 'package:spacy_notes/providers/user_provider.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  static String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  String _getMoonSvg(PomodoroSessionState state) {
    final progress =
        1 - (state.remainingSeconds / state.selectedDuration.inSeconds);
    if (progress < 0.2) return 'assets/images/moon_1.svg';
    if (progress < 0.4) return 'assets/images/moon_2.svg';
    if (progress < 0.6) return 'assets/images/moon_3.svg';
    if (progress < 0.8) return 'assets/images/moon_4.svg';
    return 'assets/images/moon_5.svg';
  }

  void _showTimeSelector(BuildContext context, WidgetRef ref) {
    final sessionNotifier = ref.read(pomodoroSessionProvider.notifier);
    final currentDuration = ref.read(pomodoroSessionProvider).selectedDuration;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.ms,
            initialTimerDuration: currentDuration,
            onTimerDurationChanged: (Duration value) {
              sessionNotifier.updateSelectedDuration(value);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(pomodoroSessionProvider);
    final sessionNotifier = ref.read(pomodoroSessionProvider.notifier);

    final userAsync = ref.watch(userStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Mission Timer"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TimeDisplay(
                  title: 'Mission Time',
                  time: _formatTime(sessionState.missionTimeSeconds),
                ),
                _TimeDisplay(
                  title: 'Break Time',
                  time: _formatTime(sessionState.breakTimeSeconds),
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
              child: SvgPicture.asset(
                _getMoonSvg(sessionState),
                fit: BoxFit.contain,
              ),
            ),

            GestureDetector(
              onTap: () => _showTimeSelector(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _formatTime(sessionState.remainingSeconds),
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
                  onPressed:
                      sessionState.isRunning
                          ? sessionNotifier.stopTimer
                          : sessionNotifier.startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Icon(
                    sessionState.isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.restart_alt, color: Colors.white),
                  onPressed: sessionNotifier.resetTimer,
                ),
              ],
            ),

            // Toplam çalışma süresini göster
            userAsync.when(
              data: (user) {
                if (user != null) {
                  final hours = (user.timeWorked ~/ 3600).toString().padLeft(
                    2,
                    '0',
                  );
                  final minutes = ((user.timeWorked % 3600) ~/ 60)
                      .toString()
                      .padLeft(2, '0');
                  final seconds = (user.timeWorked % 60).toString().padLeft(
                    2,
                    '0',
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Text(
                          'Total Work Time: $hours:$minutes:$seconds',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const CircularProgressIndicator(),
              error:
                  (err, stack) => Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/astronaut.png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: AppColors.grayTextColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
