// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '今日运势';

  @override
  String get onboardingTitle => '开始使用';

  @override
  String get settingsTitle => '设置';

  @override
  String get onboardingHeadline => '请告诉我们您的出生日期';

  @override
  String get onboardingBody => '我们根据生肖和生日，每天为您生成不同的运势。\n您输入的信息仅保存在本机。';

  @override
  String get birthDateSection => '出生日期';

  @override
  String get birthDatePickerHelp => '选择出生日期';

  @override
  String zodiacLabel(String animal) {
    return '属$animal';
  }

  @override
  String get notificationSection => '早晨提醒';

  @override
  String get notificationToggleTitle => '每日运势提醒';

  @override
  String get notificationToggleSubtitle => '每天早晨推送今日运势指数和总运';

  @override
  String get notificationTime => '提醒时间';

  @override
  String get notificationTimeHelp => '提醒时间';

  @override
  String get save => '保存';

  @override
  String get goSeeFortune => '查看运势';

  @override
  String get shareTooltip => '分享';

  @override
  String get settingsTooltip => '设置';

  @override
  String get fortuneIndex => '运势指数';

  @override
  String get luckyNumber => '幸运数字';

  @override
  String get luckyColor => '幸运颜色';

  @override
  String get luckyItem => '幸运物品';

  @override
  String get luckyDirection => '幸运方位';

  @override
  String get seeDetail => '查看详细运势';

  @override
  String get todaysQuote => '今日名言';

  @override
  String detailTitle(String zodiac) {
    return '$zodiac 详细运势';
  }

  @override
  String get detailFooter => '运势仅供娱乐参考。祝您今天愉快 🌙';

  @override
  String get shareTitle => '分享';

  @override
  String get shareAsImage => '以图片分享';

  @override
  String get shareAsText => '以文字分享';

  @override
  String get shareHint => '可通过微信、小红书、短信等发送';

  @override
  String shareCardTitle(String zodiac) {
    return '$zodiac 今日运势';
  }

  @override
  String get shareAppFooter => '今日运势 App';

  @override
  String get shareImageCaption => '今日运势 ✨';

  @override
  String shareTextHeader(String date, String zodiac) {
    return '📅 $date 今日运势（$zodiac）';
  }

  @override
  String shareTextScore(int score) {
    return '运势指数 $score分';
  }

  @override
  String shareTextLucky(int number, String color, String item) {
    return '🍀 幸运数字 $number · $color · $item';
  }

  @override
  String get notifTitle => '🌙 今日运势已送达';

  @override
  String notifBody(String zodiac, int score, String text) {
    return '$zodiac 运势指数 $score分 · $text';
  }

  @override
  String get notifChannelName => '今日运势提醒';

  @override
  String get notifChannelDesc => '每天早晨为您推送今日运势。';

  @override
  String get catOverall => '总运';

  @override
  String get catLove => '爱情运';

  @override
  String get catMoney => '财运';

  @override
  String get catWork => '事业·学业运';

  @override
  String get catHealth => '健康运';
}
