import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/fortunes.dart';
import '../data/quotes.dart';

/// 하루치 운세 결과. 텍스트는 [T] 로 들고 있다가 화면에서 언어를 골라 쓴다.
class DailyFortune {
  final DateTime date;
  final int zodiacIndex;
  final Map<Category, FortuneLine> byCategory;
  final int luckyNumber;
  final T luckyColor;
  final T luckyItem;
  final T luckyDirection;
  final Quote quote;

  const DailyFortune({
    required this.date,
    required this.zodiacIndex,
    required this.byCategory,
    required this.luckyNumber,
    required this.luckyColor,
    required this.luckyItem,
    required this.luckyDirection,
    required this.quote,
  });

  T get zodiacAnimal => FortuneData.zodiacAnimals[zodiacIndex];
  String get zodiacEmoji => FortuneData.zodiacEmoji[zodiacIndex];

  FortuneLine get overall => byCategory[Category.overall]!;

  /// 총운 점수 (별 개수).
  int get overallScore => overall.score;

  /// 카테고리 평균으로 0~100 점수 산출.
  int get percent {
    final total = byCategory.values.fold<int>(0, (s, l) => s + l.score);
    final max = byCategory.length * 5;
    return (total / max * 100).round();
  }
}

/// 사용자 프로필 저장 + 날짜·생년월일 기반 결정적 운세 생성.
///
/// 같은 날, 같은 생년월일이면 항상 같은 결과가 나온다(앱을 껐다 켜도 동일).
class FortuneService {
  static const _kBirthYear = 'birth_year';
  static const _kBirthMonth = 'birth_month';
  static const _kBirthDay = 'birth_day';

  final SharedPreferences _prefs;
  FortuneService(this._prefs);

  static Future<FortuneService> create() async =>
      FortuneService(await SharedPreferences.getInstance());

  // ------------------------------------------------------------- 프로필

  DateTime? get birthDate {
    final y = _prefs.getInt(_kBirthYear);
    final m = _prefs.getInt(_kBirthMonth);
    final d = _prefs.getInt(_kBirthDay);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  Future<void> setBirthDate(DateTime date) async {
    await _prefs.setInt(_kBirthYear, date.year);
    await _prefs.setInt(_kBirthMonth, date.month);
    await _prefs.setInt(_kBirthDay, date.day);
  }

  // ------------------------------------------------------------- 생성

  /// 프로세스가 바뀌어도 같은 값을 내는 결정적 해시.
  /// (Dart 의 Object.hash 는 실행마다 시드가 달라 하루 동안 결과가 흔들린다.)
  static int _stableHash(List<int> parts) =>
      parts.fold(17, (h, v) => (h * 31 + v) & 0x7fffffff);

  DailyFortune fortuneFor(DateTime date) {
    final birth = birthDate ?? DateTime(1990, 1, 1);
    final seed = _stableHash([
      date.year, date.month, date.day,
      birth.year, birth.month, birth.day,
    ]);
    final rng = Random(seed);

    final byCategory = <Category, FortuneLine>{
      for (final c in Category.values) c: _pick(rng, FortuneData.lines[c]!),
    };

    return DailyFortune(
      date: date,
      zodiacIndex: FortuneData.zodiacIndex(birth.year),
      byCategory: byCategory,
      luckyNumber: rng.nextInt(45) + 1,
      luckyColor: _pick(rng, FortuneData.luckyColors),
      luckyItem: _pick(rng, FortuneData.luckyItems),
      luckyDirection: _pick(rng, FortuneData.luckyDirections),
      // 명언은 생년월일과 무관하게 날짜로만 결정 (모든 사용자가 같은 명언).
      quote: quotes[_stableHash([date.year, date.month, date.day]) % quotes.length],
    );
  }

  T _pick<T>(Random rng, List<T> list) => list[rng.nextInt(list.length)];
}
