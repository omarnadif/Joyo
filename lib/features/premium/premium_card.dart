import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/env/app_env.dart';
import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/joyo_ui.dart';
import '../room/data/models/room.dart';
import 'ads/ads_service.dart';
import 'ai_content_repository.dart';
import 'purchase_service.dart';

/// Riquadro del premium AI nella lobby.
///
/// L'acquisto vale per la stanza, non per l'account: è la sessione di gioco
/// che si sblocca, così chi ospita paga una volta per la serata.
class PremiumCard extends ConsumerStatefulWidget {
  const PremiumCard({required this.room, required this.isHost, super.key});

  final Room room;
  final bool isHost;

  @override
  ConsumerState<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends ConsumerState<PremiumCard> {
  bool _busy = false;

  Future<void> _buy() async {
    setState(() => _busy = true);
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final purchases = ref.read(purchaseServiceProvider);
      if (!await purchases.isAvailable()) {
        messenger.showSnackBar(SnackBar(content: Text(t('premium.no_store'))));
        return;
      }
      final token = await purchases.buyPremium();
      // L'acquisto può durare minuti: la schermata potrebbe non esserci più.
      if (token == null || !mounted) return;

      final ok = await ref
          .read(aiContentRepositoryProvider)
          .unlockPremium(
            roomId: widget.room.id,
            purchaseToken: token,
            productId: AppEnv.premiumProductId,
          );
      messenger.showSnackBar(
        SnackBar(content: Text(ok ? t('premium.unlocked') : t('common.retry'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _watchAd() async {
    setState(() => _busy = true);
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ads = ref.read(adsServiceProvider);
      if (!ads.isSupported) {
        messenger.showSnackBar(
          SnackBar(content: Text(t('premium.ads_mobile_only'))),
        );
        return;
      }
      final earned = await ads.showRewarded();
      if (!mounted) return;
      if (!earned) {
        messenger.showSnackBar(
          SnackBar(content: Text(t('premium.ad_incomplete'))),
        );
        return;
      }
      final ok = await ref
          .read(aiContentRepositoryProvider)
          .grantAdCredit(widget.room.id);
      messenger.showSnackBar(
        SnackBar(
          content: Text(ok ? t('premium.ad_reward') : t('common.retry')),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final room = widget.room;

    // Con l'interruttore di sviluppo la card mostra lo stato "attivo" ma con
    // un'etichetta esplicita: non deve sembrare un acquisto riuscito.
    if (room.isPremiumAi || AppEnv.devUnlockPremium) {
      return GlowCard(
        accent: JoyoColors.aqua,
        glow: 1.2,
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: JoyoColors.aqua),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t('premium.active'),
                          style: text.titleMedium,
                        ),
                      ),
                      if (!room.isPremiumAi)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: JoyoColors.amber.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'DEV',
                            style: text.labelSmall?.copyWith(
                              color: JoyoColors.amber,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    t('premium.active_body'),
                    style: text.bodySmall?.copyWith(
                      color: JoyoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GlowCard(
      accent: JoyoColors.violet,
      glow: 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: JoyoColors.violet),
              const SizedBox(width: 10),
              Expanded(
                child: Text(t('premium.title'), style: text.titleMedium),
              ),
              if (room.aiCredits > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: JoyoColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    t('premium.credits', {'n': '${room.aiCredits}'}),
                    style: text.bodySmall?.copyWith(color: JoyoColors.aqua),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            t('premium.body'),
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
          ),
          if (widget.isHost) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: JoyoGhostButton(
                    label: t('premium.watch_ad'),
                    onPressed: _busy ? null : _watchAd,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: JoyoButton(
                    accent: JoyoColors.violet,
                    label: t('premium.unlock'),
                    busy: _busy,
                    onPressed: _busy ? null : _buy,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            Text(
              t('premium.host_only'),
              style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
