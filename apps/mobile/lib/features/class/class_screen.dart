import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/auth/auth_controller.dart';

/// Weekly class league with real classmates, the teacher's note and homework.
class ClassScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    final name = ref.watch(authProvider).value?.name ?? l10n.learnerName;
    const c = sampleClass;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.myClass, style: context.heading(22))),
              Tooltip(
                message: l10n.navProfile,
                child: Semantics(
                  button: true,
                  label: l10n.navProfile,
                  excludeSemantics: true,
                  child: InkResponse(
                    onTap: () => context.push(Routes.profile),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.ink,
                      child: Text(
                        name.characters.first,
                        style: context.display(15, color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: AppRadii.large,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.violet, AppColors.sky],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Eyebrow(
                        l10n.leagueEyebrow(c.name),
                        color: const Color(0xFFE4D9FF),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.leagueTitle,
                        style: context.heading(18, color: AppColors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.leagueEnds(c.daysLeft),
                        style: context.body(
                          12,
                          weight: FontWeight.w800,
                          color: const Color(0xFFE4D9FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 60,
                  color: AppColors.gold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final (i, mate) in c.league.indexed) ...[
            _RankRow(position: i + 1, mate: mate),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.goldTint,
              borderRadius: AppRadii.card,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.ink,
                  child: Text(
                    c.teacherInitials,
                    style: context.display(11, color: AppColors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.teacherName(c.teacher),
                        style: context.body(14, weight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c.cheer.of(lang),
                        style: context.body(
                          13,
                          weight: FontWeight.w600,
                          color: AppColors.ink2,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(
                l10n.homeworkLeft(c.homeworkLeft),
                tone: PillTone.sky,
                icon: Icons.edit_note_rounded,
              ),
              Pill(
                l10n.attendance('${(c.attendance * 100).round()}%'),
                tone: PillTone.mint,
                icon: Icons.event_available_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const new({required this.position, required this.mate});

  final int position;
  final Classmate mate;

  @override
  Widget build(BuildContext context) {
    final me = mate.isMe;
    final name = me ? context.l10n.you : mate.name;
    final fg = me ? AppColors.white : AppColors.ink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: me ? AppColors.sky : AppColors.card,
        borderRadius: AppRadii.button,
        boxShadow: me
            ? const [BoxShadow(color: AppColors.skyDeep, offset: Offset(0, 4))]
            : AppShadows.card,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$position',
              textAlign: TextAlign.center,
              style: context.display(
                14,
                color: me
                    ? AppColors.white
                    : (position == 1 ? AppColors.goldDeep : AppColors.faint),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(mate.color),
            child: Text(
              name.characters.first,
              style: context.display(12, color: AppColors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: context.body(14, weight: FontWeight.w900, color: fg),
            ),
          ),
          if (me) ...[
            const Icon(
              Icons.arrow_drop_up_rounded,
              color: AppColors.gold,
              size: 22,
            ),
            const SizedBox(width: 2),
          ],
          Text(
            '${mate.xp} XP',
            style: context.display(
              12,
              color: me ? AppColors.white : AppColors.ink2,
            ),
          ),
        ],
      ),
    );
  }
}
