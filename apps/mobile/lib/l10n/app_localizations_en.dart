// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nihongo';

  @override
  String get close => 'Close';

  @override
  String get progress => 'Progress';

  @override
  String heartsSemantics(Object count) {
    return '$count hearts';
  }

  @override
  String streakSemantics(Object count) {
    return '$count-day streak';
  }

  @override
  String gemsSemantics(Object count) {
    return '$count gems';
  }

  @override
  String get mainMenu => 'Main menu';

  @override
  String minutes(Object count) {
    return '$count min';
  }

  @override
  String days(Object count) {
    return '$count days';
  }

  @override
  String get continueLabel => 'Continue';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navTests => 'Tests';

  @override
  String get navPass => 'Pass';

  @override
  String get navClass => 'Class';

  @override
  String get navProfile => 'Profile';

  @override
  String get wishTitle => 'Make your wish';

  @override
  String get wishBody =>
      'Pick where you\'re going. Daru gets his first eye; the second one waits for you in Japan.';

  @override
  String get wishMade => 'Wish made!';

  @override
  String get wishMadeBody =>
      'Fill your boarding pass with stamps and Daru gets his second eye.';

  @override
  String get paintEye => 'Paint the first eye';

  @override
  String get letsGo => 'Let\'s go';

  @override
  String get haveClassCode => 'I have a class code';

  @override
  String get pathCare => 'Work in Japan · Care';

  @override
  String get pathCareDesc => '特定技能 · needs JFT-Basic';

  @override
  String get pathEngineer => 'Work as an engineer';

  @override
  String get pathEngineerDesc => 'Degree + Japanese';

  @override
  String get pathStudent => 'Study in Japan';

  @override
  String get pathStudentDesc => 'Language school or university';

  @override
  String hello(Object name) {
    return 'Hi, $name!';
  }

  @override
  String get flightEyebrow => 'Flight to Japan';

  @override
  String kmToGo(Object km) {
    return '· $km km to go';
  }

  @override
  String get routeFrom => 'ULN · Ulaanbaatar';

  @override
  String get routeTo => 'Tokyo · NRT';

  @override
  String flightSemantics(Object percent) {
    return '$percent ready for Japan';
  }

  @override
  String get weekDays => 'M,T,W,T,F,S,S';

  @override
  String lessonMeta(Object minutes, Object unit, Object xp) {
    return '$unit · $minutes min · +$xp XP';
  }

  @override
  String get startLesson => 'Start lesson';

  @override
  String chestTitle(Object done, Object total) {
    return 'Daily chest · $done / $total';
  }

  @override
  String get chestBody => 'Finish one review to open';

  @override
  String get lineTitle => 'The Japan Line';

  @override
  String get lineBody => 'Every station is a stamp. Last stop: visa level.';

  @override
  String get nowTag => 'Now';

  @override
  String get newKanaEyebrow => 'New kana';

  @override
  String get choiceQuestion => 'How is this character read?';

  @override
  String get playSound => 'Play sound';

  @override
  String get check => 'Check';

  @override
  String get cheer => 'すごい!';

  @override
  String correctTitle(Object kana, Object romaji) {
    return 'Correct! $kana = $romaji';
  }

  @override
  String wrongTitle(Object romaji) {
    return 'Not quite. Answer: $romaji';
  }

  @override
  String get wrongHint => 'This one comes back later.';

  @override
  String get gotIt => 'Got it';

  @override
  String combo(Object count) {
    return '$count in a row · ×2 XP';
  }

  @override
  String get traceEyebrow => 'Writing';

  @override
  String traceTitle(Object kana) {
    return 'Trace $kana';
  }

  @override
  String traceHint(Object current, Object total) {
    return 'Stroke $current of $total · start at the red dot';
  }

  @override
  String get traceDone => 'All strokes drawn.';

  @override
  String traceArea(Object kana) {
    return 'Drawing area for $kana';
  }

  @override
  String get undo => 'Undo';

  @override
  String get clear => 'Clear';

  @override
  String get finishStrokes => 'Finish the strokes';

  @override
  String get traceContinue => 'Great! Continue';

  @override
  String get stampCollected => 'Stamp collected!';

  @override
  String get gainStreak => 'Streak';

  @override
  String get gainFlight => 'Flight';

  @override
  String kmGain(Object km) {
    return '+$km km';
  }

  @override
  String accuracyTime(Object percent, Object time) {
    return '$percent correct · $time';
  }

  @override
  String rewardLeague(Object name) {
    return '$name just fell behind you in the class league!';
  }

  @override
  String get keepGoing => 'Keep going';

  @override
  String get testsTitle => 'Mock JFT-Basic';

  @override
  String scoreOf(Object gain, Object max) {
    return 'of $max · up $gain from last time';
  }

  @override
  String pointsToPass(Object points) {
    return 'Only $points points to pass.';
  }

  @override
  String readyIn(Object weeks) {
    return 'At this pace: ready in $weeks weeks.';
  }

  @override
  String get weakest => 'weakest';

  @override
  String fixSection(Object minutes, Object section) {
    return 'Fix $section · $minutes min';
  }

  @override
  String get passTitle => 'My boarding pass';

  @override
  String passenger(Object name) {
    return 'Passenger · $name';
  }

  @override
  String get visaLabel => 'Visa';

  @override
  String get visaCare => '特定技能 · Care';

  @override
  String get examLabel => 'Exam';

  @override
  String get examDate => '6 Dec';

  @override
  String get readyLabel => 'Ready';

  @override
  String checkedBy(Object count, Object teacher) {
    return '$count stamps checked by $teacher sensei';
  }

  @override
  String stampsToGo(Object count) {
    return '$count stamps to go';
  }

  @override
  String get secondEyeBody => 'Fill the pass and Daru gets his second eye.';

  @override
  String get myClass => 'My class';

  @override
  String leagueEyebrow(Object name) {
    return 'Class $name · weekly league';
  }

  @override
  String get leagueTitle => 'Top 3 get a gold stamp';

  @override
  String leagueEnds(Object days) {
    return 'Ends Sunday · $days days left';
  }

  @override
  String get you => 'You';

  @override
  String teacherName(Object teacher) {
    return '$teacher sensei';
  }

  @override
  String homeworkLeft(Object count) {
    return 'Homework · $count left';
  }

  @override
  String attendance(Object percent) {
    return 'Attendance $percent';
  }

  @override
  String get learnerName => 'Learner';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get changePath => 'Change my path';

  @override
  String dailyGoalLine(Object minutes) {
    return 'Daily goal · $minutes min';
  }

  @override
  String reminderLine(Object time) {
    return 'Reminder · $time';
  }

  @override
  String get statLessons => 'Lessons';

  @override
  String get statWords => 'Words known';

  @override
  String get statBestMock => 'Best mock';

  @override
  String get statStreak => 'Streak';

  @override
  String get reviewEyebrow => 'Review';

  @override
  String get reviewTitle => 'Review';

  @override
  String cardsLeft(Object count) {
    return '$count cards left today';
  }

  @override
  String get reviewNew => 'New';

  @override
  String get reviewDue => 'Due';

  @override
  String get reviewLearned => 'Learned';

  @override
  String get workWordsEyebrow => 'Work words';

  @override
  String get flipCard => 'Flip the card';

  @override
  String get tapToReveal => 'Tap to see the answer';

  @override
  String get showAnswer => 'Show answer';

  @override
  String get gradeAgain => 'Again';

  @override
  String get gradeHard => 'Hard';

  @override
  String get gradeGood => 'Good';

  @override
  String get gradeEasy => 'Easy';

  @override
  String get accountEyebrow => 'ACCOUNT';

  @override
  String get signInTitle => 'Sign in to save your progress';

  @override
  String get signInBody =>
      'Keep your progress when you change phones or join a class.';

  @override
  String get signInGoogle => 'Continue with Google';

  @override
  String get signInFacebook => 'Continue with Facebook';

  @override
  String get signInApple => 'Continue with Apple';

  @override
  String get signInEmail => 'Continue with email';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(Object email) {
    return 'Signed in as $email';
  }

  @override
  String get signInFailed => 'Sign-in failed. Please try again.';

  @override
  String get signInUnavailable => 'Sign-in isn\'t configured in this build.';
}
