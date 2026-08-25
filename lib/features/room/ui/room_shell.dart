import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../games/game_stage_screen.dart';
import '../data/models/room.dart';
import '../state/room_providers.dart';
import 'lobby_screen.dart';

/// Contenitore della stanza: sceglie la schermata da `rooms.status`, così i
/// telefoni restano allineati senza navigazione manuale.
class RoomShell extends ConsumerWidget {
  const RoomShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final session = ref.watch(roomSessionProvider);
    if (session == null) return _Message(text: t('common.loading'));

    final roomAsync = ref.watch(roomProvider(session.roomId));
    final playersAsync = ref.watch(playersProvider(session.roomId));

    // Primo caricamento: qui lo spinner ha senso.
    if (!roomAsync.hasValue) {
      if (roomAsync.hasError) {
        return _Message(
          text: '${t('error.connection')}\n${roomAsync.error}',
          action: (
            label: t('common.back_home'),
            onPressed: () => goHome(context, ref),
          ),
        );
      }
      return _Message(text: t('lobby.entering'), spinner: true);
    }

    final room = roomAsync.value;

    // La riga della stanza non c'è più: l'host l'ha chiusa.
    if (room == null) return _closed(context, ref, t);

    // Se la mia riga giocatore è sparita, la stanza è finita anche per me.
    final players = playersAsync.value;
    if (players != null &&
        !players.any((player) => player.id == session.playerId)) {
      return _closed(context, ref, t);
    }

    final screen = switch (room.status) {
      RoomStatus.lobby => LobbyScreen(room: room),
      RoomStatus.inGame || RoomStatus.finished => GameStageScreen(room: room),
    };

    // In riconnessione tengo i dati con un avviso, senza spinner a tutto schermo.
    final reconnecting = roomAsync.isLoading || roomAsync.hasError;

    final isHost = ref.watch(isHostProvider(session.roomId));

    // Il back di sistema deve passare da exitRoom, o resta un giocatore fantasma.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        confirmExitRoom(context, ref, isHost: isHost, roomId: room.id);
      },
      child: Stack(
        children: [
          screen,
          if (reconnecting)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ReconnectBanner(),
            ),
        ],
      ),
    );
  }

  Widget _closed(BuildContext context, WidgetRef ref, Translator t) => _Message(
    text: t('lobby.room_closed'),
    action: (
      label: t('common.back_home'),
      onPressed: () => goHome(context, ref),
    ),
  );
}

/// Torna alla home senza toccare il database (la stanza potrebbe non esserci più).
Future<void> goHome(BuildContext context, WidgetRef ref) async {
  final navigator = Navigator.of(context);
  ref.read(roomSessionProvider.notifier).exit();
  navigator.popUntil((route) => route.isFirst);
}

/// Esce dalla stanza (l'host la chiude per tutti); se la scrittura fallisce
/// l'utente va avvisato, o resta fantasma nella lista degli altri.
Future<void> exitRoom(
  BuildContext context,
  WidgetRef ref, {
  required bool asHost,
  required String roomId,
}) async {
  final session = ref.read(roomSessionProvider);
  final t = ref.read(tProvider);
  final messenger = ScaffoldMessenger.of(context);
  final repo = ref.read(roomRepositoryProvider);

  try {
    if (asHost) {
      await repo.closeRoom(roomId);
    } else if (session != null) {
      await repo.leaveRoom(session.playerId);
    }
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(t('lobby.exit_failed', {'detail': '$e'}))),
    );
    return;
  }

  if (context.mounted) await goHome(context, ref);
}

/// Chiede conferma e poi esce; il significato di "esci" cambia se sei l'host.
Future<void> confirmExitRoom(
  BuildContext context,
  WidgetRef ref, {
  required bool isHost,
  required String roomId,
}) async {
  final t = ref.read(tProvider);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: JoyoColors.surfaceHigh,
      title: Text(t(isHost ? 'lobby.exit_host_title' : 'lobby.exit_title')),
      content: Text(t(isHost ? 'lobby.exit_host_body' : 'lobby.exit_body')),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t('lobby.stay')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(t(isHost ? 'lobby.close' : 'lobby.leave')),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    await exitRoom(context, ref, asHost: isHost, roomId: roomId);
  }
}

typedef _Action = ({String label, VoidCallback onPressed});

class _ReconnectBanner extends StatelessWidget {
  const _ReconnectBanner();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: JoyoColors.surfaceHigh,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: JoyoColors.amber,
              ),
            ),
            const SizedBox(width: 10),
            Consumer(
              builder: (context, ref, _) => Text(
                ref.watch(tProvider)('lobby.reconnecting'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.spinner = false, this.action});

  final String text;
  final bool spinner;
  final _Action? action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (spinner) ...[
                const CircularProgressIndicator(color: JoyoColors.lime),
                const SizedBox(height: 24),
              ],
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (action != null) ...[
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: action!.onPressed,
                  child: Text(action!.label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
