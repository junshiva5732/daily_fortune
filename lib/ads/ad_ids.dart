import 'dart:io';

/// AdMob 광고 단위 ID.
///
/// 아래 값은 Google 공식 **테스트 ID** 입니다. 개발 중에는 반드시 테스트 ID를
/// 사용해야 하며(실제 ID로 개발 중 클릭하면 계정 정지 사유), 스토어 출시 직전에
/// AdMob 콘솔에서 발급받은 본인 ID로 교체하세요.
///
/// 교체 위치:
///   - 여기 (광고 단위 ID)
///   - android/app/src/main/AndroidManifest.xml (APPLICATION_ID)
///   - ios/Runner/Info.plist (GADApplicationIdentifier)
class AdIds {
  AdIds._();

  static String get banner => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get interstitial => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  static String get rewarded => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';
}
