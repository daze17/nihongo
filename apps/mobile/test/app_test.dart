import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nihongo/app/app.dart';
import 'package:nihongo/app/theme.dart';

import 'helpers.dart';

Future<void> pumpApp(WidgetTester tester) async {
  preparePhone(tester);
  await tester.pumpWidget(
    ProviderScope(child: NihongoApp(fonts: AppFonts.system())),
  );
  await tester.pumpAndSettle();
}

Future<void> skipOnboarding(WidgetTester tester) async {
  await tester.tap(find.text('Надад ангийн код байна'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('making the wish leads home, and every tab opens', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Хүслээ хэлээрэй'), findsOneWidget);
    await tester.tap(find.text('Инженерээр ажиллах'));
    await tester.tap(buttonText('Эхний нүдийг будах'));
    await tester.pumpAndSettle();
    expect(find.text('Хүсэл чинь бичигдлээ!'), findsOneWidget);

    await tester.tap(buttonText('Эхэлцгээе'));
    await tester.pumpAndSettle();
    expect(find.text('ЯПОН РУУ НИСЛЭГ'), findsOneWidget);
    expect(find.text('45%'), findsOneWidget);

    for (final (tab, title) in [
      ('Суралцах', 'Япон руу шугам'),
      ('Шалгалт', '182'),
      ('Тасалбар', 'Миний тасалбар'),
      ('Анги', 'Миний анги'),
    ]) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget, reason: tab);
    }
  });

  testWidgets('a lesson builds a combo and ends with a stamp', (tester) async {
    await pumpApp(tester);
    await skipOnboarding(tester);
    await tester.tap(find.text('Тэ-хэлбэрээр гуйх'));
    await tester.pumpAndSettle();

    for (final answer in ['a', 'i', 'u']) {
      await tester.tap(find.text(answer));
      await tester.pump();
      await tester.tap(buttonText('Шалгах'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Зөв!'), findsOneWidget);
      if (answer == 'u') {
        expect(find.text('3 дараалан зөв · ×2 XP'), findsOneWidget);
      }
      await tester.tap(buttonText('Үргэлжлүүлэх'));
      await tester.pumpAndSettle();
    }

    // Tracing: draw both strokes of う.
    final canvas = find.byKey(const Key('trace-canvas'));
    for (var i = 0; i < 2; i++) {
      await tester.drag(canvas, const Offset(80, 20));
      await tester.pump();
    }
    await tester.tap(buttonText('Гайхалтай! Үргэлжлүүлэх'));
    await tester.pumpAndSettle();

    expect(find.text('Тамга авлаа!'), findsOneWidget);
    // 5 + 5, then double from the third right answer in a row: 10 + 10.
    expect(find.text('+30'), findsOneWidget);
    expect(find.textContaining('100%'), findsOneWidget);

    await tester.tap(buttonText('Цааш явах'));
    await tester.pumpAndSettle();
    expect(find.text('ЯПОН РУУ НИСЛЭГ'), findsOneWidget);
  });

  testWidgets('profile switches the app to English', (tester) async {
    await pumpApp(tester);
    await skipOnboarding(tester);
    await tester.tap(find.text('Анги'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Профайл'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('EN'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Learner'), findsOneWidget);
  });
}
