import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../room/data/models/player.dart';

/// Nome + pallino colorato: si usa ovunque si mostri "chi ha votato cosa".
class PlayerChip extends StatelessWidget {
  const PlayerChip({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final color = JoyoColors.avatar(player.color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: JoyoColors.surfaceHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(player.name, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Cerchio con l'iniziale, per le liste di giocatori.
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({required this.player, this.size = 42, super.key});

  final Player player;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: JoyoColors.avatar(player.color),
        shape: BoxShape.circle,
      ),
      child: Text(
        player.initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: JoyoColors.background,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}
