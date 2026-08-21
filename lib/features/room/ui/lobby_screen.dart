import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/aura.dart';
import '../../../core/ui/joyo_ui.dart';
import '../../../core/ui/game_art.dart';
import '../../games/game_catalog.dart';
import '../../games/widgets/player_chip.dart';
import '../../premium/premium_card.dart';
import '../data/models/player.dart';
import '../data/models/room.dart';
import '../state/room_providers.dart';
import 'room_settings_card.dart';
import 'room_shell.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({required this.room, super.key});

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final session = ref.watch(roomSessionProvider);
    final players = ref.watch(playersProvider(room.id));
    final isHost = ref.watch(isHostProvider(room.id));

    return Aura(
      // viola di base con un accenno del colore della modalità: tingere tutto
      // di verde o di rosso rendeva la lobby una schermata diversa ogni volta
      color: JoyoColors.violet,
      secondary: room.mode.color,
      intensity: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(t('lobby.title'), style: text.titleLarge),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            color: JoyoColors.textSecondary,
            tooltip: isHost ? t('lobby.close') : t('lobby.leave'),
            onPressed: () =>
                confirmExitRoom(context, ref, isHost: isHost, roomId: room.id),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      RiseIn(
                        child: _RoomCodeCard(code: room.code, t: t),
                      ),
                      const SizedBox(height: 14),
                      RiseIn(
                        delayMs: 60,
                        child: RoomSettingsCard(room: room, isHost: isHost),
                      ),
                      const SizedBox(height: 12),
                      RiseIn(
                        delayMs: 120,
                        child: PremiumCard(room: room, isHost: isHost),
                      ),
                      const SizedBox(height: 26),

                      players.when(
                        loading: () =>
                            Text(t('common.loading'), style: text.bodySmall),
                        error: (e, _) => Text(
                          '$e',
                          style: text.bodySmall?.copyWith(
                            color: JoyoColors.coral,
                          ),
                        ),
                        data: (list) => Row(
                          children: [
                            Eyebrow(t('lobby.players')),
                            const Spacer(),
                            Text(
                              '${list.length}/10',
                              style: text.labelSmall?.copyWith(
                                color: JoyoColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...players.when(
                        loading: () => const [
                          Center(
                            child: CircularProgressIndicator(
                              color: JoyoColors.lime,
                            ),
                          ),
                        ],
                        error: (_, _) => const <Widget>[],
                        data: (list) => [
                          for (final player in list)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _PlayerRow(
                                player: player,
                                isMe: player.id == session?.playerId,
                                t: t,
                                // l'host può rimuovere chi è rimasto appeso
                                onRemove:
                                    isHost && player.id != session?.playerId
                                    ? () => _removePlayer(context, ref, player)
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                if (isHost)
                  JoyoButton(
                    label: t('lobby.pick_game'),
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => _pickGame(context, ref),
                  )
                else
                  GlowCard(
                    accent: JoyoColors.violet,
                    glow: 0.3,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: Text(
                        t('lobby.waiting_host'),
                        style: text.bodyMedium?.copyWith(
                          color: JoyoColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _removePlayer(
    BuildContext context,
    WidgetRef ref,
    Player player,
  ) async {
    final t = ref.read(tProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: JoyoColors.surfaceHigh,
        title: Text(t('lobby.remove_player', {'name': player.name})),
        content: Text(t('lobby.remove_player_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t('common.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(t('lobby.remove')),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(roomRepositoryProvider).leaveRoom(player.id);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _pickGame(BuildContext context, WidgetRef ref) async {
    final t = ref.read(tProvider);
    final game = await showModalBottomSheet<GameDefinition>(
      context: context,
      backgroundColor: JoyoColors.surface,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _GamePicker(t: t),
    );
    if (game == null || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(roomRepositoryProvider)
          .startGame(roomId: room.id, gameType: game.id);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

/// Il codice della stanza: l'elemento più letto ad alta voce dell'app, quindi
/// il più grande e l'unico con l'alone pieno.
class _RoomCodeCard extends StatelessWidget {
  const _RoomCodeCard({required this.code, required this.t});

  final String code;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return GlowCard(
      accent: JoyoColors.lime,
      glow: 1.9,
      borderWidth: 2,
      padding: const EdgeInsets.symmetric(vertical: 24),
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t('lobby.code_copied'))));
      },
      child: Shimmer(
        color: JoyoColors.lime,
        child: Column(
          children: [
            Eyebrow(t('lobby.code_label')),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  code,
                  maxLines: 1,
                  style: text.displayLarge?.copyWith(
                    color: JoyoColors.lime,
                    letterSpacing: 8,
                    fontSize: 58,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t('lobby.code_hint'),
              style: text.bodySmall?.copyWith(
                color: JoyoColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.player,
    required this.isMe,
    required this.t,
    this.onRemove,
  });

  final Player player;
  final bool isMe;
  final Translator t;

  /// Valorizzata solo per l'host, sugli altri giocatori.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = JoyoColors.avatar(player.color);

    return GlowCard(
      accent: color,
      glow: isMe ? 0.8 : 0,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          PlayerAvatar(player: player),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isMe ? '${player.name} (${t('lobby.you')})' : player.name,
              style: text.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (player.isHost)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: JoyoColors.surfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                t('lobby.host_badge'),
                style: text.labelSmall?.copyWith(color: JoyoColors.lime),
              ),
            ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.person_remove_rounded, size: 20),
              color: JoyoColors.textSecondary,
              tooltip: t('lobby.remove'),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}

class _GamePicker extends StatelessWidget {
  const _GamePicker({required this.t});

  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('lobby.which_game'), style: text.headlineMedium),
            const SizedBox(height: 16),
            for (final game in GameCatalog.all)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GlowCard(
                  accent: game.color,
                  glow: 0.6,
                  radius: 22,
                  onTap: () => Navigator.of(context).pop(game),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 58,
                        height: 58,
                        child: GameArt(gameId: game.id, color: game.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t(game.nameKey), style: text.titleMedium),
                            Text(
                              t(game.taglineKey),
                              style: text.bodySmall?.copyWith(
                                color: JoyoColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
