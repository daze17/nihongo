import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/auth/auth_controller.dart';

/// The requirement checklist as a boarding pass. Each requirement is a hanko
/// slot; filling the last one paints Daru's second eye.
class PassScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = ref.watch(authProvider).value?.name ?? l10n.learnerName;
    const items = sampleRequirements;
    final done = items.where((r) => r.status == RequirementStatus.done).length;
    final checked = items.where((r) => r.checkedByTeacher).length;
    final complete = done == items.length;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.passTitle, style: context.heading(22))),
              Pill('$done / ${items.length}', tone: PillTone.gold),
            ],
          ),
          const SizedBox(height: 14),
          _BoardingPass(name: name, items: items),
          if (checked > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 18,
                  color: AppColors.mintDeep,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.checkedBy(checked, sampleClass.teacher),
                    style: context.body(
                      12,
                      weight: FontWeight.w800,
                      color: AppColors.mintDeep,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          AppCard(
            child: Row(
              children: [
                Daruma(size: 54, eyes: complete ? 2 : 1),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.stampsToGo(items.length - done),
                        style: context.body(15, weight: FontWeight.w900),
                      ),
                      Text(
                        l10n.secondEyeBody,
                        style: context.body(
                          12,
                          weight: FontWeight.w600,
                          color: AppColors.ink2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardingPass extends StatelessWidget {
  const new({required this.name, required this.items});

  final String name;
  final List<Requirement> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    const journey = sampleJourney;
    TextStyle label() => context.display(
      9,
      weight: FontWeight.w700,
      color: AppColors.faint,
      spacing: 0.1,
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadii.large,
        boxShadow: AppShadows.lifted,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: AppColors.sky,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(l10n.passenger(name), color: AppColors.skySoft),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'ULN',
                      style: context.display(30, color: AppColors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const _DashedLine(),
                          Transform.rotate(
                            angle: 1.5708,
                            child: const Icon(
                              Icons.flight_rounded,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'TYO',
                      style: context.display(30, color: AppColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ChunkyBar(
                  value: journey.readiness,
                  color: AppColors.gold,
                  track: const Color(0x40FFFFFF),
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                for (final (k, v, flex) in [
                  (l10n.visaLabel, l10n.visaCare, 5),
                  (l10n.examLabel, l10n.examDate, 3),
                  (l10n.readyLabel, '${(journey.readiness * 100).round()}%', 2),
                ])
                  Expanded(
                    flex: flex,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(k.toUpperCase(), style: label()),
                        const SizedBox(height: 3),
                        Text(
                          v,
                          style: context.body(13, weight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const _Perforation(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 16),
            child: Column(
              children: [
                for (var row = 0; row < items.length; row += 4) ...[
                  if (row > 0) const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final r in items.skip(row).take(4))
                        Expanded(
                          child: Semantics(
                            label: r.label.of(lang),
                            value: switch (r.status) {
                              RequirementStatus.done => '✓',
                              RequirementStatus.partial =>
                                '${(r.progress * 100).round()}%',
                              RequirementStatus.todo => '',
                            },
                            excludeSemantics: true,
                            child: Hanko(
                              glyph: r.glyph,
                              size: 54,
                              progress: r.progress,
                              caption: r.label.of(lang),
                              state: switch (r.status) {
                                RequirementStatus.done => StampState.done,
                                RequirementStatus.partial => StampState.partial,
                                RequirementStatus.todo => StampState.empty,
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => Row(
        children: [
          for (var i = 0; i < c.maxWidth ~/ 8; i++)
            Container(
              width: 4,
              height: 2,
              margin: const EdgeInsets.only(right: 4),
              color: const Color(0x99FFFFFF),
            ),
        ],
      ),
    );
  }
}

/// Dashed tear line with punched notches on both edges.
class _Perforation extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, c) => Row(
                children: [
                  for (var i = 0; i < c.maxWidth ~/ 10; i++)
                    Container(
                      width: 6,
                      height: 2,
                      margin: const EdgeInsets.only(right: 4),
                      color: AppColors.line,
                    ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: -9,
            child: CircleAvatar(radius: 9, backgroundColor: AppColors.paper),
          ),
          const Positioned(
            right: -9,
            child: CircleAvatar(radius: 9, backgroundColor: AppColors.paper),
          ),
        ],
      ),
    );
  }
}
