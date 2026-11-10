import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Road to Japan": Mongolia's blue sky, Japan's red sun, gold for rewards
/// and mint for right answers.
abstract final class AppColors {
  /// Primary actions, active tab, progress. White text on it is 5:1.
  static const sky = Color(0xFF2F5BFF);
  static const skyDeep = Color(0xFF1B2FB8);
  static const skyTint = Color(0xFFE7EDFF);
  static const skySoft = Color(0xFFCDD8FF);

  /// Daru, stamps, lesson tiles. White text uses [sunDeep] behind it.
  static const sun = Color(0xFFFF3B30);
  static const sunDeep = Color(0xFFC71F16);
  static const sunTint = Color(0xFFFFE8E6);
  static const blush = Color(0xFFFF9A9A);

  /// XP, streak, chests. Text on it is ink.
  static const gold = Color(0xFFFFC93C);
  static const goldDeep = Color(0xFFE09A00);
  static const goldTint = Color(0xFFFFF5D6);
  static const goldText = Color(0xFF8A5A00);

  /// Correct answers. Text on it is ink.
  static const mint = Color(0xFF12C48B);
  static const mintDeep = Color(0xFF0A7F59);
  static const mintTint = Color(0xFFDDF8EE);

  static const violet = Color(0xFF7B3CFF);

  static const paper = Color(0xFFF6F7FC);
  static const card = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0F1222);
  static const ink2 = Color(0xFF4A5070);
  static const faint = Color(0xFF8A90AE);
  static const line = Color(0xFFE3E6F2);
  static const dashed = Color(0xFFC6CBE0);
  static const white = Color(0xFFFFFFFF);
}

abstract final class AppShadows {
  static const card = [
    BoxShadow(color: Color(0x0F0F1222), blurRadius: 18, offset: Offset(0, 6)),
  ];
  static const lifted = [
    BoxShadow(color: Color(0x1A0F1222), blurRadius: 24, offset: Offset(0, 10)),
  ];
}

abstract final class AppRadii {
  static const button = BorderRadius.all(Radius.circular(16));
  static const card = BorderRadius.all(Radius.circular(20));
  static const large = BorderRadius.all(Radius.circular(24));
  static const pill = BorderRadius.all(Radius.circular(999));
}

typedef StyleBuilder = TextStyle Function(TextStyle style);

/// Font families. google_fonts loads one file per weight, so each weight has
/// to go through its builder instead of `copyWith(fontWeight: ...)`.
@immutable
class AppFonts extends ThemeExtension<AppFonts> {
  const new({
    required this.body,
    required this.display,
    required this.japanese,
  });

  /// Uses the platform font. Tests use this so they never hit the network.
  factory system() =>
      const AppFonts(body: _same, display: _same, japanese: _same);

  factory google() {
    return AppFonts(
      // Nunito covers Mongolian Cyrillic; Japanese falls back to a rounded face.
      body: (s) => GoogleFonts.nunito(textStyle: s).copyWith(
        fontFamilyFallback: [
          GoogleFonts.mPlusRounded1c(fontWeight: s.fontWeight).fontFamily!,
        ],
      ),
      // Headings, numbers and labels. Also covers Cyrillic.
      display: (s) => GoogleFonts.unbounded(textStyle: s),
      japanese: (s) => GoogleFonts.mPlusRounded1c(textStyle: s),
    );
  }

  static TextStyle _same(TextStyle s) => s;

  final StyleBuilder body;
  final StyleBuilder display;
  final StyleBuilder japanese;

  @override
  AppFonts copyWith({
    StyleBuilder? body,
    StyleBuilder? display,
    StyleBuilder? japanese,
  }) {
    return AppFonts(
      body: body ?? this.body,
      display: display ?? this.display,
      japanese: japanese ?? this.japanese,
    );
  }

  @override
  AppFonts lerp(covariant AppFonts? other, double t) => this;
}

ThemeData buildAppTheme({required AppFonts fonts}) {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.sky,
      primary: AppColors.sky,
      surface: AppColors.card,
      onSurface: AppColors.ink,
      error: AppColors.sunDeep,
    ),
    scaffoldBackgroundColor: AppColors.paper,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );
  TextStyle? apply(TextStyle? s) => s == null ? null : fonts.body(s);
  final t = base.textTheme.apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  );
  return base.copyWith(
    textTheme: TextTheme(
      displayLarge: apply(t.displayLarge),
      displayMedium: apply(t.displayMedium),
      displaySmall: apply(t.displaySmall),
      headlineLarge: apply(t.headlineLarge),
      headlineMedium: apply(t.headlineMedium),
      headlineSmall: apply(t.headlineSmall),
      titleLarge: apply(t.titleLarge),
      titleMedium: apply(t.titleMedium),
      titleSmall: apply(t.titleSmall),
      bodyLarge: apply(t.bodyLarge),
      bodyMedium: apply(t.bodyMedium),
      bodySmall: apply(t.bodySmall),
      labelLarge: apply(t.labelLarge),
      labelMedium: apply(t.labelMedium),
      labelSmall: apply(t.labelSmall),
    ),
    extensions: [fonts],
  );
}

/// Shorthand for the type scale used in the mockups.
extension AppTextX on BuildContext {
  AppFonts get _fonts => Theme.of(this).extension<AppFonts>()!;

  TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.ink,
    double spacing = 0,
    double? height,
  }) => _fonts.body(
    TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: size * spacing,
      height: height,
    ),
  );

  /// Rounded, heavy heading in the display face.
  TextStyle heading(double size, {Color color = AppColors.ink}) =>
      display(size, weight: FontWeight.w700, color: color, spacing: -0.01);

  TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w900,
    Color color = AppColors.ink,
    double spacing = 0,
  }) => _fonts.display(
    TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: size * spacing,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
  );

  TextStyle japanese(
    double size, {
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.ink,
  }) => _fonts.japanese(
    TextStyle(fontSize: size, fontWeight: weight, color: color, height: 1),
  );
}
