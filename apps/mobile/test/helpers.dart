import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Phone-sized screen, with reduced motion so looping animations hold still
/// and `pumpAndSettle` can finish.
void preparePhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

/// Buttons show their labels in capitals.
Finder buttonText(String label) => find.text(label.toUpperCase());
