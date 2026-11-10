import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';

/// The course drawn as a metro line. Units are stations; the last stop is the
/// Japanese level the visa asks for.
class LearnScreen extends StatelessWidget {
  const new({super.key});

  static const _dot = 54.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const line = sampleLine;
    final now = line.indexWhere((s) => s.state == StationState.now);
    final reached = now / (line.length - 1);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.lineTitle, style: context.heading(22))),
              Pill('${(courseProgress * 100).round()}%', tone: PillTone.mint),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.lineBody,
            style: context.body(
              13,
              weight: FontWeight.w600,
              color: AppColors.ink2,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Positioned(
                left: _dot / 2 - 4,
                top: _dot / 2,
                bottom: _dot / 2,
                child: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    borderRadius: AppRadii.pill,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [
                        AppColors.mint,
                        AppColors.mint,
                        AppColors.line,
                        AppColors.line,
                      ],
                      stops: [0, reached, reached, 1],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  for (final station in line)
                    _StationRow(
                      station: station,
                      onTap: station.state == StationState.now
                          ? () => context.push(Routes.lesson(sampleToday.id))
                          : null,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StationRow extends StatelessWidget {
  const new({required this.station, required this.onTap});

  final Station station;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    final s = station.state;
    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.card,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              _StationDot(station: station),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.title.of(lang),
                      style: context.body(
                        15,
                        weight: FontWeight.w900,
                        color: s == StationState.locked
                            ? AppColors.ink2
                            : AppColors.ink,
                      ),
                    ),
                    Text(
                      station.subtitle.of(lang),
                      style: context.body(
                        12,
                        weight: FontWeight.w600,
                        color: AppColors.ink2,
                      ),
                    ),
                    if (station.lessonsTotal > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          for (var i = 0; i < station.lessonsTotal; i++)
                            Container(
                              width: 18,
                              height: 7,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: i < station.lessonsDone
                                    ? AppColors.sun
                                    : AppColors.line,
                                borderRadius: AppRadii.pill,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (s == StationState.now) Pill(l10n.nowTag, tone: PillTone.sun),
              if (s == StationState.locked)
                const Icon(
                  Icons.lock_rounded,
                  size: 18,
                  color: AppColors.dashed,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationDot extends StatelessWidget {
  const new({required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    final (Color face, Color edge, Color fg) = switch (station.state) {
      StationState.done => (
        AppColors.mint,
        AppColors.mintDeep,
        AppColors.white,
      ),
      StationState.now => (AppColors.sun, AppColors.sunDeep, AppColors.white),
      StationState.goal => (AppColors.gold, AppColors.goldDeep, AppColors.ink),
      StationState.locked => (AppColors.card, AppColors.line, AppColors.faint),
    };
    final glyph = station.glyph;
    final dot = Container(
      width: LearnScreen._dot,
      height: LearnScreen._dot,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: face,
        shape: BoxShape.circle,
        border: Border.all(
          color: station.state == StationState.locked
              ? AppColors.line
              : AppColors.white,
          width: 4,
        ),
        boxShadow: [BoxShadow(color: edge, offset: const Offset(0, 4))],
      ),
      child: station.state == StationState.done
          ? const Icon(Icons.check_rounded, color: AppColors.white, size: 26)
          : Text(
              glyph,
              style: glyph.codeUnitAt(0) < 128
                  ? context.display(15, color: fg)
                  : context.japanese(glyph.length > 1 ? 15 : 20, color: fg),
            ),
    );
    if (station.state != StationState.now) return dot;
    return LoopAnimation(
      duration: const Duration(milliseconds: 900),
      reverse: true,
      child: dot,
      builder: (context, t, child) => DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.sun.withValues(alpha: 0.18 - 0.1 * t),
              spreadRadius: 6 + 6 * t,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
