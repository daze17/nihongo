import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/widgets.dart';

/// Why the student is going to Japan. Decides the course end point and the
/// requirement list on the boarding pass.
enum JapanPath {
  care('介', Tone.sun),
  engineer('技', Tone.sky),
  student('学', Tone.mint);

  new(this.glyph, this.tone);

  final String glyph;
  final Tone tone;

  String title(AppLocalizations l10n) => switch (this) {
    care => l10n.pathCare,
    engineer => l10n.pathEngineer,
    student => l10n.pathStudent,
  };

  String description(AppLocalizations l10n) => switch (this) {
    care => l10n.pathCareDesc,
    engineer => l10n.pathEngineerDesc,
    student => l10n.pathStudentDesc,
  };
}

class Onboarding {
  const new({
    required this.path,
    required this.dailyMinutes,
    required this.wishMade,
  });

  final JapanPath path;
  final int dailyMinutes;

  /// Daru's first eye is painted.
  final bool wishMade;

  Onboarding copyWith({JapanPath? path, bool? wishMade}) => Onboarding(
    path: path ?? this.path,
    dailyMinutes: dailyMinutes,
    wishMade: wishMade ?? this.wishMade,
  );
}

final onboardingProvider = NotifierProvider<OnboardingController, Onboarding>(
  OnboardingController.new,
);

class OnboardingController extends Notifier<Onboarding> {
  @override
  Onboarding build() =>
      const Onboarding(path: JapanPath.care, dailyMinutes: 15, wishMade: false);

  void setPath(JapanPath path) => state = state.copyWith(path: path);

  void makeWish() => state = state.copyWith(wishMade: true);
}
