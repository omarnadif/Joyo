import 'dart:async';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/env/app_env.dart';
import 'ads_service.dart';
import 'ads_service_unsupported.dart' show UnsupportedAdsService;

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
  bool _loadingInterstitial = false;
  bool _loadingRewarded = false;

  @override
  bool get isSupported => true;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      await MobileAds.instance.initialize();
    } catch (_) {
      // Se l'SDK non parte, i metodi show* proseguono comunque a vuoto.
      return;
    }
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
    if (_loadingInterstitial || _interstitial != null) return;
    _loadingInterstitial = true;
    try {
      await InterstitialAd.load(
        adUnitId: _interstitialUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitial = ad;
            _loadingInterstitial = false;
          },
          // Niente retry immediato: il prossimo show* riprova a caricare,
          // così un avvio offline non spegne il formato per tutta la sessione.
          onAdFailedToLoad: (_) => _loadingInterstitial = false,
        ),
      );
    } catch (_) {
      _loadingInterstitial = false;
    }
  }

  Future<void> _loadRewarded() async {
    if (_loadingRewarded || _rewarded != null) return;
    _loadingRewarded = true;
    try {
      await RewardedAd.load(
        adUnitId: _rewardedUnit,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewarded = ad;
            _loadingRewarded = false;
          },
          onAdFailedToLoad: (_) => _loadingRewarded = false,
        ),
      );
    } catch (_) {
      _loadingRewarded = false;
    }
  }

  @override
  Future<void> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) {
      unawaited(_loadInterstitial());
      return;
    }
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
    try {
      await ad.show();
    } catch (_) {
      // Il contratto è "non blocca mai il flusso": si prosegue senza annuncio.
      ad.dispose();
      unawaited(_loadInterstitial());
      return;
    }
    await closed.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        ad.dispose();
        unawaited(_loadInterstitial());
      },
    );
  }

  @override
  Future<bool> showRewarded() async {
    final ad = _rewarded;
    if (ad == null) {
      unawaited(_loadRewarded());
      return false;
    }
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

    try {
      await ad.show(onUserEarnedReward: (_, _) => earned = true);
    } catch (_) {
      ad.dispose();
      unawaited(_loadRewarded());
      return false;
    }
    await closed.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        ad.dispose();
        unawaited(_loadRewarded());
      },
    );
    return earned;
  }

  @override
  void dispose() {
    _interstitial?.dispose();
    _interstitial = null;
    _rewarded?.dispose();
    _rewarded = null;
  }
}

/// `dart.library.io` è vero anche su desktop e nei test su VM, dove il plugin
/// AdMob non esiste: lì si ripiega sulla versione a vuoto.
AdsService createAdsService() => Platform.isAndroid || Platform.isIOS
    ? MobileAdsService()
    : const UnsupportedAdsService();
