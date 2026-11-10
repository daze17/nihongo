import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/features/lesson/lesson_controller.dart';

void main() {
  late ProviderContainer container;
  final provider = lessonControllerProvider('hira-a');

  setUp(() {
    // listen keeps the auto-dispose provider alive for the whole test.
    container = ProviderContainer.test()..listen(provider, (_, _) {});
  });

  LessonController controller() => container.read(provider.notifier);
  LessonState state() => container.read(provider);

  test('starts at the first exercise with full hearts', () {
    expect(state().index, 0);
    expect(state().hearts, startingHearts);
    expect(state().queue.first, isA<ChoiceExercise>());
  });

  test('a wrong answer costs a heart and repeats the exercise later', () {
    final missed = state().current;
    final length = state().queue.length;

    controller().answer(correct: false);

    expect(state().hearts, startingHearts - 1);
    expect(state().mistakes, 1);
    expect(state().queue, hasLength(length + 1));
    expect(state().queue.last, same(missed));
  });

  test('finishes after every exercise and reports xp and accuracy', () {
    controller().answer(correct: false);
    while (!state().isFinished) {
      controller().answer(correct: true);
    }
    final result = controller().result();

    // Miss, then four right: the third and fourth in a row count double.
    expect(result.xp, xpPerCorrect * (1 + 1 + 2 + 2));
    expect(result.accuracy, closeTo(4 / 5, 0.001));
    expect(result.kanaLearned, 3);
  });

  test('a mistake breaks the combo', () {
    for (var i = 0; i < comboThreshold; i++) {
      controller().answer(correct: true);
    }
    expect(state().onCombo, isTrue);

    controller().answer(correct: false);

    expect(state().combo, 0);
    expect(state().onCombo, isFalse);
  });
}
