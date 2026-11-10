import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';

/// Small uppercase label above a heading.
class Eyebrow extends StatelessWidget {
  const new(this.text, {super.key, this.color = AppColors.goldText});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.display(
        10,
        weight: FontWeight.w700,
        color: color,
        spacing: 0.14,
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(14),
    this.color = AppColors.card,
    this.radius = AppRadii.card,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadius radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius,
          boxShadow: AppShadows.card,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

enum Tone {
  sky(AppColors.sky, AppColors.skyDeep, AppColors.white),
  sun(AppColors.sun, AppColors.sunDeep, AppColors.white),
  mint(AppColors.mint, AppColors.mintDeep, AppColors.ink),
  gold(AppColors.gold, AppColors.goldDeep, AppColors.ink),
  white(AppColors.card, AppColors.line, AppColors.ink);

  new(this.face, this.edge, this.text);

  final Color face;
  final Color edge;
  final Color text;
}

/// Big 3D button that sinks when pressed. Disabled when [onPressed] is null.
class ChunkyButton extends StatefulWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.tone = Tone.sky,
    this.icon,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final Tone tone;
  final IconData? icon;
  final double height;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _down = false;

  static const _depth = 5.0;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final face = enabled ? widget.tone.face : AppColors.line;
    final edge = enabled ? widget.tone.edge : AppColors.line;
    final fg = enabled ? widget.tone.text : AppColors.faint;
    final sink = _down ? _depth : 0.0;
    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapCancel: enabled ? () => setState(() => _down = false) : null,
        onTapUp: enabled ? (_) => setState(() => _down = false) : null,
        onTap: widget.onPressed,
        child: SizedBox(
          height: widget.height + _depth,
          child: Stack(
            children: [
              Positioned.fill(
                top: _depth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: edge,
                    borderRadius: AppRadii.button,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 60),
                left: 0,
                right: 0,
                top: sink,
                height: widget.height,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: face,
                    borderRadius: AppRadii.button,
                    border: widget.tone == Tone.white
                        ? Border.all(color: AppColors.line, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: fg),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          widget.label.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.body(
                            15,
                            weight: FontWeight.w900,
                            color: fg,
                            spacing: 0.03,
                          ),
                        ),
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

enum PillTone {
  gold(AppColors.goldTint, AppColors.goldText),
  sun(AppColors.sunTint, AppColors.sunDeep),
  mint(AppColors.mintTint, AppColors.mintDeep),
  sky(AppColors.skyTint, AppColors.skyDeep),
  ghost(AppColors.line, AppColors.ink2);

  new(this.bg, this.fg);

  final Color bg;
  final Color fg;
}

class Pill extends StatelessWidget {
  const new(this.label, {super.key, this.tone = PillTone.ghost, this.icon});

  final String label;
  final PillTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: tone.bg, borderRadius: AppRadii.pill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: tone.fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: context.body(12, weight: FontWeight.w800, color: tone.fg),
          ),
        ],
      ),
    );
  }
}

/// Rounded progress bar with a glossy highlight.
class ChunkyBar extends StatelessWidget {
  const new({
    required this.value,
    super.key,
    this.color = AppColors.sky,
    this.track = AppColors.line,
    this.height = 12,
  });

  final double value;
  final Color color;
  final Color track;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.pill,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1)),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: track)),
              FractionallySizedBox(
                widthFactor: v,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Align(
                    alignment: const Alignment(0, -0.5),
                    child: Container(
                      height: height / 4,
                      margin: EdgeInsets.symmetric(horizontal: height / 2),
                      decoration: const BoxDecoration(
                        color: Color(0x59FFFFFF),
                        borderRadius: AppRadii.pill,
                      ),
                    ),
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

/// Runs [builder] with a repeating 0..1 value. Holds still at [restValue]
/// when the system asks for reduced motion (and in widget tests).
class LoopAnimation extends StatefulWidget {
  const new({
    required this.duration,
    required this.builder,
    super.key,
    this.reverse = false,
    this.restValue = 0,
    this.child,
  });

  final Duration duration;
  final bool reverse;
  final double restValue;
  final Widget? child;
  final Widget Function(BuildContext context, double t, Widget? child) builder;

  @override
  State<LoopAnimation> createState() => _LoopAnimationState();
}

class _LoopAnimationState extends State<LoopAnimation>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = widget.restValue;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: widget.reverse);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) =>
          widget.builder(context, _controller.value, child),
    );
  }
}

