// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily Fortune';

  @override
  String get onboardingTitle => 'Get Started';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get onboardingHeadline => 'When were you born?';

  @override
  String get onboardingBody => 'We use your zodiac sign and birthday to create a fresh fortune every day.\nYour info stays on this device only.';

  @override
  String get birthDateSection => 'Date of birth';

  @override
  String get birthDatePickerHelp => 'Select your birth date';

  @override
  String zodiacLabel(String animal) {
    return 'Year of the $animal';
  }

  @override
  String get notificationSection => 'Morning reminder';

  @override
  String get notificationToggleTitle => 'Daily fortune reminder';

  @override
  String get notificationToggleSubtitle => 'Get your fortune score and outlook every morning';

  @override
  String get notificationTime => 'Reminder time';

  @override
  String get notificationTimeHelp => 'Reminder time';

  @override
  String get save => 'Save';

  @override
  String get goSeeFortune => 'See my fortune';

  @override
  String get shareTooltip => 'Share';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get fortuneIndex => 'Fortune score';

  @override
  String get luckyNumber => 'Lucky number';

  @override
  String get luckyColor => 'Lucky color';

  @override
  String get luckyItem => 'Lucky item';

  @override
  String get luckyDirection => 'Lucky direction';

  @override
  String get seeDetail => 'See full fortune';

  @override
  String get todaysQuote => 'Quote of the day';

  @override
  String detailTitle(String zodiac) {
    return '$zodiac · Full fortune';
  }

  @override
  String get detailFooter => 'Fortunes are just for fun. Have a wonderful day 🌙';

  @override
  String get shareTitle => 'Share';

  @override
  String get shareAsImage => 'Share as image';

  @override
  String get shareAsText => 'Share as text';

  @override
  String get shareHint => 'Send it via messages, Instagram Stories, WhatsApp and more';

  @override
  String shareCardTitle(String zodiac) {
    return '$zodiac · Today\'s fortune';
  }

  @override
  String get shareAppFooter => 'Daily Fortune app';

  @override
  String get shareImageCaption => 'Today\'s fortune ✨';

  @override
  String shareTextHeader(String date, String zodiac) {
    return '📅 $date · Today\'s fortune ($zodiac)';
  }

  @override
  String shareTextScore(int score) {
    return 'Fortune score $score';
  }

  @override
  String shareTextLucky(int number, String color, String item) {
    return '🍀 Lucky number $number · $color · $item';
  }

  @override
  String get notifTitle => '🌙 Your fortune for today is ready';

  @override
  String notifBody(String zodiac, int score, String text) {
    return '$zodiac · Score $score · $text';
  }

  @override
  String get notifChannelName => 'Daily fortune reminder';

  @override
  String get notifChannelDesc => 'Delivers your fortune every morning.';

  @override
  String get catOverall => 'Overall';

  @override
  String get catLove => 'Love';

  @override
  String get catMoney => 'Money';

  @override
  String get catWork => 'Work & Study';

  @override
  String get catHealth => 'Health';
}
