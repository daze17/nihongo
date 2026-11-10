import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mongolian first, English second. Not persisted yet (Drift settings, Phase 2).
final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('mn');

  // A method rather than a setter so it reads as an action at call sites.
  // ignore: use_setters_to_change_properties
  void set(Locale locale) => state = locale;
}
