import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/env/app_env.dart';
import '../../core/supabase/supabase_providers.dart';

/// Abbonamenti dell'utente (per account, non per stanza). La riga la scrive
/// solo la Edge Function verify-subscription dopo aver verificato la ricevuta;
/// qui si leggono i diritti attivi e si inoltra il token da verificare.
class EntitlementsRepository {
  const EntitlementsRepository(this._client);

  final SupabaseClient _client;

  /// Prodotti con abbonamento ancora attivo (scadenza futura). La RLS limita
  /// già la lettura alle righe dell'utente; il filtro sulla scadenza è un di più
  /// nel caso una riga scaduta non sia ancora stata ripulita.
  Future<Set<String>> activeProducts() async {
    final rows = await _client
        .from('entitlements')
        .select('product, expires_at');
    final now = DateTime.now().toUtc();
    return {
      for (final row in rows)
        if (DateTime.parse(row['expires_at'] as String).isAfter(now))
          row['product'] as String,
    };
  }

  /// Manda ricevuta + prodotto alla Edge Function, che verifica e scrive
  /// l'entitlement. Torna true se il diritto è stato registrato.
  Future<bool> verify({
    required String productId,
    required String purchaseToken,
  }) async {
    try {
      final response = await _client.functions.invoke(
        'verify-subscription',
        body: {'product_id': productId, 'purchase_token': purchaseToken},
      );
      final data = response.data;
      return data is Map && data['ok'] == true;
    } catch (_) {
      return false;
    }
  }
}

final entitlementsRepositoryProvider = Provider<EntitlementsRepository>(
  (ref) => EntitlementsRepository(ref.watch(supabaseProvider)),
);

/// Stato dei diritti attivi dell'utente. Si carica dopo il login anonimo e si
/// ricarica dopo un acquisto o un ripristino ([refresh]).
class EntitlementsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    // Serve un utente autenticato per leggere le proprie righe.
    await ref.watch(anonSessionProvider.future);
    return ref.read(entitlementsRepositoryProvider).activeProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(entitlementsRepositoryProvider).activeProducts(),
    );
  }
}

final entitlementsProvider =
    AsyncNotifierProvider<EntitlementsNotifier, Set<String>>(
      EntitlementsNotifier.new,
    );

/// Abbonamento premium completo attivo (Mix/Hot, round e niente pubblicità).
final hasPremiumProvider = Provider<bool>((ref) {
  final products = ref.watch(entitlementsProvider).value ?? const {};
  return products.contains(AppEnv.premiumSubProductId) ||
      AppEnv.devUnlockPremium;
});

/// Crediti "partita premium" guadagnati con gli annunci: [adProgress] è
/// l'avanzamento verso la prossima partita (0..2), [games] le partite in banca.
typedef PremiumCredits = ({int adProgress, int games});

/// Crediti dell'utente, letti dopo il login e ricaricati dopo ogni annuncio.
class PremiumCreditsNotifier extends AsyncNotifier<PremiumCredits> {
  @override
  Future<PremiumCredits> build() async {
    await ref.watch(anonSessionProvider.future);
    return _read();
  }

  Future<PremiumCredits> _read() async {
    final rows = await ref
        .read(supabaseProvider)
        .from('user_premium_credits')
        .select('ad_progress, games');
    if (rows.isEmpty) return (adProgress: 0, games: 0);
    final row = rows.first;
    return (
      adProgress: (row['ad_progress'] as num?)?.toInt() ?? 0,
      games: (row['games'] as num?)?.toInt() ?? 0,
    );
  }

  /// Registra un annuncio visto (la RPC verifica e aggiorna il contatore) e
  /// riflette subito il nuovo stato.
  Future<void> grantAd() async {
    final rows = await ref.read(supabaseProvider).rpc('grant_mode_unlock');
    if (rows is List && rows.isNotEmpty) {
      final row = rows.first as Map<String, dynamic>;
      state = AsyncData((
        adProgress: (row['ad_progress'] as num?)?.toInt() ?? 0,
        games: (row['games'] as num?)?.toInt() ?? 0,
      ));
    } else {
      state = await AsyncValue.guard(_read);
    }
  }
}

final premiumCreditsProvider =
    AsyncNotifierProvider<PremiumCreditsNotifier, PremiumCredits>(
      PremiumCreditsNotifier.new,
    );

/// Può usare le feature premium (Mix/Hot, round >10): abbonamento premium o
/// almeno una partita in banca dagli annunci. Il server valida comunque.
final premiumUnlockedProvider = Provider<bool>((ref) {
  if (ref.watch(hasPremiumProvider)) return true;
  final credits = ref.watch(premiumCreditsProvider).value;
  return (credits?.games ?? 0) > 0;
});

/// Niente pubblicità: abbonamento no-ads oppure premium (che lo include).
final noAdsProvider = Provider<bool>((ref) {
  final products = ref.watch(entitlementsProvider).value ?? const {};
  return products.contains(AppEnv.noAdsProductId) ||
      products.contains(AppEnv.premiumSubProductId) ||
      AppEnv.devUnlockPremium;
});
