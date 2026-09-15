import 'package:flutter/widgets.dart';

import '../data/fortunes.dart';

/// 현재 앱 언어 코드('ko' | 'en' | 'ja' | 'zh').
///
/// 위젯 트리 안에서는 [of] 를, BuildContext 가 없는 곳(알림 예약 등)에서는
/// [AppLang.current] 를 쓴다. 후자는 MaterialApp 의 localeResolutionCallback 에서 갱신된다.
class AppLang {
  AppLang._();

  static String current = 'en';

  /// 시스템 로케일 → 지원 언어. 미지원이면 영어.
  static Locale resolve(Locale? device, Iterable<Locale> supported) {
    final code = device?.languageCode ?? 'en';
    current = FortuneData.supportedLangs.contains(code) ? code : 'en';
    return Locale(current);
  }

  static String of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return FortuneData.supportedLangs.contains(code) ? code : 'en';
  }
}
