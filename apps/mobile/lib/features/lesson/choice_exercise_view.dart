import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/lesson/lesson_controller.dart';

/// Daru asks "how is this read?" and the student picks one of four romaji.
class ChoiceExerciseView extends StatefulWidget {
  const new({
    required this.exercise,
    required this.combo,
    required this.onDone,
    super.key,
  });

  final ChoiceExercise exercise;

  /// Right answers in a row before this one.
  final int combo;
  final void Function({required bool correct}) onDone;

  @override
  State<ChoiceExerciseView> createState() => _ChoiceExerciseViewState();
}

class _ChoiceExerciseViewState extends State<ChoiceExerciseView> {
  String? _picked;
  bool _checked = false;

  bool get _isCorrect => _picked == widget.exercise.kana.romaji;

  void _check() {
    setState(() => _checked = true);
    if (_isCorrect) {
      HapticFeedback.lightImpact().ignore();
    } else {
      HapticFeedback.heavyImpact().ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kana = widget.exercise.kana;
    final combo = _checked && _isCorrect ? widget.combo + 1 : widget.combo;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              SizedBox(
                height: 30,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedScale(
                    scale: combo >= comboThreshold ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    child: Transform.rotate(
                      angle: -0.05,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: AppRadii.pill,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              size: 16,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.combo(combo),
                              style: context.body(
                                12,
                                weight: FontWeight.w900,
                                color: AppColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Daruma(size: 64, bob: true),
                  const SizedBox(width: 12),
                  Expanded(child: _Bubble(kana: kana)),
                ],
              ),
              const SizedBox(height: 28),
              for (
                var row = 0;
                row < widget.exercise.options.length;
                row += 2
              ) ...[
                Row(
                  children: [
                    for (final (i, option)
                        in widget.exercise.options
                            .skip(row)
                            .take(2)
                            .indexed) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(
                        child: _OptionButton(
                          label: option,
                          look: _lookFor(option),
                          onTap: _checked
                              ? null
                              : () => setState(() => _picked = option),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, a) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(a),
            child: child,
          ),
          child: !_checked
              ? Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    12 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: ChunkyButton(
                    label: l10n.check,
                    onPressed: _picked == null ? null : _check,
                  ),
                )
              : _Verdict(
                  correct: _isCorrect,
                  kana: kana,
                  onContinue: () => widget.onDone(correct: _isCorrect),
                ),
        ),
      ],
    );
  }

  _OptionLook _lookFor(String option) {
    final answer = widget.exercise.kana.romaji;
    if (_checked && option == answer) return _OptionLook.correct;
    if (_checked && option == _picked) return _OptionLook.wrong;
    if (option == _picked) return _OptionLook.picked;
    return _OptionLook.idle;
  }
}

/// Daru's speech bubble holding the question and the character.
class _Bubble extends StatelessWidget {
  const new({required this.kana});

  final Kana kana;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -7,
          bottom: 18,
          child: Transform.rotate(
            angle: 0.785,
            child: Container(width: 16, height: 16, color: AppColors.card),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: AppRadii.card,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.choiceQuestion,
                style: context.body(13, color: AppColors.ink2),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(kana.char, style: context.japanese(64)),
                  const Spacer(),
                  IconButton.filled(
                    // Audio arrives with the content pipeline (Phase 3).
                    onPressed: () {},
                    tooltip: l10n.playSound,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.sky,
                      foregroundColor: AppColors.white,
                    ),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _OptionLook { idle, picked, correct, wrong }

class _OptionButton extends StatelessWidget {
  const new({required this.label, required this.look, required this.onTap});

  final String label;
  final _OptionLook look;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (Color face, Color edge, Color fg) = switch (look) {
      _OptionLook.idle => (AppColors.card, AppColors.line, AppColors.ink),
      _OptionLook.picked => (
        AppColors.skyTint,
        AppColors.sky,
        AppColors.skyDeep,
      ),
      _OptionLook.correct => (
        AppColors.mintTint,
        AppColors.mint,
        AppColors.mintDeep,
      ),
      _OptionLook.wrong => (
        AppColors.sunTint,
        AppColors.sun,
        AppColors.sunDeep,
      ),
    };
    return Semantics(
      button: true,
      selected: look != _OptionLook.idle,
      child: AnimatedScale(
        scale: look == _OptionLook.correct ? 1.05 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: face,
              borderRadius: AppRadii.button,
              border: Border.all(color: edge, width: 2),
              boxShadow: [BoxShadow(color: edge, offset: const Offset(0, 4))],
            ),
            child: Text(label, style: context.display(22, color: fg)),
          ),
        ),
      ),
    );
  }
}

class _Verdict extends StatelessWidget {
  const new({
    required this.correct,
    required this.kana,
    required this.onContinue,
  });

  final bool correct;
  final Kana kana;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fg = correct ? AppColors.mintDeep : AppColors.sunDeep;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: correct ? AppColors.mintTint : AppColors.sunTint,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            liveRegion: true,
            child: Row(
              children: [
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: fg,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (correct)
                        Text(
                          l10n.cheer,
                          style: context.japanese(20, color: fg),
                        ),
                      if (correct) const SizedBox(height: 4),
                      Text(
                        correct
                            ? l10n.correctTitle(kana.char, kana.romaji)
                            : l10n.wrongTitle(kana.romaji),
                        style: context.body(
                          16,
                          weight: FontWeight.w900,
                          color: fg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!correct) ...[
            const SizedBox(height: 6),
            Text(
              l10n.wrongHint,
              style: context.body(14, weight: FontWeight.w600, color: fg),
            ),
          ],
          const SizedBox(height: 14),
          ChunkyButton(
            label: correct ? l10n.continueLabel : l10n.gotIt,
            tone: correct ? Tone.mint : Tone.sun,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
