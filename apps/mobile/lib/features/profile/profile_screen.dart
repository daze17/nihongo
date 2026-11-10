import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/locale.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/auth/account_card.dart';
import 'package:nihongo/features/auth/auth_controller.dart';
import 'package:nihongo/features/onboarding/onboarding_controller.dart';

/// Account, language and settings. Opened from the avatar on the Class tab.
class ProfileScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final onboarding = ref.watch(onboardingProvider);
    final user = ref.watch(authProvider).value;
    final name = user?.name ?? l10n.learnerName;
    const stats = sampleStats;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        surfaceTintColor: AppColors.paper,
        title: Text(l10n.navProfile, style: context.heading(18)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.ink,
                child: Text(
                  name.characters.first,
                  style: context.display(20, color: AppColors.white),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: context.heading(19)),
                    const SizedBox(height: 2),
                    Text(
                      onboarding.path.title(l10n),
                      style: context.body(
                        13,
                        weight: FontWeight.w600,
                        color: AppColors.ink2,
                      ),
                    ),
                  ],
                ),
              ),
              Daruma(size: 46, eyes: onboarding.wishMade ? 1 : 0),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: l10n.statLessons,
                  value: '${stats.lessonsDone}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  label: l10n.statWords,
                  value: '${stats.wordsKnown}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: l10n.statBestMock,
                  value: '${sampleMock.score}',
                  valueColor: AppColors.sky,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  label: l10n.statStreak,
                  value: l10n.days(stats.streakDays),
                  valueColor: AppColors.sun,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(l10n.settings),
                const SizedBox(height: 8),
                const _LanguageSwitch(),
                const Divider(height: 20, color: AppColors.line),
                _SettingRow(
                  icon: Icons.flag_rounded,
                  label: l10n.dailyGoalLine(onboarding.dailyMinutes),
                ),
                _SettingRow(
                  icon: Icons.notifications_rounded,
                  label: l10n.reminderLine('20:00'),
                ),
                _SettingRow(
                  icon: Icons.alt_route_rounded,
                  label: l10n.changePath,
                  onTap: () => context.go(Routes.onboarding),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AccountCard(),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const new({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.button,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.sky),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: context.body(14))),
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded, color: AppColors.faint),
          ],
        ),
      ),
    );
  }
}

class _LanguageSwitch extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return Row(
      children: [
        const Icon(Icons.translate_rounded, size: 20, color: AppColors.sky),
        const SizedBox(width: 10),
        Text(context.l10n.language, style: context.body(14)),
        const Spacer(),
        SegmentedButton<String>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.sky,
            selectedForegroundColor: AppColors.white,
            backgroundColor: AppColors.card,
            foregroundColor: AppColors.ink2,
            side: const BorderSide(color: AppColors.line, width: 2),
          ),
          segments: const [
            ButtonSegment(value: 'mn', label: Text('МН')),
            ButtonSegment(value: 'en', label: Text('EN')),
          ],
          selected: {locale.languageCode},
          onSelectionChanged: (s) =>
              ref.read(localeProvider.notifier).set(Locale(s.first)),
        ),
      ],
    );
  }
}