/// Daru, the daruma. Paint one eye for a wish, the second when it comes true.
class Daruma extends StatelessWidget {
  const new({required this.size, super.key, this.eyes = 1, this.bob = false});

  final double size;
  final int eyes;
  final bool bob;

  @override
  Widget build(BuildContext context) {
    final body = ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _DarumaPainter(eyes: eyes),
      ),
    );
    if (!bob) return body;
    return LoopAnimation(
      duration: const Duration(milliseconds: 1800),
      reverse: true,
      child: body,
      builder: (context, t, child) {
        final e = Curves.easeInOut.transform(t);
        return Transform.translate(
          offset: Offset(0, -size * 0.05 * e),
          child: Transform.rotate(angle: -0.05 * e, child: child),
        );
      },
    );
  }
}

class _DarumaPainter extends CustomPainter {
  const new({required this.eyes});

  final int eyes;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 100);
    final body = Path()
      ..moveTo(50, 5)
      ..cubicTo(79, 5, 95, 30, 95, 57)
      ..cubicTo(95, 83, 75, 97, 50, 97)
      ..cubicTo(25, 97, 5, 83, 5, 57)
      ..cubicTo(5, 30, 21, 5, 50, 5)
      ..close();
    final shade = Path()
      ..moveTo(50, 5)
      ..cubicTo(79, 5, 95, 30, 95, 57)
      ..cubicTo(95, 83, 75, 97, 50, 97)
      ..cubicTo(62, 90, 80, 78, 80, 55)
      ..cubicTo(80, 30, 66, 12, 50, 5)
      ..close();
    final ink = Paint()..color = AppColors.ink;
    final white = Paint()..color = AppColors.white;
    Paint stroke(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;

    canvas
      ..drawPath(body, Paint()..color = AppColors.sun)
      ..drawPath(
        shade,
        Paint()..color = AppColors.sunDeep.withValues(alpha: .35),
      )
      ..drawOval(
        Rect.fromCenter(center: const Offset(50, 45), width: 56, height: 48),
        white,
      )
      ..drawPath(
        Path()
          ..moveTo(28, 33)
          ..quadraticBezierTo(37, 26, 45, 32)
          ..moveTo(55, 32)
          ..quadraticBezierTo(63, 26, 72, 33),
        stroke(AppColors.goldDeep, 3.5),
      );

    void eye(Offset c, {required bool painted}) {
      if (painted) {
        canvas
          ..drawCircle(c, 7.5, ink)
          ..drawCircle(c + const Offset(2, -2), 2, white);
      } else {
        canvas.drawCircle(c, 7.5, stroke(AppColors.ink, 2.5));
      }
    }

    eye(const Offset(38, 45), painted: eyes >= 1);
    eye(const Offset(62, 45), painted: eyes >= 2);

    canvas
      ..drawPath(
        Path()
          ..moveTo(44, 58)
          ..quadraticBezierTo(50, 63, 56, 58),
        stroke(AppColors.ink, 3),
      )
      ..drawCircle(const Offset(30, 56), 4, Paint()..color = AppColors.blush)
      ..drawCircle(const Offset(70, 56), 4, Paint()..color = AppColors.blush)
      ..drawPath(
        Path()
          ..moveTo(28, 78)
          ..quadraticBezierTo(50, 90, 72, 78),
        stroke(AppColors.gold, 5),
      )
      ..drawPath(
        Path()
          ..moveTo(40, 86)
          ..quadraticBezierTo(50, 91, 60, 86),
        stroke(AppColors.gold, 4),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_DarumaPainter old) => old.eyes != eyes;
}

