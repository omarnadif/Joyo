import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase/supabase_providers.dart';

/// Contenuti AI via Edge Function: la chiave OpenAI resta sul server, che
/// verifica il diritto della stanza (premium o credito da annuncio). Ogni
/// metodo torna `null` se l'AI non è disponibile e il gioco pesca dal pool.
class AiContentRepository {
  const AiContentRepository(this._client);

  final SupabaseClient _client;

  Future<List<String>?> _invoke(Map<String, dynamic> body) async {
    try {
      final response = await _client.functions.invoke(
        'generate-content',
        body: body,
      );
      final data = response.data;
      if (data is Map && data['items'] is List) {
        final items = (data['items'] as List)
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toList();
        return items.isEmpty ? null : items;
      }
      return null;
    } catch (_) {
      // Funzione non pubblicata, credito finito o rete assente: si usa il pool.
      return null;
    }
  }

  /// Una domanda "Chi del gruppo…?" costruita sui nomi presenti.
  Future<String?> chiLoPotrebbeFare({
    required String roomId,
    required List<String> players,
    required String tone,
  }) async {
    final items = await _invoke({
      'room_id': roomId,
      'game': 'chi_lo_potrebbe_fare',
      'players': players,
      'tone': tone,
    });
    return items?.first;
  }

  /// Due bugie costruite sul fatto vero appena scritto dal giocatore.
  Future<List<String>?> bluffStoryFakes({
    required String roomId,
    required String truth,
    required String tone,
  }) async {
    final items = await _invoke({
      'room_id': roomId,
      'game': 'bluff_story',
      'truth': truth,
      'tone': tone,
    });
    if (items == null || items.length < 2) return null;
    return items.take(2).toList();
  }

  /// Acquisto completato: premium AI per questa stanza.
  Future<bool> unlockPremium({
    required String roomId,
    required String purchaseToken,
    required String productId,
  }) => _unlock({
    'room_id': roomId,
    'kind': 'purchase',
    'purchase_token': purchaseToken,
    'product_id': productId,
  });

  /// Annuncio con premio visto: un singolo contenuto AI.
  Future<bool> grantAdCredit(String roomId) =>
      _unlock({'room_id': roomId, 'kind': 'reward'});

  Future<bool> _unlock(Map<String, dynamic> body) async {
    try {
      final response = await _client.functions.invoke(
        'unlock-premium',
        body: body,
      );
      final data = response.data;
      return data is Map && data['ok'] == true;
    } catch (_) {
      return false;
    }
  }
}

final aiContentRepositoryProvider = Provider<AiContentRepository>(
  (ref) => AiContentRepository(ref.watch(supabaseProvider)),
);
