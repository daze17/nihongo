import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/auth/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = ref.watch(authProvider).value?.name ?? l10n.learnerName;
    const stats = sampleStats;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.hello(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.heading(19),
                ),
              ),
              Semantics(
                label: l10n.streakSemantics(stats.streakDays),
                excludeSemantics: true,
                child: Pill(
                  '${stats.streakDays}',
                  tone: PillTone.gold,
                  icon: Icons.local_fire_department_rounded,
                ),
              ),
              const SizedBox(width: 6),
              Semantics(
                label: l10n.gemsSemantics(stats.gems),
                excludeSemantics: true,
                child: Pill(
                  '${stats.gems}',
                  tone: PillTone.sky,
                  icon: Icons.diamond_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _FlightCard(journey: sampleJourney),
          const SizedBox(height: 16),
          _Week(week: stats.week),
          const SizedBox(height: 16),
          _TodayCard(
            lesson: sampleToday,
            onTap: () => context.push(Routes.lesson(sampleToday.id)),
          ),
          const SizedBox(height: 12),
          _ChestCard(onTap: () => context.push(Routes.review)),
        ],
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  const new({required this.journey});

  final Journey journey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final percent = '${(journey.readiness * 100).round()}%';
    return Semantics(
      label: l10n.flightSemantics(percent),
      container: true,
      child: ClipRRect(
        borderRadius: AppRadii.large,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.sky, AppColors.skyDeep],
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                right: -34,
                top: -34,
                child: CircleAvatar(radius: 60, backgroundColor: AppColors.sun),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(l10n.flightEyebrow, color: AppColors.skySoft),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          percent,
                          style: context.display(38, color: AppColors.white),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.kmToGo(journey.kmLeft),
                            style: context.body(
                              13,
                              weight: FontWeight.w800,
                              color: AppColors.skySoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                    LoopAnimation(
                      duration: const Duration(milliseconds: 1200),
                      reverse: true,
                      builder: (context, t, _) => CustomPaint(
                        size: const Size(double.infinity, 74),
                        painter: _RoutePainter(
                          progress: journey.readiness,
                          hover: Curves.easeInOut.transform(t),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(l10n.routeFrom, style: _endStyle(context)),
                        const Spacer(),
                        Text(l10n.routeTo, style: _endStyle(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _endStyle(BuildContext context) =>
      context.body(11, weight: FontWeight.w800, color: const Color(0xFFDFE6FF));
}

/// Arc from Ulaanbaatar to Tokyo: dotted ahead, gold behind, plane at the
/// student's readiness.
class _RoutePainter extends CustomPainter {
  const new({required this.progress, required this.hover});

  final double progress;
  final double hover;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final route = Path()
      ..moveTo(8, size.height - 10)
      ..quadraticBezierTo(w / 2, -18, w - 8, size.height - 10);
    final metric = route.computeMetrics().first;
    final dots = Paint()..color = const Color(0x59FFFFFF);
    for (var d = 0.0; d < metric.length; d += 9) {
      canvas.drawCircle(metric.getTangentForOffset(d)!.position, 1.6, dots);
    }
    final travelled = metric.length * progress;
    canvas
      ..drawPath(
        metric.extractPath(0, travelled),
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      )
      ..drawCircle(
        Offset(8, size.height - 10),
        5,
        Paint()..color = AppColors.white,
      )
      ..drawCircle(
        Offset(w - 8, size.height - 10),
        6,
        Paint()..color = AppColors.white,
      )
      ..drawCircle(
        Offset(w - 8, size.height - 10),
        6,
        Paint()
          ..color = AppColors.sun
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );

    final at = metric.getTangentForOffset(travelled)!;
    final heading = math.atan2(at.vector.dy, at.vector.dx);
    final icon = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.flight_rounded.codePoint),
        style: TextStyle(
          fontSize: 26,
          fontFamily: Icons.flight_rounded.fontFamily,
          package: Icons.flight_rounded.fontPackage,
          color: AppColors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas
      ..save()
      ..translate(at.position.dx, at.position.dy - 3 * hover)
      ..rotate(heading + math.pi / 2);
    icon.paint(canvas, Offset(-icon.width / 2, -icon.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RoutePainter old) =>
      old.progress != progress || old.hover != hover;
}

class _Week extends StatelessWidget {
  const new({required this.week});

  final List<bool> week;

  @override
  Widget build(BuildContext context) {
    final labels = context.l10n.weekDays.split(',');
    final today = week.indexOf(false);
    return ExcludeSemantics(
      child: Row(
        children: [
          for (final (i, done) in week.indexed)
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? AppColors.gold
                          : (i == today ? AppColors.card : AppColors.line),
                      border: i == today
                          ? Border.all(color: AppColors.goldDeep, width: 2)
                          : null,
                      boxShadow: done
                          ? const [
                              BoxShadow(
                                color: AppColors.goldDeep,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: done
                        ? const Icon(
                            Icons.local_fire_department_rounded,
                            size: 18,
                            color: AppColors.sun,
                          )
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[i],
                    style: context.body(
                      10,
                      weight: FontWeight.w800,
                      color: AppColors.ink2,
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

class _TodayCard extends StatelessWidget {
  const new({required this.lesson, required this.onTap});

  final TodayLesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    return Semantics(
      button: true,
      label: l10n.startLesson,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.sun,
                borderRadius: AppRadii.button,
                boxShadow: [
                  BoxShadow(color: AppColors.sunDeep, offset: Offset(0, 4)),
                ],
              ),
              child: Text(
                lesson.glyph,
                style: context.japanese(26, color: AppColors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title.of(lang),
                    style: context.body(15, weight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.lessonMeta(lesson.minutes, lesson.unit, lesson.xp),
                    style: context.body(
                      12,
                      weight: FontWeight.w600,
                      color: AppColors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.sky,
                borderRadius: BorderRadius.all(Radius.circular(14)),
                boxShadow: [
                  BoxShadow(color: AppColors.skyDeep, offset: Offset(0, 4)),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChestCard extends StatelessWidget {
  const new({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const chest = sampleChest;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const CustomPaint(size: Size(44, 40), painter: _ChestPainter()),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chestTitle(chest.done, chest.total),
                  style: context.body(14, weight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                ChunkyBar(
                  value: chest.done / chest.total,
                  color: AppColors.gold,
                  height: 10,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.chestBody,
                  style: context.body(
                    12,
                    weight: FontWeight.w600,
                    color: AppColors.ink2,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.faint),
        ],
      ),
    );
  }
}

class _ChestPainter extends CustomPainter {
  const new();

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 40, size.height / 36);
    final rr = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 14, 34, 20),
      const Radius.circular(4),
    );
    canvas
      ..drawRRect(rr, Paint()..color = AppColors.goldDeep)
      ..drawArc(
        const Rect.fromLTWH(3, 4, 34, 24),
        math.pi,
        math.pi,
        true,
        Paint()..color = AppColors.gold,
      )
      ..drawRect(
        const Rect.fromLTWH(3, 20, 34, 3),
        Paint()..color = const Color(0xFFC97F00),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(17, 13, 6, 9),
          const Radius.circular(2),
        ),
        Paint()..color = AppColors.ink,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_ChestPainter old) => false;
}
