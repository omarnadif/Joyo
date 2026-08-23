import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Coriandoli: si sparano una volta sola, all'apertura del podio.
///
/// È l'unico momento in cui l'app si permette di festeggiare, quindi vale la
/// pena farlo bene: pezzi che ruotano, cadono con gravità e svaniscono, nei
/// colori degli avatar.
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  static const int _pieceCount = 90;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  late final List<_Piece> _pieces;

  @override
  void initState() {
    super.initState();
    final random = Random();
    final colors = JoyoColors.avatarPalette.values.toList();
    _pieces = [
      for (var i = 0; i < Confetti._pieceCount; i++)
        _Piece(
          origin: Offset(0.5 + (random.nextDouble() - 0.5) * 0.25, 0.42),
          velocity: Offset(
            (random.nextDouble() - 0.5) * 1.7,
            -0.9 - random.nextDouble() * 0.8,
          ),
          color: colors[random.nextInt(colors.length)],
          size: 4 + random.nextDouble() * 7,
          spin: (random.nextDouble() - 0.5) * 10,
          delay: random.nextDouble() * 0.18,
        ),
    ];
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return const SizedBox.shrink();

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ConfettiPainter(_pieces, _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _Piece {
  const _Piece({
    required this.origin,
    required this.velocity,
    required this.color,
    required this.size,
    required this.spin,
    required this.delay,
  });

  /// In frazioni della schermata, così funziona a ogni dimensione.
  final Offset origin;
  final Offset velocity;
  final Color color;
  final double size;
  final double spin;
  final double delay;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.pieces, this.progress);

  final List<_Piece> pieces;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final t = ((progress - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      // parabola: spinta iniziale e poi gravità
      final dx = piece.velocity.dx * t;
      final dy = piece.velocity.dy * t + 1.9 * t * t;
      final position = Offset(
        (piece.origin.dx + dx) * size.width,
        (piece.origin.dy + dy) * size.height,
      );
      if (position.dy > size.height + 40) continue;

      final opacity = t < 0.75 ? 1.0 : (1 - (t - 0.75) / 0.25);

      canvas
        ..save()
        ..translate(position.dx, position.dy)
        ..rotate(piece.spin * t)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: piece.size,
              height: piece.size * 0.5,
            ),
            const Radius.circular(1.5),
          ),
          Paint()..color = piece.color.withValues(alpha: opacity.clamp(0, 1)),
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
