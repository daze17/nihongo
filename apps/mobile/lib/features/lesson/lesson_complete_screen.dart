import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/lesson/lesson_controller.dart';

/// The one big celebration: a hanko slams down, confetti falls and XP,
/// streak and flight distance go up together.
class LessonCompleteScreen extends StatelessWidget {
  const new({required this.result, super.key});

  /// Null when opened by deep link; shows zeros.
  final LessonResult? result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final r =
        result ??
        const LessonResult(
          xp: 0,
          accuracy: 0,
          duration: Duration.zero,
          kanaLearned: 0,
        );
    final seconds = (r.duration.inSeconds % 60).toString().padLeft(2, '0');
    final time = '${r.duration.inMinutes}:$seconds';
    final passed = sampleClass.justBehind;
    final still = MediaQuery.disableAnimationsOf(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.35),
              radius: 1.1,
              colors: [
                Color(0xFFFFE08A),
                AppColors.gold,
                Color(0xFFFF8A3C),
                AppColors.sun,
              ],
              stops: [0, 0.28, 0.62, 1],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: LoopAnimation(
                  duration: const Duration(seconds: 24),
                  builder: (context, t, _) =>
                      CustomPaint(painter: _RaysPainter(turn: t)),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: LoopAnimation(
                    duration: const Duration(seconds: 3),
                    builder: (context, t, _) => still
                        ? const SizedBox.shrink()
                        : CustomPaint(painter: _ConfettiPainter(t: t)),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: still
                            ? Duration.zero
                            : const Duration(milliseconds: 700),
                        curve: Curves.elasticOut,
                        builder: (context, t, child) => Transform.scale(
                          scale: 1.8 - 0.8 * t,
                          child: Transform.rotate(
                            angle: -0.5 + 0.3 * t,
                            child: child,
                          ),
                        ),
                        child: _BigStamp(
                          glyph: r.glyph.isEmpty ? '済' : r.glyph,
                          label: sampleToday.unit,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        l10n.stampCollected,
                        style: context
                            .heading(26, color: AppColors.white)
                            .copyWith(
                              shadows: const [
                                Shadow(
                                  color: Color(0x59961E00),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.accuracyTime(
                          '${(r.accuracy * 100).round()}%',
                          time,
                        ),
                        style: context.body(
                          14,
                          weight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _Gain(
                            value: '+${r.xp}',
                            label: 'XP',
                            color: AppColors.goldDeep,
                          ),
                          const SizedBox(width: 8),
                          _Gain(
                            value: '${sampleStats.streakDays + 1}',
                            label: l10n.gainStreak,
                            color: AppColors.sun,
                            icon: Icons.local_fire_department_rounded,
                          ),
                          const SizedBox(width: 8),
                          _Gain(
                            value: l10n.kmGain(sampleJourney.kmPerLesson),
                            label: l10n.gainFlight,
                            color: AppColors.sky,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (passed != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xD90F1222),
                            borderRadius: AppRadii.card,
                          ),
                          child: Row(
                            children: [
                              const Daruma(size: 40),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  l10n.rewardLeague(passed.name),
                                  style: context.body(
                                    13,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      ChunkyButton(
                        label: l10n.keepGoing,
                        icon: Icons.flight_takeoff_rounded,
                        onPressed: () => context.go(Routes.home),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BigStamp extends StatelessWidget {
  const new({required this.glyph, required this.label});

  final String glyph;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.2,
      child: Container(
        width: 156,
        height: 156,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xE6FFFFFF),
          border: Border.all(color: AppColors.sun, width: 7),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D781400),
              blurRadius: 30,
              offset: Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.sun, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(glyph, style: context.japanese(58, color: AppColors.sun)),
              const SizedBox(height: 8),
              Text(
                label,
                style: context.display(
                  9,
                  weight: FontWeight.w700,
                  color: AppColors.sun,
                  spacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Gain extends StatelessWidget {
  const new({
    required this.value,
    required this.label,
    required this.color,
    this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: const BoxDecoration(
          color: Color(0xEBFFFFFF),
          borderRadius: AppRadii.card,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, size: 20, color: color),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      value,
                      style: context.display(19, color: color),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: context.body(
                10,
                weight: FontWeight.w800,
                color: AppColors.ink2,
                spacing: 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RaysPainter extends CustomPainter {
  const new({required this.turn});

  final double turn;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height * 0.3);
    final r = size.longestSide;
    final paint = Paint()..color = const Color(0x2EFFFFFF);
    const n = 18;
    for (var i = 0; i < n; i++) {
      final a = (i / n + turn) * 2 * math.pi;
      final path = Path()
        ..moveTo(c.dx, c.dy)
        ..lineTo(c.dx + r * math.cos(a), c.dy + r * math.sin(a))
        ..lineTo(
          c.dx + r * math.cos(a + math.pi / n),
          c.dy + r * math.sin(a + math.pi / n),
        )
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_RaysPainter old) => old.turn != turn;
}

class _ConfettiPainter extends CustomPainter {
  const new({required this.t});

  final double t;

  static const List<Color> _colors = [
    AppColors.sky,
    AppColors.white,
    AppColors.mint,
    AppColors.violet,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(7);
    for (var i = 0; i < 28; i++) {
      final x = rng.nextDouble() * size.width;
      final phase = rng.nextDouble();
      final speed = 0.7 + rng.nextDouble() * 0.6;
      final y = ((t * speed + phase) % 1) * (size.height + 40) - 20;
      canvas
        ..save()
        ..translate(x + math.sin((t + phase) * 6) * 10, y)
        ..rotate((t + phase) * 9)
        ..drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-4, -7, 8, 14),
            const Radius.circular(2),
          ),
          Paint()..color = _colors[i % _colors.length],
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
