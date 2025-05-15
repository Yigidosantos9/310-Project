import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/providers/user_provider.dart';

class PomodoroService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateWorkTime({
    required String uid,
    required int additionalSeconds,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'timeWorked': FieldValue.increment(additionalSeconds),
      });
    } catch (e) {
      print('Error occurred when updating timeWorked: $e');
      rethrow;
    }
  }
}

final pomodoroServiceProvider = Provider<PomodoroService>((ref) {
  return PomodoroService();
});

final workTimeProvider = StateProvider<int>((ref) => 0);

final pomodoroSessionProvider =
    StateNotifierProvider<PomodoroSessionNotifier, PomodoroSessionState>((ref) {
      return PomodoroSessionNotifier(ref);
    });

class PomodoroSessionState {
  final int missionTimeSeconds;
  final int breakTimeSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final Duration selectedDuration;

  PomodoroSessionState({
    this.missionTimeSeconds = 0,
    this.breakTimeSeconds = 0,
    this.remainingSeconds = 25 * 60,
    this.isRunning = false,
    this.selectedDuration = const Duration(minutes: 25),
  });

  PomodoroSessionState copyWith({
    int? missionTimeSeconds,
    int? breakTimeSeconds,
    int? remainingSeconds,
    bool? isRunning,
    Duration? selectedDuration,
  }) {
    return PomodoroSessionState(
      missionTimeSeconds: missionTimeSeconds ?? this.missionTimeSeconds,
      breakTimeSeconds: breakTimeSeconds ?? this.breakTimeSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}

class PomodoroSessionNotifier extends StateNotifier<PomodoroSessionState> {
  final Ref _ref;
  Timer? _timer;
  Timer? _breakTimer;
  DateTime? _lastTick;
  int _lastSavedTime = 0;

  PomodoroSessionNotifier(this._ref) : super(PomodoroSessionState());

  void startTimer() {
    _breakTimer?.cancel();
    _lastTick = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final elapsedMs = now.difference(_lastTick!).inMilliseconds;
      _lastTick = now;

      state = state.copyWith(
        remainingSeconds: state.remainingSeconds - (elapsedMs / 1000).round(),
        missionTimeSeconds:
            state.missionTimeSeconds + (elapsedMs / 1000).round(),
      );

      if (state.remainingSeconds <= 0) {
        stopTimer();
        saveWorkTime();
      }
    });

    state = state.copyWith(isRunning: true);
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;

    saveWorkTime();

    _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(breakTimeSeconds: state.breakTimeSeconds + 1);
    });

    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    _breakTimer?.cancel();

    saveWorkTime();

    state = PomodoroSessionState(
      selectedDuration: state.selectedDuration,
      remainingSeconds: state.selectedDuration.inSeconds,
    );

    _lastSavedTime = 0;
  }

  void updateSelectedDuration(Duration duration) {
    state = state.copyWith(
      selectedDuration: duration,
      remainingSeconds: duration.inSeconds,
    );
  }

  void saveWorkTime() {
    final user = _ref.read(userProvider);
    if (user == null) return;

    final newTime = state.missionTimeSeconds - _lastSavedTime;
    if (newTime <= 0) return;

    _ref
        .read(pomodoroServiceProvider)
        .updateWorkTime(uid: user.uid, additionalSeconds: newTime);

    _lastSavedTime = state.missionTimeSeconds;
  }

  @override
  void dispose() {
    saveWorkTime();
    _timer?.cancel();
    _breakTimer?.cancel();
    super.dispose();
  }
}
