import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/avatar_catalog.dart';
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

/// Avatar illustrato del giocatore: disco chiaro con l'SVG, cerchiato dal
/// colore scelto. Il colore resta il marker d'identità, l'avatar dà la faccia.
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({required this.player, this.size = 42, super.key});

  final Player player;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AvatarCircle(
      avatar: player.avatar,
      color: JoyoColors.avatar(player.color),
      size: size,
    );
  }
}

/// Renderer avatar riutilizzabile (usato anche dal picker della join, dove non
/// esiste ancora un Player). Anello = colore, disco chiaro = sfondo del volto.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    required this.avatar,
    required this.color,
    this.size = 42,
    this.selected = false,
    super.key,
  });

  final String avatar;
  final Color color;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ring = (size * 0.09).clamp(2.0, 5.0);
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(ring),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: selected
            ? Border.all(color: JoyoColors.textPrimary, width: 3)
            : null,
        boxShadow: selected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 22,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          AvatarCatalog.asset(avatar),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
