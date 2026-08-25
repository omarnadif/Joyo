import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Lo sfondo di Joyo: due aloni di luce che si muovono lentamente dietro il
/// contenuto, del colore del gioco attivo, così l'ambiente segnala il gioco in corso.
class Aura extends StatefulWidget {
  const Aura({
    required this.child,
    this.color = JoyoColors.violet,
    this.secondary,
    this.intensity = 1,
    super.key,
  });

  final Widget child;
  final Color color;
  final Color? secondary;

  /// 0 = spenta, 1 = normale. Più alta nelle schermate di festa (podio).
  final double intensity;

  @override
  State<Aura> createState() => _AuraState();
}

class _AuraState extends State<Aura> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final secondary = widget.secondary ?? JoyoColors.violet;

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: JoyoColors.background)),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = reduceMotion ? 0.25 : _controller.value;
              return CustomPaint(
                painter: _AuraPainter(
                  progress: t,
                  primary: widget.color,
                  secondary: secondary,
                  intensity: widget.intensity,
                ),
              );
            },
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _AuraPainter extends CustomPainter {
  const _AuraPainter({
    required this.progress,
    required this.primary,
    required this.secondary,
    required this.intensity,
  });

  final double progress;
  final Color primary;
  final Color secondary;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final angle = progress * 2 * pi;

    void blob(Color color, Offset center, double radius, double alpha) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: alpha * intensity),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    blob(
      primary,
      Offset(
        size.width * (0.22 + 0.10 * cos(angle)),
        size.height * (0.16 + 0.05 * sin(angle)),
      ),
      size.width * 0.85,
      0.30,
    );
    blob(
      secondary,
      Offset(
        size.width * (0.86 + 0.08 * sin(angle * 0.8)),
        size.height * (0.74 + 0.06 * cos(angle * 0.8)),
      ),
      size.width * 0.75,
      0.22,
    );

    // Vignettatura: i bordi restano scuri per dare profondità e portare l'occhio al centro.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            JoyoColors.background.withValues(alpha: 0),
            JoyoColors.background.withValues(alpha: 0.55),
          ],
          stops: const [0.55, 1],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant _AuraPainter old) =>
      old.progress != progress ||
      old.primary != primary ||
      old.secondary != secondary ||
      old.intensity != intensity;
}
