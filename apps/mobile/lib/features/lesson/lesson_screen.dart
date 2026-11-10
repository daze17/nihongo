import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/lesson/choice_exercise_view.dart';
import 'package:nihongo/features/lesson/lesson_controller.dart';
import 'package:nihongo/features/lesson/trace_exercise_view.dart';

class LessonScreen extends ConsumerWidget {
  const new({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = lessonControllerProvider(lessonId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    void onDone({required bool correct}) {
      controller.answer(correct: correct);
      if (ref.read(provider).isFinished) {
        context.pushReplacement(
          Routes.lessonComplete(lessonId),
          extra: controller.result(),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
              child: LessonTopBar(
                progress: state.progress,
                hearts: state.hearts,
                onClose: () =>
                    context.canPop() ? context.pop() : context.go(Routes.home),
              ),
            ),
            Expanded(
              child: state.isFinished
                  ? const SizedBox.shrink()
                  : switch (state.current) {
                      final ChoiceExercise e => ChoiceExerciseView(
                        key: ValueKey(state.index),
                        exercise: e,
                        combo: state.combo,
                        onDone: onDone,
                      ),
                      final TraceExercise e => TraceExerciseView(
                        key: ValueKey(state.index),
                        exercise: e,
                        onDone: () => onDone(correct: true),
                      ),
                    },
            ),
          ],
        ),
      ),
    );
  }
}
