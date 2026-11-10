import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:nihongo/features/auth/auth_config.dart';

/// Sign-in options shown in the app. Each maps to an Auth0 connection;
/// email opens Auth0's own login page, which offers email and password or a code.
enum SignInMethod {
  google('google-oauth2'),
  facebook('facebook'),
  apple('apple'),
  email(null);

  new(this.connection);

  final String? connection;
}

class AuthUser {
  const new({required this.id, this.name, this.email, this.pictureUrl});

  /// Auth0 user id, e.g. `google-oauth2|1098…`.
  final String id;
  final String? name;
  final String? email;
  final Uri? pictureUrl;
}

/// Thrown when the person closes the login page. Not an error to show.
class SignInCancelled implements Exception {
  const new();
}

/// Everything the app needs from the identity provider. Faked in tests.
abstract interface class AuthGateway {
  /// The stored session, if any. Refreshes tokens when needed.
  Future<AuthUser?> restore();

  Future<AuthUser> signIn(SignInMethod method);

  Future<void> signOut();

  /// A valid access token for the Nihongo API, refreshed if expired.
  Future<String?> accessToken();
}

class Auth0Gateway implements AuthGateway {
  new() : _auth0 = Auth0(AuthConfig.domain, AuthConfig.clientId);

  final Auth0 _auth0;

  WebAuthentication get _web =>
      _auth0.webAuthentication(scheme: AuthConfig.scheme);

  @override
  Future<AuthUser?> restore() async {
    final manager = _auth0.credentialsManager;
    if (!await manager.hasValidCredentials()) return null;
    final profile = await manager.user();
    return profile == null ? null : _toUser(profile);
  }

  @override
  Future<AuthUser> signIn(SignInMethod method) async {
    try {
      final credentials = await _web.login(
        audience: AuthConfig.audience,
        parameters: {
          if (method.connection != null) 'connection': method.connection!,
        },
      );
      return _toUser(credentials.user);
    } on WebAuthenticationException catch (e) {
      if (e.isUserCancelledException) throw const SignInCancelled();
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _web.logout();
    } on WebAuthenticationException catch (e) {
      // Closing the logout page still signs out locally.
      if (!e.isUserCancelledException) rethrow;
      await _auth0.credentialsManager.clearCredentials();
    }
  }

  @override
  Future<String?> accessToken() async {
    final manager = _auth0.credentialsManager;
    if (!await manager.hasValidCredentials()) return null;
    return (await manager.credentials()).accessToken;
  }

  AuthUser _toUser(UserProfile p) => AuthUser(
    id: p.sub,
    name: p.name ?? p.nickname,
    email: p.email,
    pictureUrl: p.pictureUrl,
  );
}
