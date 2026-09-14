// 스토어 스크린샷용: 오늘 기준 운세 지수가 높은 생년월일을 찾는다.
// 실행: dart run tool/find_lucky_birthdate.dart
import 'dart:math';

import '../lib/data/fortunes.dart';

int stableHash(List<int> parts) =>
    parts.fold(17, (h, v) => (h * 31 + v) & 0x7fffffff);

void main() {
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day);
  final results = <(int, DateTime)>[];
  for (var y = 1970; y <= 2005; y++) {
    for (var m = 1; m <= 12; m++) {
      for (var d = 1; d <= 28; d += 3) {
        final rng = Random(stableHash([date.year, date.month, date.day, y, m, d, 0]));
        var total = 0;
        for (final c in FortuneData.categories) {
          final list = FortuneData.lines[c]!;
          total += list[rng.nextInt(list.length)].score;
        }
        results.add((total, DateTime(y, m, d)));
      }
    }
  }
  results.sort((a, b) => b.$1.compareTo(a.$1));
  for (final r in results.take(8)) {
    final pct = (r.$1 / (FortuneData.categories.length * 5) * 100).round();
    print('${r.$2.year}. ${r.$2.month}. ${r.$2.day}.  -> $pct점 (합계 ${r.$1}/25)');
  }
}
