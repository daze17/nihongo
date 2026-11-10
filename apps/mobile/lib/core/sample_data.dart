// Placeholder content until the content pipeline (Phase 3) and Drift
// (Phase 2, local DB) replace it. Keep shapes close to `@repo/schema`.

/// Content text in both app languages.
class Localized {
  const new(this.mn, this.en);

  final String mn;
  final String en;

  String of(String languageCode) => languageCode == 'en' ? en : mn;
}

class Kana {
  const new(this.char, this.romaji);

  final String char;
  final String romaji;
}

const hiraganaRowA = [
  Kana('あ', 'a'),
  Kana('い', 'i'),
  Kana('う', 'u'),
  Kana('え', 'e'),
  Kana('お', 'o'),
];

class LearnerStats {
  const new({
    required this.streakDays,
    required this.gems,
    required this.week,
    required this.lessonsDone,
    required this.wordsKnown,
  });

  final int streakDays;
  final int gems;

  /// Monday..Sunday this week: did the student reach the daily goal.
  final List<bool> week;
  final int lessonsDone;
  final int wordsKnown;
}

const sampleStats = LearnerStats(
  streakDays: 12,
  gems: 340,
  week: [true, true, true, true, true, false, false],
  lessonsDone: 48,
  wordsKnown: 312,
);

/// Readiness drawn as a flight from Ulaanbaatar to Tokyo.
class Journey {
  const new({
    required this.readiness,
    required this.totalKm,
    required this.kmPerLesson,
  });

  /// 0..1, weighted over the path's requirements.
  final double readiness;
  final int totalKm;
  final int kmPerLesson;

  int get kmLeft => (totalKm * (1 - readiness)).round();
}

// ULN → NRT is about 3,000 km; the numbers only need to feel real.
const sampleJourney = Journey(readiness: 0.45, totalKm: 3000, kmPerLesson: 40);

class TodayLesson {
  const new({
    required this.id,
    required this.glyph,
    required this.title,
    required this.unit,
    required this.minutes,
    required this.xp,
  });

  final String id;
  final String glyph;
  final Localized title;
  final String unit;
  final int minutes;
  final int xp;
}

const sampleToday = TodayLesson(
  id: 'hira-a',
  glyph: 'て',
  title: Localized('Тэ-хэлбэрээр гуйх', 'Te-form requests'),
  unit: 'N5 · 3-2',
  minutes: 5,
  xp: 15,
);

/// Daily chest opens after three tasks.
const ({int done, int total}) sampleChest = (done: 2, total: 3);

enum StationState { done, now, locked, goal }

class Station {
  const new({
    required this.glyph,
    required this.title,
    required this.subtitle,
    required this.state,
    this.lessonsDone = 0,
    this.lessonsTotal = 0,
  });

  final String glyph;
  final Localized title;
  final Localized subtitle;
  final StationState state;
  final int lessonsDone;
  final int lessonsTotal;
}

const courseProgress = 0.34;

const sampleLine = [
  Station(
    glyph: 'あ',
    title: Localized('Хирагана', 'Hiragana'),
    subtitle: Localized('46 тамга ✓', '46 stamps ✓'),
    state: StationState.done,
  ),
  Station(
    glyph: 'ア',
    title: Localized('Катакана', 'Katakana'),
    subtitle: Localized('46 тамга ✓', '46 stamps ✓'),
    state: StationState.done,
  ),
  Station(
    glyph: 'です',
    title: Localized('N5 · 1–2-р бүлэг', 'N5 · Units 1–2'),
    subtitle: Localized('Би, гэр бүл, тоо', 'Me, family, numbers'),
    state: StationState.done,
  ),
  Station(
    glyph: 'て',
    title: Localized('N5 · 3-р бүлэг', 'N5 · Unit 3'),
    subtitle: Localized('Гуйх, хүсэлт тавих', 'Asking and requesting'),
    state: StationState.now,
    lessonsDone: 2,
    lessonsTotal: 5,
  ),
  Station(
    glyph: '職',
    title: Localized('N5 · 4-р бүлэг', 'N5 · Unit 4'),
    subtitle: Localized('Ажлын байранд', 'At the workplace'),
    state: StationState.locked,
  ),
  Station(
    glyph: '介',
    title: Localized('Асаргааны үгс', 'Care words'),
    subtitle: Localized('Бие, хоол, аюулгүй байдал', 'Body, meals, safety'),
    state: StationState.locked,
  ),
  Station(
    glyph: 'N4',
    title: Localized('Визийн түвшин', 'Visa level'),
    subtitle: Localized(
      'JFT-Basic A2 · эцсийн буудал',
      'JFT-Basic A2 · last stop',
    ),
    state: StationState.goal,
  ),
];

class TestSection {
  const new(this.name, this.score);

  final Localized name;

  /// 0..1
  final double score;
}

class MockResult {
  const new({
    required this.score,
    required this.max,
    required this.passLine,
    required this.gain,
    required this.attempt,
    required this.weeksToReady,
    required this.sections,
  });

  final int score;
  final int max;
  final int passLine;
  final int gain;
  final int attempt;
  final int weeksToReady;
  final List<TestSection> sections;

  int get toPass => passLine - score;
  TestSection get weakest =>
      sections.reduce((a, b) => a.score <= b.score ? a : b);
}

