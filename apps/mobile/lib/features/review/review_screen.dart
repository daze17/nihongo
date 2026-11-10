import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/review/review_controller.dart';

class ReviewScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(reviewProvider);
    final controller = ref.read(reviewProvider.notifier);
    final lang = Localizations.localeOf(context).languageCode;
    final card = state.card;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Eyebrow(l10n.reviewEyebrow),
                  const Spacer(),
                  IconButton(
                    tooltip: l10n.close,
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.home),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.faint,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(l10n.reviewTitle, style: context.heading(28)),
                  const Spacer(),
                  Text(
                    l10n.cardsLeft(state.left),
                    style: context.body(
                      13,
                      weight: FontWeight.w600,
                      color: AppColors.ink2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatTile(label: l10n.reviewNew, value: '4'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatTile(
                      label: l10n.reviewDue,
                      value: '11',
                      valueColor: AppColors.sun,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatTile(label: l10n.reviewLearned, value: '23'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Semantics(
                  button: !state.revealed,
                  label: state.revealed ? null : l10n.flipCard,
                  child: AppCard(
                    radius: AppRadii.large,
                    padding: const EdgeInsets.all(20),
                    onTap: state.revealed ? null : controller.reveal,
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Eyebrow(l10n.workWordsEyebrow),
                            const SizedBox(height: 14),
                            Text(card.word, style: context.japanese(56)),
                            const SizedBox(height: 14),
                            if (state.revealed) ...[
                              Text(
                                '${card.reading} · ${card.romaji}',
                                style: context.body(
                                  16,
                                  weight: FontWeight.w600,
                                  color: AppColors.ink2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.meaning(lang),
                                style: context.heading(22),
                              ),
                            ] else
                              Text(
                                l10n.tapToReveal,
                                style: context.body(
                                  14,
                                  weight: FontWeight.w600,
                                  color: AppColors.ink2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (state.revealed)
                Row(
                  children: [
                    for (final (i, g) in Grade.values.indexed) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: _GradeButton(
                          grade: g,
                          onTap: () => controller.grade(g),
                        ),
                      ),
                    ],
                  ],
                )
              else
                ChunkyButton(
                  label: l10n.showAnswer,
                  onPressed: controller.reveal,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  const new({required this.grade, required this.onTap});

  final Grade grade;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (String label, String interval, Color bg, Color fg) = switch (grade) {
      Grade.again => (
        l10n.gradeAgain,
        l10n.minutes(1),
        AppColors.sunTint,
        AppColors.sunDeep,
      ),
      Grade.hard => (
        l10n.gradeHard,
        l10n.days(1),
        AppColors.card,
        AppColors.ink,
      ),
      Grade.good => (
        l10n.gradeGood,
        l10n.days(3),
        AppColors.mintTint,
        AppColors.mintDeep,
      ),
      Grade.easy => (
        l10n.gradeEasy,
        l10n.days(7),
        AppColors.skyTint,
        AppColors.skyDeep,
      ),
    };
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.button,
        side: BorderSide(color: fg.withValues(alpha: 0.25), width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.button,
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: context.body(13, color: fg)),
              Text(
                interval,
                style: context.body(11, weight: FontWeight.w500, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
