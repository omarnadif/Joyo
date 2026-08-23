import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/aura.dart';
import '../../room/state/room_providers.dart';
import '../../room/ui/room_shell.dart';

/// Cornice comune a tutte le schermate di gioco.
///
/// L'aurora di sfondo prende il colore del gioco: si capisce a cosa si sta
/// giocando dal colore della stanza, prima ancora di leggere il titolo.
class GameScaffold extends ConsumerWidget {
  const GameScaffold({
    required this.title,
    required this.child,
    this.subtitle,
    this.accent = JoyoColors.violet,
    this.overlay,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Color accent;

  /// Livello sopra al contenuto, per i momenti di festa (coriandoli).
  final Widget? overlay;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final session = ref.watch(roomSessionProvider);
    final roomId = session?.roomId;
    final isHost = roomId == null ? false : ref.watch(isHostProvider(roomId));

    return Aura(
      color: accent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            color: JoyoColors.textSecondary,
            tooltip: isHost ? t('lobby.close') : t('lobby.leave'),
            onPressed: roomId == null
                ? null
                : () => confirmExitRoom(
                    context,
                    ref,
                    isHost: isHost,
                    roomId: roomId,
                  ),
          ),
          title: Column(
            children: [
              Text(title, style: text.titleLarge?.copyWith(color: accent)),
              if (subtitle != null)
                Text(
                  subtitle!.toUpperCase(),
                  style: text.labelSmall?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
            ],
          ),
          actions: [
            if (isHost)
              TextButton(
                onPressed: () =>
                    ref.read(roomRepositoryProvider).backToLobby(roomId),
                child: Text(
                  t('game.lobby_short'),
                  style: text.labelSmall?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: child,
              ),
              if (overlay != null) Positioned.fill(child: overlay!),
            ],
          ),
        ),
      ),
    );
  }
}
