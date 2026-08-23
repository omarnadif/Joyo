import 'ads_service.dart';

/// Versione web: non c'è AdMob, quindi non succede niente.
class UnsupportedAdsService implements AdsService {
  const UnsupportedAdsService();

  @override
  bool get isSupported => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> showInterstitial() async {}

  @override
  Future<bool> showRewarded() async => false;

  @override
  void dispose() {}
}

AdsService createAdsService() => const UnsupportedAdsService();
