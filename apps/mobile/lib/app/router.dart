import 'package:go_router/go_router.dart';
import 'package:nihongo/app/shell.dart';
import 'package:nihongo/features/class/class_screen.dart';
import 'package:nihongo/features/home/home_screen.dart';
import 'package:nihongo/features/learn/learn_screen.dart';
import 'package:nihongo/features/lesson/lesson_complete_screen.dart';
import 'package:nihongo/features/lesson/lesson_controller.dart';
import 'package:nihongo/features/lesson/lesson_screen.dart';
import 'package:nihongo/features/onboarding/onboarding_screen.dart';
import 'package:nihongo/features/pass/pass_screen.dart';
import 'package:nihongo/features/profile/profile_screen.dart';
import 'package:nihongo/features/review/review_screen.dart';
import 'package:nihongo/features/tests/tests_screen.dart';

abstract final class Routes {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const learn = '/learn';
  static const tests = '/tests';
  static const pass = '/pass';
  static const classroom = '/class';
  static const review = '/review';
  static const profile = '/profile';
  static String lesson(String id) => '/lesson/$id';
  static String lessonComplete(String id) => '/lesson/$id/complete';
}

/// Dev shortcut: `flutter run --dart-define=START_ROUTE=/pass` opens a
/// screen directly. Onboarding every launch until settings persist (Phase 2).
const _startRoute = String.fromEnvironment(
  'START_ROUTE',
  defaultValue: Routes.onboarding,
);

StatefulShellBranch _tab(String path, GoRouterWidgetBuilder builder) =>
    StatefulShellBranch(
      routes: [GoRoute(path: path, builder: builder)],
    );

GoRouter buildRouter() => GoRouter(
  initialLocation: _startRoute,
  routes: [
    GoRoute(
      path: Routes.onboarding,
      builder: (_, _) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => AppShell(shell: shell),
      branches: [
        _tab(Routes.home, (_, _) => const HomeScreen()),
        _tab(Routes.learn, (_, _) => const LearnScreen()),
        _tab(Routes.tests, (_, _) => const TestsScreen()),
        _tab(Routes.pass, (_, _) => const PassScreen()),
        _tab(Routes.classroom, (_, _) => const ClassScreen()),
      ],
    ),
    GoRoute(path: Routes.review, builder: (_, _) => const ReviewScreen()),
    GoRoute(path: Routes.profile, builder: (_, _) => const ProfileScreen()),
    GoRoute(
      path: '/lesson/:id',
      builder: (_, state) =>
          LessonScreen(lessonId: state.pathParameters['id']!),
      routes: [
        GoRoute(
          path: 'complete',
          builder: (_, state) => LessonCompleteScreen(
            result: state.extra is LessonResult
                ? state.extra! as LessonResult
                : null,
          ),
        ),
      ],
    ),
  ],
);
