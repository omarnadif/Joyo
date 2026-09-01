import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../games/game_mode.dart';
import '../../premium/entitlements.dart';
import '../../premium/shop_screen.dart';
import '../data/models/room.dart';
import '../state/room_providers.dart';
import 'age_gate.dart';

/// Modalità e durata della partita: le vedono tutti, le cambia solo l'host, con
/// la descrizione della modalità scelta bene in vista.
class RoomSettingsCard extends ConsumerWidget {
  const RoomSettingsCard({required this.room, required this.isHost, super.key});

  final Room room;
  final bool isHost;

  static const List<int> _roundOptions = <int>[5, 10, 15, 20];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final repo = ref.read(roomRepositoryProvider);
    final premiumUnlocked = ref.watch(premiumUnlockedProvider);

    // Scritture non attese (il feedback è la card via Realtime), ma un errore
    // non deve sparire in silenzio.
    void update(Future<void> Function() write) {
      final messenger = ScaffoldMessenger.of(context);
      write().catchError((Object _) {
        messenger.showSnackBar(SnackBar(content: Text(t('common.retry'))));
      });
    }

    // Mix e Hot hanno contenuti espliciti: la prima volta serve la conferma
    // 18+, poi resta memorizzata sul dispositivo.
    Future<void> selectMode(GameMode mode) async {
      if (mode != GameMode.normale) {
        if (!await ensureAdultConfirmed(context, t)) return;
        if (!context.mounted) return;
      }
      update(() => repo.updateSettings(roomId: room.id, mode: mode.id));
    }

    return GlowCard(
      accent: room.mode.color,
      glow: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(t('mode.title'), color: room.mode.color),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final mode in GameMode.values) ...[
                // Mix e Hot sono premium: se non sbloccate, toccarle apre lo
                // shop invece di selezionarle.
                Expanded(
                  child: _ModeTile(
                    mode: mode,
                    label: t('mode.${mode.id}'),
                    selected: room.mode == mode,
                    locked: mode != GameMode.normale && !premiumUnlocked,
                    onTap: !isHost
                        ? null
                        : (mode != GameMode.normale && !premiumUnlocked)
                        ? () => openShop(context)
                        : () => selectMode(mode),
                  ),
                ),
                if (mode != GameMode.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: room.mode.color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: room.mode.color.withValues(alpha: 0.20),
              ),
            ),
            child: Row(
              children: [
                Icon(room.mode.icon, size: 16, color: room.mode.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t('mode.${room.mode.id}.desc'),
                    style: text.bodySmall?.copyWith(
                      color: JoyoColors.textPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            t('settings.rounds'),
            style: text.labelSmall?.copyWith(color: JoyoColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Oltre 10 round è premium: bloccato apre lo shop.
              for (final count in _roundOptions)
                _RoundChip(
                  label: '$count',
                  selected: room.roundsTotal == count,
                  locked: count > 10 && !premiumUnlocked,
                  onTap: !isHost
                      ? null
                      : (count > 10 && !premiumUnlocked)
                      ? () => openShop(context)
                      : () => update(
                          () => repo.updateSettings(
                            roomId: room.id,
                            roundsTotal: count,
                          ),
                        ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _PremiumFooter(t: t),
        ],
      ),
    );
  }
}

/// Accesso allo shop dalla lobby: mostra lo stato premium o invita ad abbonarsi
/// (e permette il ripristino su un nuovo dispositivo).
class _PremiumFooter extends ConsumerWidget {
  const _PremiumFooter({required this.t});

  final Translator t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final isPremium = ref.watch(hasPremiumProvider);

    if (isPremium) {
      return Row(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: JoyoColors.aqua,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            t('paywall.active'),
            style: text.bodySmall?.copyWith(color: JoyoColors.aqua),
          ),
        ],
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => openShop(context),
        icon: const Icon(
          Icons.workspace_premium_rounded,
          size: 18,
          color: JoyoColors.violet,
        ),
        label: Text(t('paywall.title')),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.label,
    required this.selected,
    required this.onTap,
    this.locked = false,
  });

  final GameMode mode;
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Mix e Hot devono invogliare anche da spente: tengono il loro colore,
    // un velo di gradiente e un alone leggero; il lucchetto è solo un badge
    // d'angolo, non sostituisce l'identità della modalità.
    final premium = mode != GameMode.normale;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: selected
                ? [
                    mode.color.withValues(alpha: 0.30),
                    mode.color.withValues(alpha: 0.10),
                  ]
                : [
                    Color.lerp(
                      JoyoColors.surfaceHigh,
                      mode.color,
                      premium ? 0.10 : 0,
                    )!,
                    JoyoColors.surfaceHigh,
                  ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? mode.color
                : premium
                ? mode.color.withValues(alpha: 0.30)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: mode.color.withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: -6,
                  ),
                ]
              : premium
              ? [
                  BoxShadow(
                    color: mode.color.withValues(alpha: 0.16),
                    blurRadius: 18,
                    spreadRadius: -6,
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  AnimatedScale(
                    scale: selected ? 1.15 : 1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Icon(
                      mode.icon,
                      size: 22,
                      color: selected
                          ? mode.color
                          : premium
                          ? mode.color.withValues(alpha: 0.9)
                          : JoyoColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? mode.color : JoyoColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              Positioned(
                top: -8,
                right: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: JoyoColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: mode.color.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(Icons.lock_rounded, size: 11, color: mode.color),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoundChip extends StatelessWidget {
  const _RoundChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.locked = false,
  });

  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? JoyoColors.violet.withValues(alpha: 0.2)
              : JoyoColors.surfaceHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? JoyoColors.violet : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (locked) ...[
              const Icon(
                Icons.lock_rounded,
                size: 13,
                color: JoyoColors.textSecondary,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected ? JoyoColors.violet : JoyoColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
