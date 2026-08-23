import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../theme/app_colors.dart';

/// Illustrazione di un gioco, disegnata a mano con le primitive di Flutter.
///
/// Niente immagini raster: sono forme che emettono luce come il resto
/// dell'interfaccia, si adattano a qualsiasi dimensione senza sfocarsi,
/// pesano zero e funzionano offline. Un file PNG scaricato da uno stock
/// avrebbe uno stile diverso da tutto il resto e andrebbe rifatto a ogni
/// cambio di palette.
class GameArt extends StatelessWidget {
  const GameArt({required this.gameId, this.color, super.key});

  /// Giochi che hanno un'illustrazione vera in `assets/games/`.
  /// Gli altri usano il disegno vettoriale qui sotto, quindi si possono
  /// aggiungere una alla volta senza che nulla resti scoperto.
  static const Map<String, String> artwork = <String, String>{
    'preferisci': 'assets/games/preferisci.png',
    'non_ho_mai': 'assets/games/non_ho_mai.png',
    'chi_lo_potrebbe_fare': 'assets/games/chi_lo_potrebbe_fare.png',
    'obbligo_o_verita': 'assets/games/obbligo_o_verita.png',
    'bluff_story': 'assets/games/bluff_story.png',
    'impostore': 'assets/games/impostore.png',
  };

  final String gameId;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final asset = artwork[gameId];
    if (asset != null) {
      // Le illustrazioni hanno il fondo nero: in modalità screen il nero
      // sparisce e resta solo il neon sopra al viola della card, senza il
      // rettangolo scuro che si vedrebbe con un disegno normale.
      return _BlendMask(
        blendMode: BlendMode.screen,
        // Le illustrazioni hanno un margine nero attorno: senza questa
        // scalatura risulterebbero più piccole dei disegni vettoriali degli
        // altri giochi, e le card sembrerebbero disallineate.
        child: Transform.scale(
          scale: 1.16,
          child: Image.asset(asset, fit: BoxFit.contain),
        ),
      );
    }

    return CustomPaint(
      painter: _painterFor(gameId, color),
      size: Size.infinite,
    );
  }

  static CustomPainter _painterFor(String id, Color? color) => switch (id) {
    'preferisci' => _PreferisciArt(color ?? JoyoColors.lime),
    'non_ho_mai' => _NonHoMaiArt(color ?? JoyoColors.coral),
    'chi_lo_potrebbe_fare' => _ChiArt(color ?? JoyoColors.sky),
    'obbligo_o_verita' => _BottigliaArt(color ?? JoyoColors.aqua),
    'bluff_story' => _BluffArt(color ?? JoyoColors.amber),
    _ => _ImpostoreArt(color ?? JoyoColors.magenta),
  };
}

/// Disegna il figlio su un livello a sé, fondendolo con quello che c'è sotto.
///
/// Serve per il blend "screen" sulle illustrazioni con fondo nero: Flutter non
/// permette di scegliere il blend di un'immagine rispetto allo sfondo senza
/// passare da un layer esplicito.
class _BlendMask extends SingleChildRenderObjectWidget {
  const _BlendMask({required this.blendMode, required Widget super.child});

  final BlendMode blendMode;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderBlendMask(blendMode);

  @override
  void updateRenderObject(BuildContext context, _RenderBlendMask renderObject) {
    renderObject.blendMode = blendMode;
  }
}

class _RenderBlendMask extends RenderProxyBox {
  _RenderBlendMask(this._blendMode);

  BlendMode _blendMode;

  set blendMode(BlendMode value) {
    if (_blendMode == value) return;
    _blendMode = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(offset & size, Paint()..blendMode = _blendMode);
    super.paint(context, offset);
    context.canvas.restore();
  }
}

// ---------------------------------------------------------------- strumenti

/// Alone morbido: è l'elemento che tiene insieme tutte le illustrazioni.
void _glow(
  Canvas canvas,
  Offset center,
  double radius,
  Color color,
  double alpha,
) {
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius)),
  );
}

Paint _stroke(Color color, double width, [double alpha = 1]) => Paint()
  ..color = color.withValues(alpha: alpha)
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

Paint _fill(Color color, [double alpha = 1]) =>
    Paint()..color = color.withValues(alpha: alpha);

// -------------------------------------------------------------- Preferisci

/// Un cerchio spaccato in due metà che si allontanano: la scelta secca.
class _PreferisciArt extends CustomPainter {
  const _PreferisciArt(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) * 0.30;

    _glow(canvas, c.translate(-r * 0.7, 0), r * 2.4, JoyoColors.lime, 0.30);
    _glow(canvas, c.translate(r * 0.7, 0), r * 2.4, JoyoColors.coral, 0.30);

