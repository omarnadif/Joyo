import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads_service_unsupported.dart'
    if (dart.library.io) 'ads_service_mobile.dart'
    as impl;

/// Pubblicità dell'app: solo interstiziale a fine partita e annuncio con
/// premio per una domanda AI. L'implementazione vera è solo su Android/iOS
/// (google_mobile_ads usa dart:io); altrove `createAdsService` ripiega a vuoto.
abstract class AdsService {
  Future<void> initialize();

  /// Interstiziale di fine partita; non blocca il flusso se non è pronto.
  Future<void> showInterstitial();

  /// Annuncio con premio: true solo se guardato fino in fondo.
  Future<bool> showRewarded();

  bool get isSupported;

  /// Rilascia gli annunci precaricati e non ancora mostrati.
  void dispose();
}

final adsServiceProvider = Provider<AdsService>((ref) {
  final service = impl.createAdsService();
  ref.onDispose(service.dispose);
  unawaited(service.initialize());
  return service;
});
