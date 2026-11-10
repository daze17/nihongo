import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mn'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In mn, this message translates to:
  /// **'Nihongo'**
  String get appTitle;

  /// No description provided for @close.
  ///
  /// In mn, this message translates to:
  /// **'Хаах'**
  String get close;

  /// No description provided for @progress.
  ///
  /// In mn, this message translates to:
  /// **'Явц'**
  String get progress;

  /// No description provided for @heartsSemantics.
  ///
  /// In mn, this message translates to:
  /// **'Зүрх {count}'**
  String heartsSemantics(Object count);

  /// No description provided for @streakSemantics.
  ///
  /// In mn, this message translates to:
  /// **'Цуваа {count} өдөр'**
  String streakSemantics(Object count);

  /// No description provided for @gemsSemantics.
  ///
  /// In mn, this message translates to:
  /// **'{count} эрдэнэ'**
  String gemsSemantics(Object count);

  /// No description provided for @mainMenu.
  ///
  /// In mn, this message translates to:
  /// **'Үндсэн цэс'**
  String get mainMenu;

  /// No description provided for @minutes.
  ///
  /// In mn, this message translates to:
  /// **'{count} мин'**
  String minutes(Object count);

  /// No description provided for @days.
  ///
  /// In mn, this message translates to:
  /// **'{count} өдөр'**
  String days(Object count);

  /// No description provided for @continueLabel.
  ///
  /// In mn, this message translates to:
  /// **'Үргэлжлүүлэх'**
  String get continueLabel;

  /// No description provided for @navHome.
  ///
  /// In mn, this message translates to:
  /// **'Нүүр'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In mn, this message translates to:
  /// **'Суралцах'**
  String get navLearn;

  /// No description provided for @navTests.
  ///
  /// In mn, this message translates to:
  /// **'Шалгалт'**
  String get navTests;

  /// No description provided for @navPass.
  ///
  /// In mn, this message translates to:
  /// **'Тасалбар'**
  String get navPass;

  /// No description provided for @navClass.
  ///
  /// In mn, this message translates to:
  /// **'Анги'**
  String get navClass;

  /// No description provided for @navProfile.
  ///
  /// In mn, this message translates to:
  /// **'Профайл'**
  String get navProfile;

  /// No description provided for @wishTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хүслээ хэлээрэй'**
  String get wishTitle;

  /// No description provided for @wishBody.
  ///
  /// In mn, this message translates to:
  /// **'Хаашаа явахаа сонго. Дару эхний нүдээ авна, хоёр дахь нь чамайг Японд хүлээж байна.'**
  String get wishBody;

  /// No description provided for @wishMade.
  ///
  /// In mn, this message translates to:
  /// **'Хүсэл чинь бичигдлээ!'**
  String get wishMade;

  /// No description provided for @wishMadeBody.
  ///
  /// In mn, this message translates to:
  /// **'Тасалбараа тамгаар дүүргэвэл Дару хоёр дахь нүдээ авна.'**
  String get wishMadeBody;

  /// No description provided for @paintEye.
  ///
  /// In mn, this message translates to:
  /// **'Эхний нүдийг будах'**
  String get paintEye;

  /// No description provided for @letsGo.
  ///
  /// In mn, this message translates to:
  /// **'Эхэлцгээе'**
  String get letsGo;

  /// No description provided for @haveClassCode.
  ///
  /// In mn, this message translates to:
  /// **'Надад ангийн код байна'**
  String get haveClassCode;

  /// No description provided for @pathCare.
  ///
  /// In mn, this message translates to:
  /// **'Японд ажиллах · Асаргаа'**
  String get pathCare;

  /// No description provided for @pathCareDesc.
  ///
  /// In mn, this message translates to:
  /// **'特定技能 · JFT-Basic шаардлагатай'**
  String get pathCareDesc;

  /// No description provided for @pathEngineer.
  ///
  /// In mn, this message translates to:
  /// **'Инженерээр ажиллах'**
  String get pathEngineer;

  /// No description provided for @pathEngineerDesc.
  ///
  /// In mn, this message translates to:
  /// **'Диплом + япон хэл'**
  String get pathEngineerDesc;

  /// No description provided for @pathStudent.
  ///
  /// In mn, this message translates to:
  /// **'Японд суралцах'**
  String get pathStudent;

  /// No description provided for @pathStudentDesc.
  ///
  /// In mn, this message translates to:
  /// **'Хэлний сургууль эсвэл их сургууль'**
  String get pathStudentDesc;

  /// No description provided for @hello.
  ///
  /// In mn, this message translates to:
  /// **'Сайн уу, {name}!'**
  String hello(Object name);

  /// No description provided for @flightEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'Япон руу нислэг'**
  String get flightEyebrow;

  /// No description provided for @kmToGo.
  ///
  /// In mn, this message translates to:
  /// **'· {km} км үлдлээ'**
  String kmToGo(Object km);

  /// No description provided for @routeFrom.
  ///
  /// In mn, this message translates to:
  /// **'ULN · Улаанбаатар'**
  String get routeFrom;

  /// No description provided for @routeTo.
  ///
  /// In mn, this message translates to:
  /// **'Токио · NRT'**
  String get routeTo;

  /// No description provided for @flightSemantics.
  ///
  /// In mn, this message translates to:
  /// **'Японд {percent} бэлэн'**
  String flightSemantics(Object percent);

  /// No description provided for @weekDays.
  ///
  /// In mn, this message translates to:
  /// **'Да,Мя,Лх,Пү,Ба,Бя,Ня'**
  String get weekDays;

  /// No description provided for @lessonMeta.
  ///
  /// In mn, this message translates to:
  /// **'{unit} · {minutes} мин · +{xp} XP'**
  String lessonMeta(Object minutes, Object unit, Object xp);

  /// No description provided for @startLesson.
  ///
  /// In mn, this message translates to:
  /// **'Хичээл эхлэх'**
  String get startLesson;

  /// No description provided for @chestTitle.
  ///
  /// In mn, this message translates to:
  /// **'Өдрийн авдар · {done} / {total}'**
  String chestTitle(Object done, Object total);

  /// No description provided for @chestBody.
  ///
  /// In mn, this message translates to:
  /// **'Нэг давталт хийгээд нээ'**
  String get chestBody;

  /// No description provided for @lineTitle.
  ///
  /// In mn, this message translates to:
  /// **'Япон руу шугам'**
  String get lineTitle;

  /// No description provided for @lineBody.
  ///
  /// In mn, this message translates to:
  /// **'Буудал бүр нэг тамга. Эцсийн буудал: визийн түвшин.'**
  String get lineBody;

  /// No description provided for @nowTag.
  ///
  /// In mn, this message translates to:
  /// **'Одоо'**
  String get nowTag;

  /// No description provided for @newKanaEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'Шинэ үсэг'**
  String get newKanaEyebrow;

  /// No description provided for @choiceQuestion.
  ///
  /// In mn, this message translates to:
  /// **'Энэ үсгийг юу гэж уншдаг вэ?'**
  String get choiceQuestion;

  /// No description provided for @playSound.
  ///
  /// In mn, this message translates to:
  /// **'Дуудлагыг сонсох'**
  String get playSound;

  /// No description provided for @check.
  ///
  /// In mn, this message translates to:
  /// **'Шалгах'**
  String get check;

  /// No description provided for @cheer.
  ///
  /// In mn, this message translates to:
  /// **'すごい!'**
  String get cheer;

  /// No description provided for @correctTitle.
  ///
  /// In mn, this message translates to:
  /// **'Зөв! {kana} = {romaji}'**
  String correctTitle(Object kana, Object romaji);

  /// No description provided for @wrongTitle.
  ///
  /// In mn, this message translates to:
  /// **'Буруу. Зөв хариулт: {romaji}'**
  String wrongTitle(Object romaji);

  /// No description provided for @wrongHint.
  ///
  /// In mn, this message translates to:
  /// **'Энэ үсэг дараа дахин гарна.'**
  String get wrongHint;

  /// No description provided for @gotIt.
  ///
  /// In mn, this message translates to:
  /// **'Ойлголоо'**
  String get gotIt;

  /// No description provided for @combo.
  ///
  /// In mn, this message translates to:
  /// **'{count} дараалан зөв · ×2 XP'**
  String combo(Object count);

  /// No description provided for @traceEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'Бичих'**
  String get traceEyebrow;

  /// No description provided for @traceTitle.
  ///
  /// In mn, this message translates to:
  /// **'{kana} үсгийг зур'**
  String traceTitle(Object kana);

  /// No description provided for @traceHint.
  ///
  /// In mn, this message translates to:
  /// **'Зураас {current} / {total} · улаан цэгээс эхэл'**
  String traceHint(Object current, Object total);

  /// No description provided for @traceDone.
  ///
  /// In mn, this message translates to:
  /// **'Бүх зураасаа зурлаа.'**
  String get traceDone;

  /// No description provided for @traceArea.
  ///
  /// In mn, this message translates to:
  /// **'{kana} үсэг зурах талбар'**
  String traceArea(Object kana);

  /// No description provided for @undo.
  ///
  /// In mn, this message translates to:
  /// **'Буцаах'**
  String get undo;

  /// No description provided for @clear.
  ///
  /// In mn, this message translates to:
  /// **'Арилгах'**
  String get clear;

  /// No description provided for @finishStrokes.
  ///
  /// In mn, this message translates to:
  /// **'Зураасаа дуусга'**
  String get finishStrokes;

  /// No description provided for @traceContinue.
  ///
  /// In mn, this message translates to:
  /// **'Гайхалтай! Үргэлжлүүлэх'**
  String get traceContinue;

  /// No description provided for @stampCollected.
  ///
  /// In mn, this message translates to:
  /// **'Тамга авлаа!'**
  String get stampCollected;

  /// No description provided for @gainStreak.
  ///
  /// In mn, this message translates to:
  /// **'Цуваа'**
  String get gainStreak;

  /// No description provided for @gainFlight.
  ///
  /// In mn, this message translates to:
  /// **'Нислэг'**
  String get gainFlight;

  /// No description provided for @kmGain.
  ///
  /// In mn, this message translates to:
  /// **'+{km} км'**
  String kmGain(Object km);

  /// No description provided for @accuracyTime.
  ///
  /// In mn, this message translates to:
  /// **'{percent} зөв · {time}'**
  String accuracyTime(Object percent, Object time);

  /// No description provided for @rewardLeague.
  ///
  /// In mn, this message translates to:
  /// **'Ангийн лигт {name} чамаас хоцорлоо!'**
  String rewardLeague(Object name);

  /// No description provided for @keepGoing.
  ///
  /// In mn, this message translates to:
  /// **'Цааш явах'**
  String get keepGoing;

  /// No description provided for @testsTitle.
  ///
  /// In mn, this message translates to:
  /// **'Туршилтын JFT-Basic'**
  String get testsTitle;

  /// No description provided for @scoreOf.
  ///
  /// In mn, this message translates to:
  /// **'{max}-аас · өмнөхөөс +{gain}'**
  String scoreOf(Object gain, Object max);

  /// No description provided for @pointsToPass.
  ///
  /// In mn, this message translates to:
  /// **'Тэнцэхэд ердөө {points} оноо дутуу.'**
  String pointsToPass(Object points);

  /// No description provided for @readyIn.
  ///
  /// In mn, this message translates to:
  /// **'Энэ хурдаар {weeks} долоо хоногт бэлэн.'**
  String readyIn(Object weeks);

  /// No description provided for @weakest.
  ///
  /// In mn, this message translates to:
  /// **'сул тал'**
  String get weakest;

  /// No description provided for @fixSection.
  ///
  /// In mn, this message translates to:
  /// **'{section} сайжруулах · {minutes} мин'**
  String fixSection(Object minutes, Object section);

  /// No description provided for @passTitle.
  ///
  /// In mn, this message translates to:
  /// **'Миний тасалбар'**
  String get passTitle;

  /// No description provided for @passenger.
  ///
  /// In mn, this message translates to:
  /// **'Зорчигч · {name}'**
  String passenger(Object name);

  /// No description provided for @visaLabel.
  ///
  /// In mn, this message translates to:
  /// **'Виз'**
  String get visaLabel;

  /// No description provided for @visaCare.
  ///
  /// In mn, this message translates to:
  /// **'特定技能 · Асаргаа'**
  String get visaCare;

  /// No description provided for @examLabel.
  ///
  /// In mn, this message translates to:
  /// **'Шалгалт'**
  String get examLabel;

  /// No description provided for @examDate.
  ///
  /// In mn, this message translates to:
  /// **'12/06'**
  String get examDate;

  /// No description provided for @readyLabel.
  ///
  /// In mn, this message translates to:
  /// **'Бэлэн'**
  String get readyLabel;

  /// No description provided for @checkedBy.
  ///
  /// In mn, this message translates to:
  /// **'{count} тамгыг {teacher} багш баталгаажуулсан'**
  String checkedBy(Object count, Object teacher);

  /// No description provided for @stampsToGo.
  ///
  /// In mn, this message translates to:
  /// **'{count} тамга үлдлээ'**
  String stampsToGo(Object count);

  /// No description provided for @secondEyeBody.
  ///
  /// In mn, this message translates to:
  /// **'Тасалбараа дүүргэвэл Дару хоёр дахь нүдээ авна.'**
  String get secondEyeBody;

  /// No description provided for @myClass.
  ///
  /// In mn, this message translates to:
  /// **'Миний анги'**
  String get myClass;

  /// No description provided for @leagueEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'{name} анги · долоо хоногийн лиг'**
  String leagueEyebrow(Object name);

  /// No description provided for @leagueTitle.
  ///
  /// In mn, this message translates to:
  /// **'Эхний 3 нь алтан тамга авна'**
  String get leagueTitle;

  /// No description provided for @leagueEnds.
  ///
  /// In mn, this message translates to:
  /// **'Ням гарагт дуусна · {days} өдөр үлдлээ'**
  String leagueEnds(Object days);

  /// No description provided for @you.
  ///
  /// In mn, this message translates to:
  /// **'Та'**
  String get you;

  /// No description provided for @teacherName.
  ///
  /// In mn, this message translates to:
  /// **'{teacher} багш'**
  String teacherName(Object teacher);

  /// No description provided for @homeworkLeft.
  ///
  /// In mn, this message translates to:
  /// **'Даалгавар · {count} үлдсэн'**
  String homeworkLeft(Object count);

  /// No description provided for @attendance.
  ///
  /// In mn, this message translates to:
  /// **'Ирц {percent}'**
  String attendance(Object percent);

  /// No description provided for @learnerName.
  ///
  /// In mn, this message translates to:
  /// **'Сурагч'**
  String get learnerName;

  /// No description provided for @language.
  ///
  /// In mn, this message translates to:
  /// **'Хэл'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In mn, this message translates to:
  /// **'Тохиргоо'**
  String get settings;

  /// No description provided for @changePath.
  ///
  /// In mn, this message translates to:
  /// **'Замаа өөрчлөх'**
  String get changePath;

  /// No description provided for @dailyGoalLine.
  ///
  /// In mn, this message translates to:
  /// **'Өдрийн зорилт · {minutes} мин'**
  String dailyGoalLine(Object minutes);

  /// No description provided for @reminderLine.
  ///
  /// In mn, this message translates to:
  /// **'Сануулга · {time}'**
  String reminderLine(Object time);

  /// No description provided for @statLessons.
  ///
  /// In mn, this message translates to:
  /// **'Хичээл'**
  String get statLessons;

  /// No description provided for @statWords.
  ///
  /// In mn, this message translates to:
  /// **'Мэдэх үг'**
  String get statWords;

  /// No description provided for @statBestMock.
  ///
  /// In mn, this message translates to:
  /// **'Шилдэг оноо'**
  String get statBestMock;

  /// No description provided for @statStreak.
  ///
  /// In mn, this message translates to:
  /// **'Цуваа'**
  String get statStreak;

  /// No description provided for @reviewEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'Давталт'**
  String get reviewEyebrow;

  /// No description provided for @reviewTitle.
  ///
  /// In mn, this message translates to:
  /// **'Давтах'**
  String get reviewTitle;

  /// No description provided for @cardsLeft.
  ///
  /// In mn, this message translates to:
  /// **'Өнөөдөр {count} карт үлдлээ'**
  String cardsLeft(Object count);

  /// No description provided for @reviewNew.
  ///
  /// In mn, this message translates to:
  /// **'Шинэ'**
  String get reviewNew;

  /// No description provided for @reviewDue.
  ///
  /// In mn, this message translates to:
  /// **'Давтах'**
  String get reviewDue;

  /// No description provided for @reviewLearned.
  ///
  /// In mn, this message translates to:
  /// **'Цээжилсэн'**
  String get reviewLearned;

  /// No description provided for @workWordsEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'Ажлын үгс'**
  String get workWordsEyebrow;

  /// No description provided for @flipCard.
  ///
  /// In mn, this message translates to:
  /// **'Картыг эргүүлэх'**
  String get flipCard;

  /// No description provided for @tapToReveal.
  ///
  /// In mn, this message translates to:
  /// **'Дарж хариуг хар'**
  String get tapToReveal;

  /// No description provided for @showAnswer.
  ///
  /// In mn, this message translates to:
  /// **'Хариуг харах'**
  String get showAnswer;

  /// No description provided for @gradeAgain.
  ///
  /// In mn, this message translates to:
  /// **'Мартсан'**
  String get gradeAgain;

  /// No description provided for @gradeHard.
  ///
  /// In mn, this message translates to:
  /// **'Хэцүү'**
  String get gradeHard;

  /// No description provided for @gradeGood.
  ///
  /// In mn, this message translates to:
  /// **'Сайн'**
  String get gradeGood;

  /// No description provided for @gradeEasy.
  ///
  /// In mn, this message translates to:
  /// **'Амархан'**
  String get gradeEasy;

  /// No description provided for @accountEyebrow.
  ///
  /// In mn, this message translates to:
  /// **'Бүртгэл'**
  String get accountEyebrow;

  /// No description provided for @signInTitle.
  ///
  /// In mn, this message translates to:
  /// **'Нэвтэрч ахицаа хадгал'**
  String get signInTitle;

  /// No description provided for @signInBody.
  ///
  /// In mn, this message translates to:
  /// **'Утас солих эсвэл ангидаа нэгдэхэд ахиц тань хадгалагдана.'**
  String get signInBody;

  /// No description provided for @signInGoogle.
  ///
  /// In mn, this message translates to:
  /// **'Google-ээр нэвтрэх'**
  String get signInGoogle;

  /// No description provided for @signInFacebook.
  ///
  /// In mn, this message translates to:
  /// **'Facebook-ээр нэвтрэх'**
  String get signInFacebook;

  /// No description provided for @signInApple.
  ///
  /// In mn, this message translates to:
  /// **'Apple-ээр нэвтрэх'**
  String get signInApple;

  /// No description provided for @signInEmail.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйлээр нэвтрэх'**
  String get signInEmail;

  /// No description provided for @signOut.
  ///
  /// In mn, this message translates to:
  /// **'Гарах'**
  String get signOut;

  /// No description provided for @signedInAs.
  ///
  /// In mn, this message translates to:
  /// **'Нэвтэрсэн: {email}'**
  String signedInAs(Object email);

  /// No description provided for @signInFailed.
  ///
  /// In mn, this message translates to:
  /// **'Нэвтэрч чадсангүй. Дахин оролдоно уу.'**
  String get signInFailed;

  /// No description provided for @signInUnavailable.
  ///
  /// In mn, this message translates to:
  /// **'Энэ хувилбарт нэвтрэх тохиргоо хийгдээгүй байна.'**
  String get signInUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mn':
      return AppLocalizationsMn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
