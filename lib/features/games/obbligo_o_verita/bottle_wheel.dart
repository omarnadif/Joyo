import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../room/data/models/player.dart';
import '../widgets/player_chip.dart';

/// La bottiglia che gira, con i giocatori disposti in cerchio.
///
/// Il risultato non viene deciso qui: arriva già scelto dentro il round, e
/// l'animazione si limita a fermarsi su quel nome. Stesso giocatore, stesso
/// numero di giri, stessa durata su ogni telefono.
class BottleWheel extends StatefulWidget {
  const BottleWheel({
    required this.players,
    required this.targetId,
    required this.turns,
    required this.onFinished,
    super.key,
  });

  static const Duration spinDuration = Duration(milliseconds: 3200);

  final List<Player> players;
  final String? targetId;
  final int turns;
  final VoidCallback onFinished;

  @override
  State<BottleWheel> createState() => _BottleWheelState();
}

class _BottleWheelState extends State<BottleWheel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: BottleWheel.spinDuration,
  );
  late final Animation<double> _spin = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onFinished();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = widget.players;
    final count = players.length;
    final targetIndex = players.indexWhere((p) => p.id == widget.targetId);
    final targetAngle = count == 0 || targetIndex < 0
        ? 0.0
        : 2 * pi * targetIndex / count;
    final finalAngle = 2 * pi * widget.turns + targetAngle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight)
            .clamp(220.0, 320.0);
        final radius = size / 2 - 26;

        final bottleHeight = size * 0.54;
        final bottleWidth = bottleHeight * 0.3;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // il tavolo: disco con luce dall'alto, così la bottiglia ci
              // appoggia sopra invece di galleggiare su una tinta piatta
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.35, -0.45),
                    radius: 1.1,
                    colors: [
                      JoyoColors.surfaceHigh,
                      JoyoColors.surface,
                      Color.lerp(JoyoColors.surface, Colors.black, 0.35)!,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                  border: Border.all(color: JoyoColors.surfaceHigh, width: 2),
                ),
              ),
              // ombra di contatto: non ruota, la luce resta ferma
              IgnorePointer(
                child: Container(
                  width: bottleHeight * 1.05,
                  height: bottleHeight * 1.05,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.32),
                        Colors.black.withValues(alpha: 0),
                      ],
                      stops: const [0.25, 1],
                    ),
                  ),
                ),
              ),
              // giocatori attorno
              for (var i = 0; i < count; i++)
                Transform.translate(
                  offset: Offset(
                    radius * sin(2 * pi * i / count),
                    -radius * cos(2 * pi * i / count),
                  ),
                  child: _Seat(
                    player: players[i],
                    highlighted: players[i].id == widget.targetId,
                    controller: _controller,
                  ),
                ),
              // bottiglia
              AnimatedBuilder(
                animation: _spin,
                builder: (context, child) => Transform.rotate(
                  angle: _spin.value * finalAngle,
                  child: child,
                ),
                child: CustomPaint(
                  size: Size(bottleWidth, bottleHeight),
                  painter: _BottlePainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Seat extends StatelessWidget {
  const _Seat({
    required this.player,
    required this.highlighted,
    required this.controller,
  });

  final Player player;
  final bool highlighted;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // il nome si accende solo quando la bottiglia si è fermata
        final done = controller.isCompleted;
        return Opacity(
          opacity: highlighted && done ? 1 : 0.55,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayerAvatar(player: player, size: highlighted && done ? 44 : 36),
              const SizedBox(height: 2),
              SizedBox(
                width: 66,
                child: Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bottiglia di vetro che punta verso l'alto quando l'angolo è zero.
///
/// È disegnata in 2D ma illuminata come un cilindro: il gradiente orizzontale
/// scurisce i bordi e schiarisce il centro, il riflesso verticale dà la
/// curvatura del vetro e il liquido con la superficie ellittica dà il volume.
/// La luce arriva da sinistra e ruota con la bottiglia, come un riflesso su
/// vetro lucido.
class _BottlePainter extends CustomPainter {
  static final Color _glassDark =
      Color.lerp(JoyoColors.lime, JoyoColors.background, 0.78)!;
  static final Color _glassMid =
      Color.lerp(JoyoColors.lime, JoyoColors.background, 0.42)!;
  static final Color _glassLight =
      Color.lerp(JoyoColors.lime, Colors.white, 0.2)!;
  static final Color _labelBase =
      Color.lerp(JoyoColors.textPrimary, JoyoColors.amber, 0.28)!;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = _silhouette(size);

    // ombra portata, sfalsata rispetto alla luce
    canvas.drawPath(
      body.shift(Offset(w * 0.16, h * 0.02)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.38)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.16),
    );

    // vetro: bordi scuri, centro acceso -> lettura cilindrica
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          colors: [_glassDark, _glassMid, _glassLight, _glassMid, _glassDark],
          stops: const [0, 0.2, 0.42, 0.68, 1],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    canvas.save();
    canvas.clipPath(body);
    _paintLiquid(canvas, size);
    _paintLabel(canvas, size);
    _paintBase(canvas, size);
    _paintHighlights(canvas, size);
    canvas.restore();

    // profilo, per staccare la bottiglia dal tavolo
    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.035
        ..color = Colors.black.withValues(alpha: 0.35),
    );

    _paintCap(canvas, size);
  }

  /// Sagoma della bottiglia: collo, spalla, corpo e fondo arrotondato.
  Path _silhouette(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final neckHalf = w * 0.17;
    final neckTop = h * 0.045;
    final shoulderTop = h * 0.3;
    final bodyTop = h * 0.45;
    final baseR = w * 0.26;

    return Path()
      ..moveTo(cx - neckHalf, neckTop)
      ..lineTo(cx - neckHalf, shoulderTop)
      ..cubicTo(
        cx - neckHalf,
        shoulderTop + (bodyTop - shoulderTop) * 0.62,
        0,
        shoulderTop + (bodyTop - shoulderTop) * 0.38,
        0,
        bodyTop,
      )
      ..lineTo(0, h - baseR)
      ..quadraticBezierTo(0, h, baseR, h)
      ..lineTo(w - baseR, h)
      ..quadraticBezierTo(w, h, w, h - baseR)
      ..lineTo(w, bodyTop)
      ..cubicTo(
        w,
        shoulderTop + (bodyTop - shoulderTop) * 0.38,
        cx + neckHalf,
        shoulderTop + (bodyTop - shoulderTop) * 0.62,
        cx + neckHalf,
        shoulderTop,
      )
      ..lineTo(cx + neckHalf, neckTop)
      ..close();
  }

  /// Liquido nel corpo: la superficie è un'ellisse, così si vede "dentro".
  /// Resta basso, altrimenti il vetro verde sparisce e la bottiglia sembra
  /// un oggetto pieno di colore.
  void _paintLiquid(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final top = h * 0.6;
    final rect = Rect.fromLTWH(0, top, w, h - top);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Color.lerp(JoyoColors.coral, Colors.black, 0.72)!,
            Color.lerp(JoyoColors.coral, Colors.black, 0.25)!,
            Color.lerp(JoyoColors.coral, Colors.black, 0.6)!,
          ],
          stops: const [0, 0.4, 1],
        ).createShader(rect),
    );
    // superficie del liquido vista di scorcio
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, top),
        width: w * 0.98,
        height: h * 0.045,
      ),
      Paint()
        ..color = Color.lerp(JoyoColors.coral, Colors.white, 0.28)!
            .withValues(alpha: 0.9),
    );
  }

  /// Fondo: vetro spesso, quindi scuro, con il filo di luce sul bordo.
  void _paintBase(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, h * 0.88, w, h * 0.12);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0),
            Colors.black.withValues(alpha: 0.8),
          ],
        ).createShader(rect),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.95),
        width: w * 0.86,
        height: h * 0.07,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.03
        ..color = Colors.white.withValues(alpha: 0.16),
    );
  }

  /// Etichetta: senza, la bottiglia legge come un cilindro colorato.
  void _paintLabel(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, h * 0.66, w, h * 0.24);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Color.lerp(_labelBase, Colors.black, 0.6)!,
            _labelBase,
            Color.lerp(_labelBase, Colors.black, 0.5)!,
          ],
          stops: const [0, 0.42, 1],
        ).createShader(rect),
    );
    // due righe di stampa, appena accennate
    for (final t in const [0.35, 0.62]) {
      canvas.drawRect(
        Rect.fromLTWH(
          w * 0.2,
          rect.top + rect.height * t,
          w * 0.6,
          h * 0.018,
        ),
        Paint()..color = JoyoColors.violet.withValues(alpha: 0.75),
      );
    }
  }

  /// Riflessi: la striscia speculare a sinistra e il rimbalzo sul bordo destro.
  void _paintHighlights(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.1, w * 0.13, h * 0.82),
        Radius.circular(w * 0.07),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.72),
            Colors.white.withValues(alpha: 0.15),
          ],
          stops: const [0, 0.35, 1],
        ).createShader(Rect.fromLTWH(w * 0.2, h * 0.1, w * 0.13, h * 0.82))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.05),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.82, h * 0.32, w * 0.07, h * 0.55),
        Radius.circular(w * 0.04),
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.06),
    );
  }

  /// Tappo e anello del collo, con la stessa luce del corpo.
  void _paintCap(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final capRect = Rect.fromCenter(
      center: Offset(w / 2, h * 0.055),
      width: w * 0.42,
      height: h * 0.09,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(capRect, Radius.circular(w * 0.08)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Color.lerp(JoyoColors.coral, Colors.black, 0.45)!,
            Color.lerp(JoyoColors.coral, Colors.white, 0.25)!,
            Color.lerp(JoyoColors.coral, Colors.black, 0.35)!,
          ],
          stops: const [0, 0.4, 1],
        ).createShader(capRect),
    );
    // anello sotto il tappo
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w / 2, h * 0.125),
          width: w * 0.4,
          height: h * 0.03,
        ),
        Radius.circular(w * 0.03),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.3),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