enum StampState { done, partial, empty }

/// A hanko seal. Collected stamps are red and tilted; empty ones are dashed.
class Hanko extends StatelessWidget {
  const new({
    required this.glyph,
    super.key,
    this.state = StampState.done,
    this.size = 50,
    this.progress = 0,
    this.caption,
  });

  final String glyph;
  final StampState state;
  final double size;

  /// 0..1, how much of a partial stamp is filled.
  final double progress;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      StampState.done => AppColors.sun,
      StampState.partial => AppColors.goldDeep,
      StampState.empty => AppColors.dashed,
    };
    final seal = Transform.rotate(
      angle: state == StampState.done ? -0.18 : 0,
      child: CustomPaint(
        size: Size.square(size),
        painter: _HankoPainter(state: state, progress: progress),
        child: SizedBox.square(
          dimension: size,
          child: Center(
            child: Text(
              glyph,
              style: context.japanese(size * 0.36, color: color),
            ),
          ),
        ),
      ),
    );
    if (caption == null) return seal;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        seal,
        const SizedBox(height: 4),
        Text(
          caption!,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: context.body(
            10,
            weight: FontWeight.w800,
            color: AppColors.ink2,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _HankoPainter extends CustomPainter {
  const new({required this.state, required this.progress});

  final StampState state;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 2;
    switch (state) {
      case StampState.done:
        canvas
          ..drawCircle(c, r, Paint()..color = AppColors.sunTint)
          ..drawCircle(
            c,
            r,
            Paint()
              ..color = AppColors.sun
              ..style = PaintingStyle.stroke
              ..strokeWidth = size.width * 0.06,
          );
      case StampState.partial:
        final rect = Rect.fromCircle(center: c, radius: r);
        canvas
          ..drawCircle(c, r, Paint()..color = AppColors.white)
          ..drawArc(
            rect,
            -math.pi / 2,
            math.pi * 2 * progress,
            true,
            Paint()..color = AppColors.goldTint,
          )
          ..drawCircle(
            c,
            r,
            Paint()
              ..color = AppColors.goldDeep
              ..style = PaintingStyle.stroke
              ..strokeWidth = size.width * 0.06,
          );
      case StampState.empty:
        final dash = Paint()
          ..color = AppColors.dashed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        const n = 16;
        for (var i = 0; i < n; i++) {
          canvas.drawArc(
            Rect.fromCircle(center: c, radius: r),
            i * 2 * math.pi / n,
            math.pi / n,
            false,
            dash,
          );
        }
    }
  }

  @override
  bool shouldRepaint(_HankoPainter old) =>
      old.state != state || old.progress != progress;
}

class HeartsBadge extends StatelessWidget {
  const new({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.heartsSemantics(count),
      excludeSemantics: true,
      child: Pill('$count', tone: PillTone.sun, icon: Icons.favorite),
    );
  }
}

/// Close button, progress bar and hearts across the top of a lesson.
class LessonTopBar extends StatelessWidget {
  const new({
    required this.progress,
    required this.hearts,
    required this.onClose,
    super.key,
  });

  final double progress;
  final int hearts;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onClose,
          tooltip: context.l10n.close,
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.faint,
            size: 28,
          ),
        ),
        Expanded(
          child: Semantics(
            label: context.l10n.progress,
            value: '${(progress * 100).round()}%',
            child: ChunkyBar(
              value: progress,
              color: AppColors.mint,
              height: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        HeartsBadge(count: hearts),
      ],
    );
  }
}

/// Label above a big number.
class StatTile extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    super.key,
    this.valueColor = AppColors.ink,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(label, color: AppColors.faint),
          const SizedBox(height: 6),
          Text(value, style: context.display(20, color: valueColor)),
        ],
      ),
    );
  }
}