    // le due metà, separate da un taglio netto
    void half(bool left, Color tint) {
      final shift = left ? -r * 0.16 : r * 0.16;
      final path = Path()
        ..addArc(
          Rect.fromCircle(center: c.translate(shift, 0), radius: r),
          left ? pi / 2 : -pi / 2,
          pi,
        )
        ..close();
      canvas
        ..drawPath(path, _fill(tint, 0.22))
        ..drawPath(path, _stroke(tint, 3));
    }

    half(true, JoyoColors.lime);
    half(false, JoyoColors.coral);

    // i due poli
    canvas
      ..drawCircle(c.translate(-r * 0.55, 0), 5, _fill(JoyoColors.lime))
      ..drawCircle(c.translate(r * 0.55, 0), 5, _fill(JoyoColors.coral));
  }

  @override
  bool shouldRepaint(covariant _PreferisciArt old) => old.color != color;
}

// --------------------------------------------------------------- Non ho mai

/// Un bicchiere alzato, con il liquido che brilla e le bollicine.
class _NonHoMaiArt extends CustomPainter {
  const _NonHoMaiArt(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final s = min(size.width, size.height);

    _glow(canvas, c.translate(0, -s * 0.06), s * 0.75, color, 0.32);

    final w = s * 0.34;
    final h = s * 0.30;
    final top = c.dy - h * 0.9;

    // coppa
    final cup = Path()
      ..moveTo(c.dx - w / 2, top)
      ..lineTo(c.dx + w / 2, top)
      ..lineTo(c.dx, top + h)
      ..close();
    canvas
      ..drawPath(cup, _fill(color, 0.18))
      ..drawPath(cup, _stroke(color, 3));

    // liquido
    final liquid = Path()
      ..moveTo(c.dx - w * 0.34, top + h * 0.32)
      ..lineTo(c.dx + w * 0.34, top + h * 0.32)
      ..lineTo(c.dx, top + h)
      ..close();
    canvas.drawPath(liquid, _fill(color, 0.55));

    // stelo e base
    canvas
      ..drawLine(
        Offset(c.dx, top + h),
        Offset(c.dx, top + h * 1.9),
        _stroke(color, 3),
      )
      ..drawLine(
        Offset(c.dx - w * 0.34, top + h * 1.9),
        Offset(c.dx + w * 0.34, top + h * 1.9),
        _stroke(color, 3),
      );

    // bollicine che salgono
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(c.dx + (i - 1) * w * 0.26, top - s * (0.06 + i * 0.05)),
        2.5 + i.toDouble(),
        _fill(color, 0.8 - i * 0.2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NonHoMaiArt old) => old.color != color;
}

// ------------------------------------------------- Chi lo potrebbe fare

/// Tre teste, un fascio di luce su quella scelta.
class _ChiArt extends CustomPainter {
  const _ChiArt(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final s = min(size.width, size.height);
    final r = s * 0.09;

    // fascio dall'alto sulla figura centrale
    final beam = Path()
      ..moveTo(c.dx - s * 0.06, 0)
      ..lineTo(c.dx + s * 0.06, 0)
      ..lineTo(c.dx + s * 0.22, c.dy + s * 0.24)
      ..lineTo(c.dx - s * 0.22, c.dy + s * 0.24)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.30), color.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    _glow(canvas, c, s * 0.5, color, 0.28);

    void figure(double dx, double scale, Color tint, double alpha) {
      final head = Offset(c.dx + dx, c.dy - r * 0.4);
      canvas
        ..drawCircle(head, r * scale, _fill(tint, alpha * 0.35))
        ..drawCircle(head, r * scale, _stroke(tint, 2.5, alpha));
      final body = Rect.fromLTWH(
        head.dx - r * scale * 1.25,
        head.dy + r * scale * 1.35,
        r * scale * 2.5,
        r * scale * 1.7,
      );
      final shoulders = Path()
        ..addArc(
          Rect.fromLTWH(body.left, body.top, body.width, body.height * 2),
          pi,
          pi,
        );
      canvas.drawPath(shoulders, _stroke(tint, 2.5, alpha));
    }

    figure(-s * 0.26, 0.85, JoyoColors.textSecondary, 0.55);
    figure(s * 0.26, 0.85, JoyoColors.textSecondary, 0.55);
    figure(0, 1.15, color, 1);
  }

  @override
  bool shouldRepaint(covariant _ChiArt old) => old.color != color;
}

// -------------------------------------------------------- Obbligo o Verità

