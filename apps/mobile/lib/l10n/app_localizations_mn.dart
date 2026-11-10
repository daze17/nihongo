// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class AppLocalizationsMn extends AppLocalizations {
  AppLocalizationsMn([String locale = 'mn']) : super(locale);

  @override
  String get appTitle => 'Nihongo';

  @override
  String get close => 'Хаах';

  @override
  String get progress => 'Явц';

  @override
  String heartsSemantics(Object count) {
    return 'Зүрх $count';
  }

  @override
  String streakSemantics(Object count) {
    return 'Цуваа $count өдөр';
  }

  @override
  String gemsSemantics(Object count) {
    return '$count эрдэнэ';
  }

  @override
  String get mainMenu => 'Үндсэн цэс';

  @override
  String minutes(Object count) {
    return '$count мин';
  }

  @override
  String days(Object count) {
    return '$count өдөр';
  }

  @override
  String get continueLabel => 'Үргэлжлүүлэх';

  @override
  String get navHome => 'Нүүр';

  @override
  String get navLearn => 'Суралцах';

  @override
  String get navTests => 'Шалгалт';

  @override
  String get navPass => 'Тасалбар';

  @override
  String get navClass => 'Анги';

  @override
  String get navProfile => 'Профайл';

  @override
  String get wishTitle => 'Хүслээ хэлээрэй';

  @override
  String get wishBody =>
      'Хаашаа явахаа сонго. Дару эхний нүдээ авна, хоёр дахь нь чамайг Японд хүлээж байна.';

  @override
  String get wishMade => 'Хүсэл чинь бичигдлээ!';

  @override
  String get wishMadeBody =>
      'Тасалбараа тамгаар дүүргэвэл Дару хоёр дахь нүдээ авна.';

  @override
  String get paintEye => 'Эхний нүдийг будах';

  @override
  String get letsGo => 'Эхэлцгээе';

  @override
  String get haveClassCode => 'Надад ангийн код байна';

  @override
  String get pathCare => 'Японд ажиллах · Асаргаа';

  @override
  String get pathCareDesc => '特定技能 · JFT-Basic шаардлагатай';

  @override
  String get pathEngineer => 'Инженерээр ажиллах';

  @override
  String get pathEngineerDesc => 'Диплом + япон хэл';

  @override
  String get pathStudent => 'Японд суралцах';

  @override
  String get pathStudentDesc => 'Хэлний сургууль эсвэл их сургууль';

  @override
  String hello(Object name) {
    return 'Сайн уу, $name!';
  }

  @override
  String get flightEyebrow => 'Япон руу нислэг';

  @override
  String kmToGo(Object km) {
    return '· $km км үлдлээ';
  }

  @override
  String get routeFrom => 'ULN · Улаанбаатар';

  @override
  String get routeTo => 'Токио · NRT';

  @override
  String flightSemantics(Object percent) {
    return 'Японд $percent бэлэн';
  }

  @override
  String get weekDays => 'Да,Мя,Лх,Пү,Ба,Бя,Ня';

  @override
  String lessonMeta(Object minutes, Object unit, Object xp) {
    return '$unit · $minutes мин · +$xp XP';
  }

  @override
  String get startLesson => 'Хичээл эхлэх';

  @override
  String chestTitle(Object done, Object total) {
    return 'Өдрийн авдар · $done / $total';
  }

  @override
  String get chestBody => 'Нэг давталт хийгээд нээ';

  @override
  String get lineTitle => 'Япон руу шугам';

  @override
  String get lineBody => 'Буудал бүр нэг тамга. Эцсийн буудал: визийн түвшин.';

  @override
  String get nowTag => 'Одоо';

  @override
  String get newKanaEyebrow => 'Шинэ үсэг';

  @override
  String get choiceQuestion => 'Энэ үсгийг юу гэж уншдаг вэ?';

  @override
  String get playSound => 'Дуудлагыг сонсох';

  @override
  String get check => 'Шалгах';

  @override
  String get cheer => 'すごい!';

  @override
  String correctTitle(Object kana, Object romaji) {
    return 'Зөв! $kana = $romaji';
  }

  @override
  String wrongTitle(Object romaji) {
    return 'Буруу. Зөв хариулт: $romaji';
  }

  @override
  String get wrongHint => 'Энэ үсэг дараа дахин гарна.';

  @override
  String get gotIt => 'Ойлголоо';

  @override
  String combo(Object count) {
    return '$count дараалан зөв · ×2 XP';
  }

  @override
  String get traceEyebrow => 'Бичих';

  @override
  String traceTitle(Object kana) {
    return '$kana үсгийг зур';
  }

  @override
  String traceHint(Object current, Object total) {
    return 'Зураас $current / $total · улаан цэгээс эхэл';
  }

  @override
  String get traceDone => 'Бүх зураасаа зурлаа.';

  @override
  String traceArea(Object kana) {
    return '$kana үсэг зурах талбар';
  }

  @override
  String get undo => 'Буцаах';

  @override
  String get clear => 'Арилгах';

  @override
  String get finishStrokes => 'Зураасаа дуусга';

  @override
  String get traceContinue => 'Гайхалтай! Үргэлжлүүлэх';

  @override
  String get stampCollected => 'Тамга авлаа!';

  @override
  String get gainStreak => 'Цуваа';

  @override
  String get gainFlight => 'Нислэг';

  @override
  String kmGain(Object km) {
    return '+$km км';
  }

  @override
  String accuracyTime(Object percent, Object time) {
    return '$percent зөв · $time';
  }

  @override
  String rewardLeague(Object name) {
    return 'Ангийн лигт $name чамаас хоцорлоо!';
  }

  @override
  String get keepGoing => 'Цааш явах';

  @override
  String get testsTitle => 'Туршилтын JFT-Basic';

  @override
  String scoreOf(Object gain, Object max) {
    return '$max-аас · өмнөхөөс +$gain';
  }

  @override
  String pointsToPass(Object points) {
    return 'Тэнцэхэд ердөө $points оноо дутуу.';
  }

  @override
  String readyIn(Object weeks) {
    return 'Энэ хурдаар $weeks долоо хоногт бэлэн.';
  }

  @override
  String get weakest => 'сул тал';

  @override
  String fixSection(Object minutes, Object section) {
    return '$section сайжруулах · $minutes мин';
  }

  @override
  String get passTitle => 'Миний тасалбар';

  @override
  String passenger(Object name) {
    return 'Зорчигч · $name';
  }

  @override
  String get visaLabel => 'Виз';

  @override
  String get visaCare => '特定技能 · Асаргаа';

  @override
  String get examLabel => 'Шалгалт';

  @override
  String get examDate => '12/06';

  @override
  String get readyLabel => 'Бэлэн';

  @override
  String checkedBy(Object count, Object teacher) {
    return '$count тамгыг $teacher багш баталгаажуулсан';
  }

  @override
  String stampsToGo(Object count) {
    return '$count тамга үлдлээ';
  }

  @override
  String get secondEyeBody => 'Тасалбараа дүүргэвэл Дару хоёр дахь нүдээ авна.';

  @override
  String get myClass => 'Миний анги';

  @override
  String leagueEyebrow(Object name) {
    return '$name анги · долоо хоногийн лиг';
  }

  @override
  String get leagueTitle => 'Эхний 3 нь алтан тамга авна';

  @override
  String leagueEnds(Object days) {
    return 'Ням гарагт дуусна · $days өдөр үлдлээ';
  }

  @override
  String get you => 'Та';

  @override
  String teacherName(Object teacher) {
    return '$teacher багш';
  }

  @override
  String homeworkLeft(Object count) {
    return 'Даалгавар · $count үлдсэн';
  }

  @override
  String attendance(Object percent) {
    return 'Ирц $percent';
  }

  @override
  String get learnerName => 'Сурагч';

  @override
  String get language => 'Хэл';

  @override
  String get settings => 'Тохиргоо';

  @override
  String get changePath => 'Замаа өөрчлөх';

  @override
  String dailyGoalLine(Object minutes) {
    return 'Өдрийн зорилт · $minutes мин';
  }

  @override
  String reminderLine(Object time) {
    return 'Сануулга · $time';
  }

  @override
  String get statLessons => 'Хичээл';

  @override
  String get statWords => 'Мэдэх үг';

  @override
  String get statBestMock => 'Шилдэг оноо';

  @override
  String get statStreak => 'Цуваа';

  @override
  String get reviewEyebrow => 'Давталт';

  @override
  String get reviewTitle => 'Давтах';

  @override
  String cardsLeft(Object count) {
    return 'Өнөөдөр $count карт үлдлээ';
  }

  @override
  String get reviewNew => 'Шинэ';

  @override
  String get reviewDue => 'Давтах';

  @override
  String get reviewLearned => 'Цээжилсэн';

  @override
  String get workWordsEyebrow => 'Ажлын үгс';

  @override
  String get flipCard => 'Картыг эргүүлэх';

  @override
  String get tapToReveal => 'Дарж хариуг хар';

  @override
  String get showAnswer => 'Хариуг харах';

  @override
  String get gradeAgain => 'Мартсан';

  @override
  String get gradeHard => 'Хэцүү';

  @override
  String get gradeGood => 'Сайн';

  @override
  String get gradeEasy => 'Амархан';

  @override
  String get accountEyebrow => 'Бүртгэл';

  @override
  String get signInTitle => 'Нэвтэрч ахицаа хадгал';

  @override
  String get signInBody =>
      'Утас солих эсвэл ангидаа нэгдэхэд ахиц тань хадгалагдана.';

  @override
  String get signInGoogle => 'Google-ээр нэвтрэх';

  @override
  String get signInFacebook => 'Facebook-ээр нэвтрэх';

  @override
  String get signInApple => 'Apple-ээр нэвтрэх';

  @override
  String get signInEmail => 'И-мэйлээр нэвтрэх';

  @override
  String get signOut => 'Гарах';

  @override
  String signedInAs(Object email) {
    return 'Нэвтэрсэн: $email';
  }

  @override
  String get signInFailed => 'Нэвтэрч чадсангүй. Дахин оролдоно уу.';

  @override
  String get signInUnavailable =>
      'Энэ хувилбарт нэвтрэх тохиргоо хийгдээгүй байна.';
}
