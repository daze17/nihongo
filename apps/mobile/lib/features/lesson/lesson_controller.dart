import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:nihongo/core/sample_data.dart';

const startingHearts = 5;
const xpPerCorrect = 5;

/// From this many right answers in a row, each answer is worth double XP.
const comboThreshold = 3;

class LessonState {
  const new({
    required this.queue,
    required this.index,
    required this.hearts,
    required this.correct,
    required this.mistakes,
    required this.startedAt,
    this.combo = 0,
    this.xp = 0,
  });

  /// Exercises in play order. A missed exercise is appended again.
  final List<Exercise> queue;
  final int index;
  final int hearts;
  final int correct;
  final int mistakes;
  final DateTime startedAt;

  /// Right answers in a row; a mistake resets it.
  final int combo;
  final int xp;

  bool get onCombo => combo >= comboThreshold;

  bool get isFinished => index >= queue.length;
  Exercise get current => queue[index];
  double get progress => queue.isEmpty ? 0 : index / queue.length;

  LessonState copyWith({
    List<Exercise>? queue,
    int? index,
    int? hearts,
    int? correct,
    int? mistakes,
    int? combo,
    int? xp,
  }) => LessonState(
    queue: queue ?? this.queue,
    index: index ?? this.index,
    hearts: hearts ?? this.hearts,
    correct: correct ?? this.correct,
    mistakes: mistakes ?? this.mistakes,
    startedAt: startedAt,
    combo: combo ?? this.combo,
    xp: xp ?? this.xp,
  );
}

class LessonResult {
  const new({
    required this.xp,
    required this.accuracy,
    required this.duration,
    required this.kanaLearned,
    this.glyph = '',
  });

  final int xp;

  /// Shown on the reward stamp.
  final String glyph;

  /// 0..1, first-try answers over all answers.
  final double accuracy;
  final Duration duration;
  final int kanaLearned;
}

final NotifierProviderFamily<LessonController, LessonState, String>
lessonControllerProvider = NotifierProvider.autoDispose
    .family<LessonController, LessonState, String>(LessonController.new);

class LessonController extends Notifier<LessonState> {
  new(this.lessonId, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final String lessonId;
  final DateTime Function() _clock;

  @override
  LessonState build() => LessonState(
    queue: sampleLesson(lessonId),
    index: 0,
    hearts: startingHearts,
    correct: 0,
    mistakes: 0,
    startedAt: _clock(),
  );

  void answer({required bool correct}) {
    if (state.isFinished) return;
    if (correct) {
      final combo = state.combo + 1;
      state = state.copyWith(
        index: state.index + 1,
        correct: state.correct + 1,
        combo: combo,
        xp: state.xp + xpPerCorrect * (combo >= comboThreshold ? 2 : 1),
      );
    } else {
      state = state.copyWith(
        index: state.index + 1,
        hearts: (state.hearts - 1).clamp(0, startingHearts),
        mistakes: state.mistakes + 1,
        queue: [...state.queue, state.current],
        combo: 0,
      );
    }
  }

  LessonResult result() {
    final answers = state.correct + state.mistakes;
    return LessonResult(
      xp: state.xp,
      accuracy: answers == 0 ? 1 : state.correct / answers,
      duration: _clock().difference(state.startedAt),
      kanaLearned: {for (final e in state.queue) e.kana.char}.length,
      glyph: state.queue.isEmpty ? '' : state.queue.last.kana.char,
    );
  }
}
