import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihongo/features/auth/auth_config.dart';
import 'package:nihongo/features/auth/auth_gateway.dart';

/// Null when Auth0 isn't configured for this build; the app then stays in guest mode.
final authGatewayProvider = Provider<AuthGateway?>(
  (ref) => AuthConfig.isConfigured ? Auth0Gateway() : null,
);

/// The signed-in user, or null for a guest.
final authProvider = AsyncNotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthUser?> {
  AuthGateway? get _gateway => ref.read(authGatewayProvider);

  @override
  Future<AuthUser?> build() async => await _gateway?.restore();

  Future<void> signIn(SignInMethod method) async {
    final gateway = _gateway;
    if (gateway == null) return;
    final previous = state;
    state = const AsyncLoading();
    try {
      state = AsyncData(await gateway.signIn(method));
    } on SignInCancelled {
      state = previous;
    } on Object catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> signOut() async {
    await _gateway?.signOut();
    state = const AsyncData(null);
  }
}
