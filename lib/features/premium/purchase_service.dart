import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/env/app_env.dart';

/// Acquisto in-app del premium AI.
///
/// Il prodotto è "per stanza", non per account: si compra per la serata in
/// corso, quindi è un consumabile. Alla conferma dell'acquisto il flag non lo
/// scrive il client (non potrebbe: la colonna gli è negata) ma la Edge
/// Function unlock-premium, che è anche il punto in cui andrà verificata la
/// ricevuta con Google Play.
class PurchaseService {
  PurchaseService();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool get isSupported => !kIsWeb;

  Future<bool> isAvailable() async {
    if (!isSupported) return false;
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  Future<ProductDetails?> premiumProduct() async {
    if (!await isAvailable()) return null;
    final response = await _iap.queryProductDetails({AppEnv.premiumProductId});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  /// Avvia l'acquisto e attende l'esito.
  ///
  /// Torna il token di acquisto da mandare al server, oppure null se
  /// l'utente annulla o qualcosa va storto.
  Future<String?> buyPremium() async {
    // Un acquisto alla volta: una seconda chiamata sovrapposta strapperebbe
    // l'ascolto alla prima, che resterebbe appesa fino al timeout.
    if (_subscription != null) return null;

    final product = await premiumProduct();
    if (product == null) return null;

    final completer = Completer<String?>();

    final subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID != AppEnv.premiumProductId) continue;

        switch (purchase.status) {
          case PurchaseStatus.purchased:
            if (!completer.isCompleted) {
              completer.complete(
                purchase.verificationData.serverVerificationData,
              );
            }
            // consumabile: va completato, altrimenti non è più riacquistabile
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
          case PurchaseStatus.restored:
            // Replay di un acquisto vecchio, non l'esito di questo
            // buyConsumable: va solo consumato, senza sbloccare niente.
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
          case PurchaseStatus.error:
          case PurchaseStatus.canceled:
            if (!completer.isCompleted) completer.complete(null);
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
          case PurchaseStatus.pending:
            break;
        }
      }
    });
    _subscription = subscription;

    try {
      await _iap.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      return await completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () => null,
      );
    } catch (_) {
      // Es. acquisto già in sospeso sul lato piattaforma: per il chiamante è
      // un acquisto non riuscito, non un errore da propagare.
      return null;
    } finally {
      await subscription.cancel();
      _subscription = null;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService();
  ref.onDispose(service.dispose);
  return service;
});
