import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';
import 'package:nihongo/core/widgets.dart';
import 'package:nihongo/features/auth/auth_controller.dart';
import 'package:nihongo/features/auth/auth_gateway.dart';

/// Sign-in buttons for guests, or the account and a sign-out button.
class AccountCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final configured = ref.watch(authGatewayProvider) != null;
    final auth = ref.watch(authProvider);
    final user = auth.value;
    final busy = auth.isLoading;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Eyebrow(l10n.accountEyebrow),
          const SizedBox(height: 10),
          if (user != null) ...[
            Text(
              user.name ?? user.email ?? user.id,
              style: context.heading(16),
            ),
            if (user.email != null) ...[
              const SizedBox(height: 2),
              Text(
                l10n.signedInAs(user.email!),
                style: context.body(
                  13,
                  weight: FontWeight.w600,
                  color: AppColors.ink2,
                ),
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: busy
                  ? null
                  : () => ref.read(authProvider.notifier).signOut(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: AppColors.ink,
                side: const BorderSide(color: AppColors.ink, width: 2),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.button,
                ),
              ),
              child: Text(
                l10n.signOut,
                style: context.body(14, weight: FontWeight.w800),
              ),
            ),
          ] else ...[
            Text(l10n.signInTitle, style: context.heading(16)),
            const SizedBox(height: 4),
            Text(
              configured ? l10n.signInBody : l10n.signInUnavailable,
              style: context.body(
                13,
                weight: FontWeight.w600,
                color: AppColors.ink2,
              ),
            ),
            if (auth.hasError) ...[
              const SizedBox(height: 8),
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.signInFailed,
                  style: context.body(13, color: AppColors.sunDeep),
                ),
              ),
            ],
            const SizedBox(height: 12),
            for (final method in _methodsFor(defaultTargetPlatform)) ...[
              _SignInButton(
                method: method,
                onPressed: configured && !busy
                    ? () => ref.read(authProvider.notifier).signIn(method)
                    : null,
              ),
              const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }

  /// Apple sign-in only on Apple devices, where the App Store requires it
  /// alongside Google and Facebook.
  static List<SignInMethod> _methodsFor(TargetPlatform platform) => [
    SignInMethod.google,
    SignInMethod.facebook,
    if (platform == TargetPlatform.iOS) SignInMethod.apple,
    SignInMethod.email,
  ];
}

class _SignInButton extends StatelessWidget {
  const new({required this.method, required this.onPressed});

  final SignInMethod method;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (IconData icon, String label) = switch (method) {
      SignInMethod.google => (Icons.g_mobiledata, l10n.signInGoogle),
      SignInMethod.facebook => (Icons.facebook, l10n.signInFacebook),
      SignInMethod.apple => (Icons.apple, l10n.signInApple),
      SignInMethod.email => (Icons.mail_outline, l10n.signInEmail),
    };
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label, style: context.body(14, weight: FontWeight.w800)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: AppColors.line, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.button),
      ),
    );
  }
}
