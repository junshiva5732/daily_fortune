// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '今日の運勢';

  @override
  String get onboardingTitle => 'はじめる';

  @override
  String get settingsTitle => '設定';

  @override
  String get onboardingHeadline => '生年月日を教えてください';

  @override
  String get onboardingBody => '干支と誕生日をもとに、毎日違う運勢をお届けします。\n入力した情報は端末内にのみ保存されます。';

  @override
  String get birthDateSection => '生年月日';

  @override
  String get birthDatePickerHelp => '生年月日を選択';

  @override
  String zodiacLabel(String animal) {
    return '$animal年';
  }

  @override
  String get notificationSection => '朝の通知';

  @override
  String get notificationToggleTitle => '毎日の運勢通知';

  @override
  String get notificationToggleSubtitle => '今日の運勢スコアと総合運をお知らせします';

  @override
  String get notificationTime => '通知時刻';

  @override
  String get notificationTimeHelp => '通知時刻';

  @override
  String get save => '保存';

  @override
  String get goSeeFortune => '運勢を見る';

  @override
  String get shareTooltip => '共有';

  @override
  String get settingsTooltip => '設定';

  @override
  String get fortuneIndex => '運勢スコア';

  @override
  String get luckyNumber => 'ラッキーナンバー';

  @override
  String get luckyColor => 'ラッキーカラー';

  @override
  String get luckyItem => 'ラッキーアイテム';

  @override
  String get luckyDirection => 'ラッキー方位';

  @override
  String get seeDetail => '詳しい運勢を見る';

  @override
  String get todaysQuote => '今日の名言';

  @override
  String detailTitle(String zodiac) {
    return '$zodiacの詳しい運勢';
  }

  @override
  String get detailFooter => '運勢は楽しむためのものです。今日も良い一日を 🌙';

  @override
  String get shareTitle => '共有する';

  @override
  String get shareAsImage => '画像で共有';

  @override
  String get shareAsText => 'テキストで共有';

  @override
  String get shareHint => 'LINE、Instagramストーリー、メッセージなどで送れます';

  @override
  String shareCardTitle(String zodiac) {
    return '$zodiacの今日の運勢';
  }

  @override
  String get shareAppFooter => '今日の運勢アプリ';

  @override
  String get shareImageCaption => '今日の運勢 ✨';

  @override
  String shareTextHeader(String date, String zodiac) {
    return '📅 $date 今日の運勢（$zodiac）';
  }

  @override
  String shareTextScore(int score) {
    return '運勢スコア $score点';
  }

  @override
  String shareTextLucky(int number, String color, String item) {
    return '🍀 ラッキーナンバー $number · $color · $item';
  }

  @override
  String get notifTitle => '🌙 今日の運勢が届きました';

  @override
  String notifBody(String zodiac, int score, String text) {
    return '$zodiac 運勢スコア $score点 · $text';
  }

  @override
  String get notifChannelName => '今日の運勢通知';

  @override
  String get notifChannelDesc => '毎朝、今日の運勢をお知らせします。';

  @override
  String get catOverall => '総合運';

  @override
  String get catLove => '恋愛運';

  @override
  String get catMoney => '金運';

  @override
  String get catWork => '仕事・学業運';

  @override
  String get catHealth => '健康運';
}
