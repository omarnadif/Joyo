import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/env/app_env.dart';

/// Acquisto in-app del premium AI, consumabile "per stanza": il flag lo scrive
/// la Edge Function unlock-premium (verificando la ricevuta), mai il client.
class PurchaseService {
  PurchaseService();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _buying = false;

  bool get isSupported => !kIsWeb;

  Future<bool> isAvailable() async {
    if (!isSupported) return false;
    try {
      return await _iap.isAvailable();
    } catch (_) {
      return false;
    }
  }

  Future<ProductDetails?> premiumProduct() => productById(
    AppEnv.premiumProductId,
  );

  /// Dettagli (prezzo, titolo) di un prodotto per la sua id, o null se lo store
  /// non è disponibile o non lo conosce.
  Future<ProductDetails?> productById(String id) async {
    if (!await isAvailable()) return null;
    final response = await _iap.queryProductDetails({id});
    if (response.productDetails.isEmpty) return null;
    return response.productDetails.first;
  }

  /// Avvia l'acquisto e attende l'esito: torna il token da mandare al server,
  /// o null se l'utente annulla o qualcosa va storto.
  Future<String?> buyPremium() async {
    // Guardia sincrona (prima di ogni await): un secondo tap sovrapposto
    // strapperebbe l'ascolto al primo, che resterebbe appeso fino al timeout.
    if (_buying) return null;
    _buying = true;

    try {
      final product = await premiumProduct();
      if (product == null) return null;
      return await _run(product);
    } finally {
      _buying = false;
    }
  }

  Future<String?> _run(ProductDetails product) async {
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
            // Il consumabile va completato o non sarà più riacquistabile.
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
          case PurchaseStatus.restored:
            // Replay di un acquisto vecchio: si consuma soltanto, senza sbloccare.
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
      // Es. acquisto già in sospeso sulla piattaforma: per il chiamante è un
      // acquisto non riuscito, non un errore da propagare.
      return null;
    } finally {
      await subscription.cancel();
      _subscription = null;
    }
  }

  /// Avvia l'acquisto di un abbonamento (no-ads o premium) e attende l'esito:
  /// torna il token da mandare alla Edge Function di verifica, o null se
  /// l'utente annulla. A differenza del consumabile usa buyNonConsumable e
  /// tratta anche 'restored' come successo (l'abbonamento è di nuovo attivo).
  Future<String?> buySubscription(String productId) async {
    if (_buying) return null;
    _buying = true;
    try {
      final product = await productById(productId);
      if (product == null) return null;
      return await _runSubscription(product);
    } finally {
      _buying = false;
    }
  }

  Future<String?> _runSubscription(ProductDetails product) async {
    final completer = Completer<String?>();

    final subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.productID != product.id) continue;
        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            if (!completer.isCompleted) {
              completer.complete(
                purchase.verificationData.serverVerificationData,
              );
            }
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
      await _iap.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      return await completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () => null,
      );
    } catch (_) {
      return null;
    } finally {
      await subscription.cancel();
      _subscription = null;
    }
  }

  /// Ripristina gli acquisti e raccoglie i token degli abbonamenti attivi tra
  /// quelli richiesti, da rimandare alla verifica. Serve su un nuovo dispositivo
  /// o dopo una reinstallazione, dove il diritto va riportato dallo store.
  Future<List<({String productId, String token})>> restoreSubscriptions(
    Set<String> productIds,
  ) async {
    if (!await isAvailable()) return const [];

    final found = <String, String>{};
    final subscription = _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (!productIds.contains(purchase.productID)) continue;
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          found[purchase.productID] =
              purchase.verificationData.serverVerificationData;
        }
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    });

    try {
      await _iap.restorePurchases();
      // restorePurchases non segnala la fine: si attende una breve finestra che
      // lo stream emetta gli acquisti passati.
      await Future<void>.delayed(const Duration(seconds: 4));
    } catch (_) {
      // Niente da ripristinare o store non pronto: lista vuota.
    } finally {
      await subscription.cancel();
    }

    return [
      for (final entry in found.entries)
        (productId: entry.key, token: entry.value),
    ];
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