const sampleMock = MockResult(
  score: 182,
  max: 250,
  passLine: 200,
  gain: 24,
  attempt: 4,
  weeksToReady: 3,
  sections: [
    TestSection(Localized('Үсэг, үгсийн сан', 'Script & vocab'), 0.82),
    TestSection(Localized('Яриа, хэллэг', 'Conversation'), 0.76),
    TestSection(Localized('Сонсох', 'Listening'), 0.58),
    TestSection(Localized('Унших', 'Reading'), 0.71),
  ],
);

enum RequirementStatus { done, partial, todo }

class Requirement {
  const new(
    this.glyph,
    this.label,
    this.status, {
    this.progress = 0,
    this.checkedByTeacher = false,
  });

  final String glyph;
  final Localized label;
  final RequirementStatus status;
  final double progress;
  final bool checkedByTeacher;
}

/// Placeholder list until GTN Mongolia's training team confirms the real one.
const sampleRequirements = [
  Requirement(
    '旅',
    Localized('Гадаад паспорт', 'Passport'),
    RequirementStatus.done,
    checkedByTeacher: true,
  ),
  Requirement('写', Localized('Зураг', 'Photos'), RequirementStatus.done),
  Requirement(
    '証',
    Localized('Дипломын хуулбар', 'Diploma'),
    RequirementStatus.done,
    checkedByTeacher: true,
  ),
  Requirement(
    '語',
    Localized('JFT-Basic 182/200', 'JFT-Basic 182/200'),
    RequirementStatus.partial,
    progress: 0.72,
  ),
  Requirement(
    '技',
    Localized('Асаргааны ур чадвар', 'Care skills test'),
    RequirementStatus.todo,
  ),
  Requirement(
    '介',
    Localized('Асаргааны япон хэл', 'Care Japanese'),
    RequirementStatus.todo,
  ),
  Requirement(
    '健',
    Localized('Эрүүл мэндийн үзлэг', 'Health check'),
    RequirementStatus.todo,
  ),
  Requirement(
    '研',
    Localized('Явахын өмнөх сургалт', 'Pre-departure'),
    RequirementStatus.todo,
  ),
];

class Classmate {
  const new(this.name, this.xp, this.color, {this.isMe = false});

  final String name;
  final int xp;
  final int color;
  final bool isMe;
}

class SchoolClass {
  const new({
    required this.name,
    required this.teacher,
    required this.teacherInitials,
    required this.daysLeft,
    required this.league,
    required this.cheer,
    required this.homeworkLeft,
    required this.attendance,
  });

  final String name;
  final String teacher;
  final String teacherInitials;
  final int daysLeft;
  final List<Classmate> league;
  final Localized cheer;
  final int homeworkLeft;
  final double attendance;

  int get myRank => league.indexWhere((c) => c.isMe) + 1;
  Classmate? get justAhead => myRank > 1 ? league[myRank - 2] : null;
  Classmate? get justBehind => myRank < league.length ? league[myRank] : null;
}

const sampleClass = SchoolClass(
  name: '2B',
  teacher: 'Бат-Эрдэнэ',
  teacherInitials: 'БЭ',
  daysLeft: 2,
  league: [
    Classmate('Сараа', 640, 0xFF7B3CFF),
    Classmate('Билгүүн', 585, 0xFF12C48B),
    Classmate('Та', 560, 0xFF0F1222, isMe: true),
    Classmate('Тэмүүлэн', 540, 0xFFFF3B30),
    Classmate('Оюука', 410, 0xFFE09A00),
  ],
  cheer: Localized(
    'Шалгалтын оноо сайн байна! Сонсголын даалгавраа баасан гаргаас өмнө хийгээрэй. 頑張って!',
    'Great mock score! Listening homework is due Friday. 頑張って!',
  ),
  homeworkLeft: 1,
  attendance: 0.95,
);

class ReviewCard {
  const new({
    required this.word,
    required this.reading,
    required this.romaji,
    required this.meaningMn,
    required this.meaningEn,
  });

  final String word;
  final String reading;
  final String romaji;
  final String meaningMn;
  final String meaningEn;

  String meaning(String languageCode) =>
      languageCode == 'en' ? meaningEn : meaningMn;
}

const sampleCards = [
  ReviewCard(
    word: '安全',
    reading: 'あんぜん',
    romaji: 'anzen',
    meaningMn: 'аюулгүй байдал',
    meaningEn: 'safety',
  ),
  ReviewCard(
    word: '休憩',
    reading: 'きゅうけい',
    romaji: 'kyuukei',
    meaningMn: 'завсарлага',
    meaningEn: 'break',
  ),
  ReviewCard(
    word: '駅',
    reading: 'えき',
    romaji: 'eki',
    meaningMn: 'галт тэрэгний буудал',
    meaningEn: 'train station',
  ),
  ReviewCard(
    word: '病院',
    reading: 'びょういん',
    romaji: 'byouin',
    meaningMn: 'эмнэлэг',
    meaningEn: 'hospital',
  ),
];

sealed class Exercise {
  const new(this.kana);

  final Kana kana;
}

class ChoiceExercise extends Exercise {
  const new(super.kana, this.options);

  /// Romaji options, one of which is `kana.romaji`.
  final List<String> options;
}

class TraceExercise extends Exercise {
  const new(super.kana);
}

List<Exercise> sampleLesson(String lessonId) => [
  ChoiceExercise(hiraganaRowA[0], const ['a', 'i', 'u', 'o']),
  ChoiceExercise(hiraganaRowA[1], const ['e', 'i', 'a', 'u']),
  ChoiceExercise(hiraganaRowA[2], const ['a', 'u', 'o', 'e']),
  TraceExercise(hiraganaRowA[2]),
];
