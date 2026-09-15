// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '오늘의 운세';

  @override
  String get onboardingTitle => '시작하기';

  @override
  String get settingsTitle => '설정';

  @override
  String get onboardingHeadline => '생년월일을 알려주세요';

  @override
  String get onboardingBody => '띠와 생일을 기준으로 매일 다른 운세를 보여드려요.\n입력한 정보는 기기에만 저장됩니다.';

  @override
  String get birthDateSection => '생년월일';

  @override
  String get birthDatePickerHelp => '생년월일 선택';

  @override
  String zodiacLabel(String animal) {
    return '$animal띠';
  }

  @override
  String get notificationSection => '아침 알림';

  @override
  String get notificationToggleTitle => '매일 운세 알림';

  @override
  String get notificationToggleSubtitle => '오늘의 운세 지수와 총운을 알려드려요';

  @override
  String get notificationTime => '알림 시간';

  @override
  String get notificationTimeHelp => '알림 시간';

  @override
  String get save => '저장';

  @override
  String get goSeeFortune => '운세 보러 가기';

  @override
  String get shareTooltip => '공유';

  @override
  String get settingsTooltip => '설정';

  @override
  String get fortuneIndex => '운세 지수';

  @override
  String get luckyNumber => '행운의 숫자';

  @override
  String get luckyColor => '행운의 색';

  @override
  String get luckyItem => '행운의 아이템';

  @override
  String get luckyDirection => '행운의 방향';

  @override
  String get seeDetail => '상세 운세 보기';

  @override
  String get todaysQuote => '오늘의 명언';

  @override
  String detailTitle(String zodiac) {
    return '$zodiac 상세 운세';
  }

  @override
  String get detailFooter => '운세는 재미로 보는 콘텐츠예요. 오늘도 좋은 하루 보내세요 🌙';

  @override
  String get shareTitle => '공유하기';

  @override
  String get shareAsImage => '이미지로 공유';

  @override
  String get shareAsText => '텍스트로 공유';

  @override
  String get shareHint => '카카오톡, 인스타그램 스토리, 문자 등으로 보낼 수 있어요';

  @override
  String shareCardTitle(String zodiac) {
    return '$zodiac 오늘의 운세';
  }

  @override
  String get shareAppFooter => '오늘의 운세 앱';

  @override
  String get shareImageCaption => '오늘의 운세 ✨';

  @override
  String shareTextHeader(String date, String zodiac) {
    return '📅 $date 오늘의 운세 ($zodiac)';
  }

  @override
  String shareTextScore(int score) {
    return '운세 지수 $score점';
  }

  @override
  String shareTextLucky(int number, String color, String item) {
    return '🍀 행운의 숫자 $number · $color · $item';
  }

  @override
  String get notifTitle => '🌙 오늘의 운세가 도착했어요';

  @override
  String notifBody(String zodiac, int score, String text) {
    return '$zodiac 운세 지수 $score점 · $text';
  }

  @override
  String get notifChannelName => '오늘의 운세 알림';

  @override
  String get notifChannelDesc => '매일 아침 오늘의 운세를 알려드립니다.';

  @override
  String get catOverall => '총운';

  @override
  String get catLove => '애정운';

  @override
  String get catMoney => '금전운';

  @override
  String get catWork => '직장·학업운';

  @override
  String get catHealth => '건강운';
}
