import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/onboarding/onboarding_controller.dart';

/// "Make your wish": pick a path to Japan and paint Daru's first eye.
class OnboardingScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(onboardingProvider);
    final controller = ref.read(onboardingProvider.notifier);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        MediaQuery.paddingOf(context).top + 16,
                        24,
                        28,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.sky, Color(0xFF5D86FF)],
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(36),
                        ),
                      ),
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(end: state.wishMade ? 1 : 0),
                            duration: MediaQuery.disableAnimationsOf(context)
                                ? Duration.zero
                                : const Duration(milliseconds: 700),
                            curve: Curves.elasticOut,
                            builder: (context, t, child) => Transform.scale(
                              scale: 1 + 0.15 * t,
                              child: child,
                            ),
                            child: Semantics(
                              label: state.wishMade
                                  ? l10n.wishMade
                                  : l10n.wishTitle,
                              child: Daruma(
                                size: 140,
                                eyes: state.wishMade ? 1 : 0,
                                bob: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.wishMade ? l10n.wishMade : l10n.wishTitle,
                            textAlign: TextAlign.center,
                            style: context.heading(24, color: AppColors.white),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.wishMade ? l10n.wishMadeBody : l10n.wishBody,
                            textAlign: TextAlign.center,
                            style: context.body(
                              14,
                              color: const Color(0xFFDFE6FF),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    for (final path in JapanPath.values)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
                        child: _Ticket(
                          path: path,
                          selected: state.path == path,
                          onTap: state.wishMade
                              ? null
                              : () => controller.setPath(path),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(
                  children: [
                    ChunkyButton(
                      label: state.wishMade ? l10n.letsGo : l10n.paintEye,
                      tone: state.wishMade ? Tone.sky : Tone.sun,
                      icon: state.wishMade
                          ? Icons.flight_takeoff_rounded
                          : Icons.brush_rounded,
                      onPressed: state.wishMade
                          ? () => context.go(Routes.home)
                          : () {
                              HapticFeedback.mediumImpact().ignore();
                              controller.makeWish();
                            },
                    ),
                    TextButton(
                      onPressed: () => context.go(Routes.home),
                      child: Text(
                        l10n.haveClassCode,
                        style: context.body(
                          14,
                          weight: FontWeight.w800,
                          color: AppColors.sky,
                        ),
                      ),
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
}

/// A path to Japan, drawn as a ticket with punched sides.
class _Ticket extends StatelessWidget {
  const new({required this.path, required this.selected, required this.onTap});

  final JapanPath path;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppRadii.button,
              border: Border.all(
                color: selected ? AppColors.sun : AppColors.card,
                width: 3,
              ),
              boxShadow: AppShadows.card,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadii.button,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: path.tone.face.withValues(alpha: 0.14),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                        child: Text(
                          path.glyph,
                          style: context.japanese(20, color: path.tone.edge),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              path.title(l10n),
                              style: context.body(15, weight: FontWeight.w900),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              path.description(l10n),
                              style: context.body(
                                12,
                                weight: FontWeight.w600,
                                color: AppColors.ink2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedScale(
                        scale: selected ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: const CircleAvatar(
                          radius: 13,
                          backgroundColor: AppColors.sun,
                          child: Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          for (final left in [true, false])
            Positioned(
              top: 0,
              bottom: 0,
              left: left ? -9 : null,
              right: left ? null : -9,
              child: const Center(
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: AppColors.paper,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
