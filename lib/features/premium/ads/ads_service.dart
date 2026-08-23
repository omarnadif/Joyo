import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ads_service_unsupported.dart'
    if (dart.library.io) 'ads_service_mobile.dart'
    as impl;

/// Pubblicità dell'app.
///
/// Due formati soltanto, come da scelta di prodotto: un interstiziale dopo il
/// podio e un annuncio con premio, facoltativo, per generare una domanda AI.
/// Nessun banner durante il gioco: in un gruppo che guarda lo stesso schermo
/// darebbero solo fastidio.
///
/// L'implementazione vera esiste solo su Android/iOS: google_mobile_ads
/// importa dart:io e non compila per il web; su desktop e nei test
/// `createAdsService` ripiega comunque sulla versione a vuoto.
abstract class AdsService {
  Future<void> initialize();

  /// Interstiziale di fine partita. Non blocca mai il flusso: se l'annuncio
  /// non è pronto si prosegue e basta.
  Future<void> showInterstitial();

  /// Annuncio con premio. Ritorna true solo se l'utente lo ha guardato fino
  /// in fondo e ha diritto alla ricompensa.
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
