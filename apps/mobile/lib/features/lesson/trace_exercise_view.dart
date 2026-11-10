import 'package:flutter/material.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/sample_data.dart';
import 'package:nihongo/core/widgets.dart';

/// Stroke guides on a 320×320 grid. Real stroke data (KanjiVG) and shape
/// checking come with the content pipeline; for now we count strokes.
final Map<String, List<Path Function()>> _guides = {
  'う': [
    () => Path()
      ..moveTo(124, 70)
      ..quadraticBezierTo(160, 92, 196, 80),
    () => Path()
      ..moveTo(100, 158)
      ..quadraticBezierTo(170, 120, 214, 170)
      ..quadraticBezierTo(244, 214, 196, 262)
      ..quadraticBezierTo(170, 284, 132, 286),
  ],
};

class TraceExerciseView extends StatefulWidget {
  const new({required this.exercise, required this.onDone, super.key});

  final TraceExercise exercise;
  final VoidCallback onDone;

  @override
  State<TraceExerciseView> createState() => _TraceExerciseViewState();
}

class _TraceExerciseViewState extends State<TraceExerciseView> {
  final List<List<Offset>> _strokes = [];

  List<Path> get _guidePaths =>
      (_guides[widget.exercise.kana.char] ?? const []).map((f) => f()).toList();

  int get _total => _guidePaths.isEmpty ? 1 : _guidePaths.length;
  bool get _done => _strokes.length >= _total;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kana = widget.exercise.kana.char;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Eyebrow(l10n.traceEyebrow),
              const SizedBox(height: 8),
              Text(l10n.traceTitle(kana), style: context.heading(22)),
              const SizedBox(height: 6),
              Text(
                _done
                    ? l10n.traceDone
                    : l10n.traceHint(_strokes.length + 1, _total),
                style: context.body(
                  14,
                  weight: FontWeight.w600,
                  color: AppColors.ink2,
                ),
              ),
              const SizedBox(height: 22),
              Center(child: _canvas(context, kana)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SmallButton(
                    label: l10n.undo,
                    onTap: _strokes.isEmpty
                        ? null
                        : () => setState(_strokes.removeLast),
                  ),
                  const SizedBox(width: 12),
                  _SmallButton(
                    label: l10n.clear,
                    outlined: true,
                    onTap: _strokes.isEmpty
                        ? null
                        : () => setState(_strokes.clear),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            16 + MediaQuery.paddingOf(context).bottom,
          ),
          child: ChunkyButton(
            label: _done ? l10n.traceContinue : l10n.finishStrokes,
            tone: Tone.mint,
            onPressed: _done ? widget.onDone : null,
          ),
        ),
      ],
    );
  }

  Widget _canvas(BuildContext context, String kana) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.maxWidth.clamp(0, 320).toDouble();
        return Semantics(
          label: context.l10n.traceArea(kana),
          child: Container(
            width: side,
            height: side,
            decoration: const BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadii.large,
              boxShadow: AppShadows.card,
            ),
            clipBehavior: Clip.antiAlias,
            child: GestureDetector(
              key: const Key('trace-canvas'),
              onPanStart: _done
                  ? null
                  : (d) => setState(
                      () => _strokes.add([d.localPosition / (side / 320)]),
                    ),
              onPanUpdate: _done
                  ? null
                  : (d) => setState(
                      () => _strokes.last.add(d.localPosition / (side / 320)),
                    ),
              child: CustomPaint(
                size: Size.square(side),
                painter: _TracePainter(
                  guides: _guidePaths,
                  strokes: _strokes,
                  fallbackKana: _guidePaths.isEmpty ? kana : null,
                  nextStroke: _done ? null : _strokes.length,
                  textStyle: context.japanese(220, color: AppColors.line),
                  numberStyle: context.display(14, color: AppColors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TracePainter extends CustomPainter {
  new({
    required this.guides,
    required this.strokes,
    required this.fallbackKana,
    required this.nextStroke,
    required this.textStyle,
    required this.numberStyle,
  });

  final List<Path> guides;
  final List<List<Offset>> strokes;
  final String? fallbackKana;
  final int? nextStroke;
  final TextStyle textStyle;
  final TextStyle numberStyle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 320);
    final dashed = Paint()
      ..color = AppColors.line
      ..strokeWidth = 2;
    for (var i = 0.0; i < 320; i += 16) {
      canvas
        ..drawLine(Offset(160, i), Offset(160, i + 8), dashed)
        ..drawLine(Offset(i, 160), Offset(i + 8, 160), dashed);
    }

    if (fallbackKana != null) {
      final tp = TextPainter(
        text: TextSpan(text: fallbackKana, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(160 - tp.width / 2, 160 - tp.height / 2));
    }

    final guide = Paint()
      ..color = AppColors.skyTint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;
    for (final p in guides) {
      canvas.drawPath(p, guide);
    }

    final ink = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawCircle(s.first, 8, Paint()..color = AppColors.ink);
        continue;
      }
      final path = Path()..moveTo(s.first.dx, s.first.dy);
      for (final o in s.skip(1)) {
        path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(path, ink);
    }

    final next = nextStroke;
    if (next != null && next < guides.length) {
      final start = guides[next].computeMetrics().first.getTangentForOffset(0)!;
      canvas.drawCircle(start.position, 14, Paint()..color = AppColors.sun);
      final tp = TextPainter(
        text: TextSpan(text: '${next + 1}', style: numberStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, start.position - Offset(tp.width / 2, tp.height / 2));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}

class _SmallButton extends StatelessWidget {
  const new({required this.label, required this.onTap, this.outlined = false});

  final String label;
  final VoidCallback? onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: AppColors.card,
      foregroundColor: AppColors.ink,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
      side: BorderSide(
        color: outlined ? AppColors.ink : AppColors.line,
        width: 2,
      ),
      textStyle: context.body(14, weight: FontWeight.w800),
    );
    return OutlinedButton(onPressed: onTap, style: style, child: Text(label));
  }
}
