import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/locale.dart';
import 'package:nihongo/app/router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = buildRouter();
  ref.onDispose(router.dispose);
  return router;
});

class NihongoApp extends ConsumerWidget {
  const new({super.key, this.fonts});

  /// Defaults to Google Fonts; tests pass [AppFonts.system].
  final AppFonts? fonts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(fonts: fonts ?? AppFonts.google()),
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
