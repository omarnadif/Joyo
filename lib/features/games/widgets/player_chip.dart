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
    final line = (size * 0.035).clamp(1.0, 2.5); // spessore dei bordi neri
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(ring),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        // Bordo esterno sempre nero. La selezione si legge dall'alone e dallo
        // scale, non dal colore del bordo.
        border: Border.all(color: Colors.black, width: line),
        boxShadow: selected
            ? [
                // Alone bianco per staccare dal viola dello sfondo, più un
                // secondo alone col colore dell'avatar per dargli energia.
                BoxShadow(
                  color: JoyoColors.textPrimary.withValues(alpha: 0.45),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.65),
                  blurRadius: 26,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      // Bordo interno nero fra l'anello colorato e il volto.
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: line),
        ),
        child: ClipOval(
          child: SvgPicture.asset(
            AvatarCatalog.asset(avatar),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
