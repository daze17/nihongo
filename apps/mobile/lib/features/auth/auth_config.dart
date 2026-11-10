/// Auth0 settings, passed at build time:
/// `flutter run --dart-define-from-file=config/dev.json` (see config/dev.example.json).
/// Android reads the same values in android/app/build.gradle.kts.
abstract final class AuthConfig {
  static const domain = String.fromEnvironment('AUTH0_DOMAIN');
  static const clientId = String.fromEnvironment('AUTH0_CLIENT_ID');

  /// Identifier of the Nihongo API in Auth0. Access tokens are issued for it.
  static const audience = String.fromEnvironment('AUTH0_AUDIENCE');

  /// Custom URL scheme for the login callback. Must match `auth0Scheme` on Android.
  static const scheme = 'com.bilguun.nihongo';

  static bool get isConfigured =>
      domain.isNotEmpty && clientId.isNotEmpty && audience.isNotEmpty;
}
