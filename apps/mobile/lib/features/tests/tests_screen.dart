import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';

/// Latest mock JFT-Basic, framed as distance to the pass line.
class TestsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    const r = sampleMock;
    final weakest = r.weakest;
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.testsTitle, style: context.heading(22)),
              ),
              Pill('#${r.attempt}'),
            ],
          ),
          const SizedBox(height: 8),
          Semantics(
            label: '${r.score} / ${r.max}',
            excludeSemantics: true,
            child: SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned.fill(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: r.score / r.max),
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => CustomPaint(
                        painter: _GaugePainter(
                          value: v,
                          passLine: r.passLine / r.max,
                          label: '${r.passLine}',
                          labelStyle: context.body(
                            12,
                            weight: FontWeight.w900,
                            color: AppColors.sunDeep,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${r.score}', style: context.display(44)),
                        Text(
                          l10n.scoreOf(r.gain, r.max),
                          style: context.body(
                            12,
                            weight: FontWeight.w800,
                            color: AppColors.ink2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.ink,
              borderRadius: AppRadii.card,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.track_changes_rounded,
                  color: AppColors.gold,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pointsToPass(r.toPass),
                        style: context.body(
                          14,
                          weight: FontWeight.w900,
                          color: AppColors.gold,
                        ),
                      ),
                      Text(
                        l10n.readyIn(r.weeksToReady),
                        style: context.body(13, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (var row = 0; row < r.sections.length; row += 2) ...[
            Row(
              children: [
                for (final (i, s) in r.sections.skip(row).take(2).indexed) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(
                    child: _SectionTile(
                      section: s,
                      weakest: identical(s, weakest),
                      lang: lang,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          ChunkyButton(
            label: l10n.fixSection(10, weakest.name.of(lang)),
            tone: Tone.sun,
            icon: Icons.headphones_rounded,
            onPressed: () => context.push(Routes.lesson(sampleToday.id)),
          ),
        ],
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const new({required this.section, required this.weakest, required this.lang});

  final TestSection section;
  final bool weakest;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = weakest ? AppColors.sun : AppColors.mint;
    return AppCard(
      color: weakest ? AppColors.sunTint : AppColors.card,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weakest
                ? '${section.name.of(lang)} · ${l10n.weakest}'
                : section.name.of(lang),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.body(
              11,
              weight: FontWeight.w800,
              color: AppColors.ink2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(section.score * 100).round()}%',
            style: context.display(
              20,
              color: weakest ? AppColors.sunDeep : AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          ChunkyBar(value: section.score, color: color, height: 8),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const new({
    required this.value,
    required this.passLine,
    required this.label,
    required this.labelStyle,
  });

  final double value;
  final double passLine;
  final String label;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.min(size.width / 2 - 30, size.height - 16);
    final c = Offset(size.width / 2, size.height - 6);
    final rect = Rect.fromCircle(center: c, radius: r);
    Paint arc(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawArc(rect, math.pi, math.pi, false, arc(AppColors.line))
      ..drawArc(rect, math.pi, math.pi * value, false, arc(AppColors.sky));

    final a = math.pi + math.pi * passLine;
    final dir = Offset(math.cos(a), math.sin(a));
    canvas.drawLine(
      c + dir * (r - 13),
      c + dir * (r + 13),
      Paint()
        ..color = AppColors.sun
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    final tp = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c + dir * (r + 26) - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}
