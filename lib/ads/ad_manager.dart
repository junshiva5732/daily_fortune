import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

/// 전면 광고를 미리 로드해 두고 필요할 때 보여주는 싱글톤.
///
/// 배너는 화면마다 붙어야 하므로 [BannerAdWidget] 에서 개별 관리한다.
class AdManager {
  AdManager._();
  static final AdManager instance = AdManager._();

  InterstitialAd? _interstitial;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    loadInterstitial();
  }

  // ---------------------------------------------------------------- 전면 광고

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (err) {
          debugPrint('Interstitial load failed: $err');
          _interstitial = null;
        },
      ),
    );
  }

  /// 로드된 전면 광고가 있으면 보여주고, 닫힌 뒤 [onDone] 을 호출한다.
  /// 아직 로드되지 않았으면 광고 없이 바로 [onDone].
  void showInterstitialThen(VoidCallback onDone) {
    final ad = _interstitial;
    if (ad == null) {
      loadInterstitial(); // 다음 기회를 위해 다시 시도
      onDone();
      return;
    }
    _interstitial = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitial();
        onDone();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        loadInterstitial();
        onDone();
      },
    );
    ad.show();
  }
}
