import 'dart:async';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/env/app_env.dart';
import 'ads_service.dart';

/// AdMob su Android e iOS.
///
/// Senza gli id passati con --dart-define si usano quelli di test ufficiali di
/// Google: così l'app è provabile subito e non si rischia di far girare
/// annunci veri su build di sviluppo (che è un modo per farsi sospendere
/// l'account AdMob).
class MobileAdsService implements AdsService {
  MobileAdsService();

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  bool _initialized = false;

  @override
  bool get isSupported => true;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await MobileAds.instance.initialize();
    unawaited(_loadInterstitial());
    unawaited(_loadRewarded());
  }

  String get _interstitialUnit => AppEnv.admobInterstitialId.isNotEmpty
      ? AppEnv.admobInterstitialId
      : Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  String get _rewardedUnit => AppEnv.admobRewardedId.isNotEmpty
      ? AppEnv.admobRewardedId
      : Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  Future<void> _loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: _interstitialUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  Future<void> _loadRewarded() async {
    await RewardedAd.load(
      adUnitId: _rewardedUnit,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  @override
  Future<void> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) return; // non pronto: si va avanti senza
    _interstitial = null;

    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
        unawaited(_loadInterstitial());
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
        unawaited(_loadInterstitial());
      },
    );
    await ad.show();
    await closed.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () {},
    );
  }

  @override
  Future<bool> showRewarded() async {
    final ad = _rewarded;
    if (ad == null) return false;
    _rewarded = null;

    var earned = false;
    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
        unawaited(_loadRewarded());
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
        unawaited(_loadRewarded());
      },
    );

    await ad.show(
      onUserEarnedReward: (_, _) => earned = true,
    );
    await closed.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {},
    );
    return earned;
  }
}

AdsService createAdsService() => MobileAdsService();
