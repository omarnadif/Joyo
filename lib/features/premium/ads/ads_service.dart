import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads_service_unsupported.dart'
    if (dart.library.io) 'ads_service_mobile.dart'
    as impl;

/// Pubblicità dell'app: solo interstiziale a fine partita e annuncio con
/// premio per una domanda AI. L'implementazione vera è solo su Android/iOS
/// (google_mobile_ads usa dart:io); altrove `createAdsService` ripiega a vuoto.
abstract class AdsService {
  /// Raccoglie il consenso GDPR (Google UMP) dove richiesto e poi avvia
  /// l'SDK; senza consenso in EEA/UK gli annunci restano spenti.
  Future<void> initialize();

  /// True quando Google impone di offrire un punto di rientro alle opzioni
  /// privacy (utenti EEA/UK): in quel caso mostrare un link che chiama
  /// [showPrivacyOptions], ad esempio nello shop o nelle impostazioni.
  Future<bool> isPrivacyOptionsRequired();

  /// Riapre il form UMP per rivedere il consenso già dato.
  Future<void> showPrivacyOptions();

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
