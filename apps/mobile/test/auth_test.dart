import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo/app/app.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/features/auth/auth_controller.dart';
import 'package:nihongo/features/auth/auth_gateway.dart';

import 'helpers.dart';

class FakeGateway implements AuthGateway {
  new({this.cancel = false});

  final bool cancel;
  final List<SignInMethod> requested = [];
  bool signedOut = false;

  @override
  Future<AuthUser?> restore() async => null;

  @override
  Future<AuthUser> signIn(SignInMethod method) async {
    requested.add(method);
    if (cancel) throw const SignInCancelled();
    return const AuthUser(
      id: 'facebook|42',
      name: 'Бат',
      email: 'bat@example.mn',
    );
  }

  @override
  Future<void> signOut() async => signedOut = true;

  @override
  Future<String?> accessToken() async => 'token';
}

Future<void> openProfile(WidgetTester tester, AuthGateway? gateway) async {
  preparePhone(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authGatewayProvider.overrideWithValue(gateway)],
      child: NihongoApp(fonts: AppFonts.system()),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Надад ангийн код байна'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Анги'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Профайл'));
  await tester.pumpAndSettle();
}

/// Scrolls the profile list until [finder] is on screen, then taps it.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(finder, 200);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signing in with Facebook shows the account', (tester) async {
    final gateway = FakeGateway();
    await openProfile(tester, gateway);

    await tapVisible(tester, find.text('Facebook-ээр нэвтрэх'));

    expect(gateway.requested, [SignInMethod.facebook]);
    expect(find.text('Бат'), findsWidgets);
    expect(find.text('Нэвтэрсэн: bat@example.mn'), findsOneWidget);

    await tapVisible(tester, find.text('Гарах'));
    expect(gateway.signedOut, isTrue);
    expect(find.text('Google-ээр нэвтрэх'), findsOneWidget);
  });

  testWidgets('closing the login page keeps the guest state quietly', (
    tester,
  ) async {
    await openProfile(tester, FakeGateway(cancel: true));

    await tapVisible(tester, find.text('Google-ээр нэвтрэх'));

    expect(find.text('Нэвтэрч чадсангүй. Дахин оролдоно уу.'), findsNothing);
    expect(find.text('Google-ээр нэвтрэх'), findsOneWidget);
  });

  testWidgets('without Auth0 config the buttons are disabled', (tester) async {
    await openProfile(tester, null);

    final email = find.text('И-мэйлээр нэвтрэх');
    await tester.scrollUntilVisible(email, 200);

    expect(
      find.text('Энэ хувилбарт нэвтрэх тохиргоо хийгдээгүй байна.'),
      findsOneWidget,
    );
    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(of: email, matching: find.bySubtype<ButtonStyleButton>()),
    );
    expect(button.onPressed, isNull);
  });
}
