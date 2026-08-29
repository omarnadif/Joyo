import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/env/app_env.dart';
import 'ads_service.dart';
import 'ads_service_unsupported.dart' show UnsupportedAdsService;

/// AdMob su Android e iOS. In debug/profile girano SEMPRE gli id di test di
/// Google, anche se env.json contiene quelli veri: cliccare i propri annunci
/// reali in sviluppo fa bannare l'account AdMob. Gli id veri contano solo in
/// release, dove AppEnv.isConfigured li pretende.
class MobileAdsService implements AdsService {
  MobileAdsService();

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  bool _initialized = false;
  bool _adsStarted = false;
  bool _loadingInterstitial = false;
  bool _loadingRewarded = false;

  @override
  bool get isSupported => true;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      await _gatherConsent();
    } catch (_) {
      // Offline o form fallito: canRequestAds sotto decide; in EEA senza
      // consenso registrato gli annunci restano spenti, com'è dovuto.
    }
    await _startAdsIfAllowed();
  }

  /// Messaggio di consenso Google UMP: in EEA/UK è obbligatorio prima di
  /// servire annunci; altrove `loadAndShowConsentFormIfRequired` termina
  /// subito senza mostrare nulla. La scelta resta salvata sul dispositivo,
  /// quindi agli avvii successivi il form non riappare.
  Future<void> _gatherConsent() async {
    final updated = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        if (!updated.isCompleted) updated.complete();
      },
      (FormError error) {
        if (!updated.isCompleted) {
          updated.completeError(StateError(error.message));
        }
      },
    );
    await updated.future;

    final dismissed = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
      if (dismissed.isCompleted) return;
      if (error != null) {
        dismissed.completeError(StateError(error.message));
      } else {
        dismissed.complete();
      }
    });
    await dismissed.future;
  }

  Future<void> _startAdsIfAllowed() async {
    if (_adsStarted) return;
    try {
      if (!await ConsentInformation.instance.canRequestAds()) return;
    } catch (_) {
      return;
    }
    _adsStarted = true;
    try {
      await MobileAds.instance.initialize();
    } catch (_) {
      // Se l'SDK non parte, i metodi show* proseguono comunque a vuoto.
      return;
    }
    unawaited(_loadInterstitial());
    unawaited(_loadRewarded());
  }

  @override
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> showPrivacyOptions() async {
    final dismissed = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (!dismissed.isCompleted) dismissed.complete();
    });
    await dismissed.future;
    // Se l'utente ha appena dato il consenso, gli annunci possono partire
    // senza aspettare il prossimo avvio.
    await _startAdsIfAllowed();
  }

  String get _interstitialUnit =>
      kReleaseMode && AppEnv.admobInterstitialId.isNotEmpty
      ? AppEnv.admobInterstitialId
      : Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  String get _rewardedUnit => kReleaseMode && AppEnv.admobRewardedId.isNotEmpty
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
          // Niente retry immediato: ricarica il prossimo show*, così un avvio
          // offline non spegne il formato per l'intera sessione.
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

/// `dart.library.io` è vero anche su desktop e nei test, dove AdMob non
/// esiste: lì si ripiega sulla versione a vuoto.
AdsService createAdsService() => Platform.isAndroid || Platform.isIOS
    ? MobileAdsService()
    : const UnsupportedAdsService();
