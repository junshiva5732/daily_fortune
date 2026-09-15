import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운세'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get onboardingTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @onboardingHeadline.
  ///
  /// In ko, this message translates to:
  /// **'생년월일을 알려주세요'**
  String get onboardingHeadline;

  /// No description provided for @onboardingBody.
  ///
  /// In ko, this message translates to:
  /// **'띠와 생일을 기준으로 매일 다른 운세를 보여드려요.\n입력한 정보는 기기에만 저장됩니다.'**
  String get onboardingBody;

  /// No description provided for @birthDateSection.
  ///
  /// In ko, this message translates to:
  /// **'생년월일'**
  String get birthDateSection;

  /// No description provided for @birthDatePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'생년월일 선택'**
  String get birthDatePickerHelp;

  /// No description provided for @zodiacLabel.
  ///
  /// In ko, this message translates to:
  /// **'{animal}띠'**
  String zodiacLabel(String animal);

  /// No description provided for @notificationSection.
  ///
  /// In ko, this message translates to:
  /// **'아침 알림'**
  String get notificationSection;

  /// No description provided for @notificationToggleTitle.
  ///
  /// In ko, this message translates to:
  /// **'매일 운세 알림'**
  String get notificationToggleTitle;

  /// No description provided for @notificationToggleSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운세 지수와 총운을 알려드려요'**
  String get notificationToggleSubtitle;

  /// No description provided for @notificationTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간'**
  String get notificationTime;

  /// No description provided for @notificationTimeHelp.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간'**
  String get notificationTimeHelp;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @goSeeFortune.
  ///
  /// In ko, this message translates to:
  /// **'운세 보러 가기'**
  String get goSeeFortune;

  /// No description provided for @shareTooltip.
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get shareTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTooltip;

  /// No description provided for @fortuneIndex.
  ///
  /// In ko, this message translates to:
  /// **'운세 지수'**
  String get fortuneIndex;

  /// No description provided for @luckyNumber.
  ///
  /// In ko, this message translates to:
  /// **'행운의 숫자'**
  String get luckyNumber;

  /// No description provided for @luckyColor.
  ///
  /// In ko, this message translates to:
  /// **'행운의 색'**
  String get luckyColor;

  /// No description provided for @luckyItem.
  ///
  /// In ko, this message translates to:
  /// **'행운의 아이템'**
  String get luckyItem;

  /// No description provided for @luckyDirection.
  ///
  /// In ko, this message translates to:
  /// **'행운의 방향'**
  String get luckyDirection;

  /// No description provided for @seeDetail.
  ///
  /// In ko, this message translates to:
  /// **'상세 운세 보기'**
  String get seeDetail;

  /// No description provided for @todaysQuote.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 명언'**
  String get todaysQuote;

  /// No description provided for @detailTitle.
  ///
  /// In ko, this message translates to:
  /// **'{zodiac} 상세 운세'**
  String detailTitle(String zodiac);

  /// No description provided for @detailFooter.
  ///
  /// In ko, this message translates to:
  /// **'운세는 재미로 보는 콘텐츠예요. 오늘도 좋은 하루 보내세요 🌙'**
  String get detailFooter;

  /// No description provided for @shareTitle.
  ///
  /// In ko, this message translates to:
  /// **'공유하기'**
  String get shareTitle;

  /// No description provided for @shareAsImage.
  ///
  /// In ko, this message translates to:
  /// **'이미지로 공유'**
  String get shareAsImage;

  /// No description provided for @shareAsText.
  ///
  /// In ko, this message translates to:
  /// **'텍스트로 공유'**
  String get shareAsText;

  /// No description provided for @shareHint.
  ///
  /// In ko, this message translates to:
  /// **'카카오톡, 인스타그램 스토리, 문자 등으로 보낼 수 있어요'**
  String get shareHint;

  /// No description provided for @shareCardTitle.
  ///
  /// In ko, this message translates to:
  /// **'{zodiac} 오늘의 운세'**
  String shareCardTitle(String zodiac);

  /// No description provided for @shareAppFooter.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운세 앱'**
  String get shareAppFooter;

  /// No description provided for @shareImageCaption.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운세 ✨'**
  String get shareImageCaption;

  /// No description provided for @shareTextHeader.
  ///
  /// In ko, this message translates to:
  /// **'📅 {date} 오늘의 운세 ({zodiac})'**
  String shareTextHeader(String date, String zodiac);

  /// No description provided for @shareTextScore.
  ///
  /// In ko, this message translates to:
  /// **'운세 지수 {score}점'**
  String shareTextScore(int score);

  /// No description provided for @shareTextLucky.
  ///
  /// In ko, this message translates to:
  /// **'🍀 행운의 숫자 {number} · {color} · {item}'**
  String shareTextLucky(int number, String color, String item);

  /// No description provided for @notifTitle.
  ///
  /// In ko, this message translates to:
  /// **'🌙 오늘의 운세가 도착했어요'**
  String get notifTitle;

  /// No description provided for @notifBody.
  ///
  /// In ko, this message translates to:
  /// **'{zodiac} 운세 지수 {score}점 · {text}'**
  String notifBody(String zodiac, int score, String text);

  /// No description provided for @notifChannelName.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 운세 알림'**
  String get notifChannelName;

  /// No description provided for @notifChannelDesc.
  ///
  /// In ko, this message translates to:
  /// **'매일 아침 오늘의 운세를 알려드립니다.'**
  String get notifChannelDesc;

  /// No description provided for @catOverall.
  ///
  /// In ko, this message translates to:
  /// **'총운'**
  String get catOverall;

  /// No description provided for @catLove.
  ///
  /// In ko, this message translates to:
  /// **'애정운'**
  String get catLove;

  /// No description provided for @catMoney.
  ///
  /// In ko, this message translates to:
  /// **'금전운'**
  String get catMoney;

  /// No description provided for @catWork.
  ///
  /// In ko, this message translates to:
  /// **'직장·학업운'**
  String get catWork;

  /// No description provided for @catHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강운'**
  String get catHealth;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return L10nEn();
    case 'ja': return L10nJa();
    case 'ko': return L10nKo();
    case 'zh': return L10nZh();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