/// La bottiglia, ferma a metà giro, con la scia della rotazione.
class _BottigliaArt extends CustomPainter {
  const _BottigliaArt(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final s = min(size.width, size.height);

    _glow(canvas, c, s * 0.55, color, 0.30);

    // scia circolare
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: s * 0.34),
      -pi * 0.9,
      pi * 1.3,
      false,
      _stroke(color, 3, 0.45),
    );
    for (var i = 0; i < 3; i++) {
      final a = -pi * 0.9 + pi * 1.3 * (0.72 + i * 0.09);
      canvas.drawCircle(
        c + Offset(cos(a), sin(a)) * s * 0.34,
        2.5 + i.toDouble(),
        _fill(color, 0.35 + i * 0.2),
      );
    }

    // bottiglia inclinata
    canvas
      ..save()
      ..translate(c.dx, c.dy)
      ..rotate(-0.5);

    final bodyW = s * 0.13;
    final bodyH = s * 0.26;
    final neckW = bodyW * 0.38;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(-bodyW / 2, -bodyH * 0.15, bodyW, bodyH),
      Radius.circular(bodyW * 0.36),
    );
    final neck = RRect.fromRectAndRadius(
      Rect.fromLTWH(-neckW / 2, -bodyH * 0.62, neckW, bodyH * 0.55),
      Radius.circular(neckW * 0.5),
    );

    canvas
      ..drawRRect(neck, _fill(color, 0.85))
      ..drawRRect(body, _fill(color, 0.85))
      ..drawCircle(
        Offset(0, -bodyH * 0.62),
        neckW * 0.62,
        _fill(JoyoColors.coral),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _BottigliaArt old) => old.color != color;
}

// ------------------------------------------------------------- Bluff Story

/// Tre carte a ventaglio: una sola è vera, e si vede da come brilla.
class _BluffArt extends CustomPainter {
  const _BluffArt(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final s = min(size.width, size.height);

    _glow(canvas, c.translate(0, -s * 0.02), s * 0.6, color, 0.30);

    final w = s * 0.26;
    final h = s * 0.36;

    void card(double angle, double dx, bool bright) {
      canvas
        ..save()
        ..translate(c.dx + dx, c.dy)
        ..rotate(angle);
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        Radius.circular(s * 0.045),
      );
      canvas
        ..drawRRect(
          rect,
          _fill(bright ? color : JoyoColors.surfaceHigh, bright ? 0.30 : 0.95),
        )
        ..drawRRect(
          rect,
          _stroke(
            bright ? color : JoyoColors.textSecondary,
            bright ? 3 : 2,
            bright ? 1 : 0.5,
          ),
        );
      // righe di testo accennate
      for (var i = 0; i < 3; i++) {
        final y = -h * 0.18 + i * h * 0.16;
        canvas.drawLine(
          Offset(-w * 0.28, y),
          Offset(w * (i == 2 ? 0.05 : 0.28), y),
          _stroke(
            bright ? color : JoyoColors.textSecondary,
            2,
            bright ? 0.9 : 0.35,
          ),
        );
      }
      canvas.restore();
    }

    card(-0.34, -s * 0.19, false);
    card(0.34, s * 0.19, false);
    card(0, 0, true);
  }

  @override
  bool shouldRepaint(covariant _BluffArt old) => old.color != color;
}

// --------------------------------------------------------------- Impostore

/// Un cerchio di giocatori illuminati e uno spento: l'intruso.
class _ImpostoreArt extends CustomPainter {
  const _ImpostoreArt(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final s = min(size.width, size.height);
    final ring = s * 0.28;

    _glow(canvas, c, s * 0.55, color, 0.26);

    canvas.drawCircle(c, ring, _stroke(JoyoColors.surfaceHigh, 2, 0.8));

    const count = 6;
    const impostor = 4;
    for (var i = 0; i < count; i++) {
      final a = -pi / 2 + 2 * pi * i / count;
      final p = c + Offset(cos(a), sin(a)) * ring;
      if (i == impostor) {
        // l'impostore: sagoma vuota, con l'ombra attorno
        canvas
          ..drawCircle(p, s * 0.075, _fill(JoyoColors.background))
          ..drawCircle(p, s * 0.075, _stroke(color, 3))
          ..drawLine(
            p.translate(-s * 0.035, s * 0.012),
            p.translate(s * 0.035, s * 0.012),
            _stroke(color, 3),
          );
      } else {
        canvas
          ..drawCircle(p, s * 0.062, _fill(JoyoColors.lime, 0.22))
          ..drawCircle(p, s * 0.062, _stroke(JoyoColors.lime, 2.5, 0.75));
      }
    }

    // punto di domanda al centro, ridotto a due segni
    canvas
      ..drawArc(
        Rect.fromCircle(center: c.translate(0, -s * 0.03), radius: s * 0.055),
        -pi,
        pi * 1.25,
        false,
        _stroke(color, 3.5),
      )
      ..drawCircle(c.translate(0, s * 0.085), 3.2, _fill(color));
  }

  @override
  bool shouldRepaint(covariant _ImpostoreArt old) => old.color != color;
}
