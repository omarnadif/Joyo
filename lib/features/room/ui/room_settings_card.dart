import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../games/game_mode.dart';
import '../data/models/room.dart';
import '../state/room_providers.dart';

/// Modalità e durata della partita. Le vedono tutti, le cambia solo l'host.
///
/// Le tre modalità sono la prima decisione della serata, quindi occupano più
/// spazio del resto e mostrano la descrizione di quella scelta: nessuno deve
/// scoprire cos'è "Hot" dopo aver iniziato a giocare.
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

    // Le scritture partono senza attendere (il feedback è la card che si
    // aggiorna via Realtime), ma un errore non deve sparire in silenzio.
    void update(Future<void> Function() write) {
      final messenger = ScaffoldMessenger.of(context);
      write().catchError((Object _) {
        messenger.showSnackBar(SnackBar(content: Text(t('common.retry'))));
      });
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
                Expanded(
                  child: _ModeTile(
                    mode: mode,
                    label: t('mode.${mode.id}'),
                    selected: room.mode == mode,
                    // Il tono va scritto insieme alla modalità: è quello che
                    // la Edge Function AI legge da `rooms.tone`. Senza questo
                    // i contenuti AI resterebbero soft anche in Hot.
                    onTap: isHost
                        ? () => update(
                            () => repo.updateSettings(
                              roomId: room.id,
                              mode: mode.id,
                              tone: mode.primaryTone,
                            ),
                          )
                        : null,
                  ),
                ),
                if (mode != GameMode.values.last) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            t('mode.${room.mode.id}.desc'),
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
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
              for (final count in _roundOptions)
                _RoundChip(
                  label: '$count',
                  selected: room.roundsTotal == count,
                  onTap: isHost
                      ? () => update(
                          () => repo.updateSettings(
                            roomId: room.id,
                            roundsTotal: count,
                          ),
                        )
                      : null,
                ),
            ],
          ),
        ],
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
  });

  final GameMode mode;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? mode.color.withValues(alpha: 0.18)
              : JoyoColors.surfaceHigh,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? mode.color : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: mode.color.withValues(alpha: 0.3),
                    blurRadius: 22,
                    spreadRadius: -6,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              mode.icon,
              size: 20,
              color: selected ? mode.color : JoyoColors.textSecondary,
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
    );
  }
}

class _RoundChip extends StatelessWidget {
  const _RoundChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
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
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? JoyoColors.violet : JoyoColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
