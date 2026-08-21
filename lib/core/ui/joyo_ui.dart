import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Superficie che emette luce invece di essere semplicemente stampata:
/// gradiente interno, bordo nel colore d'accento e un alone diffuso sotto.
class GlowCard extends StatelessWidget {
  const GlowCard({
    required this.child,
    this.accent = JoyoColors.violet,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
    this.glow = 1,
    this.borderWidth = 1.5,
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color accent;
  final EdgeInsets padding;
  final double radius;

  /// 0 = superficie piatta, 1 = alone normale, >1 per gli elementi in evidenza.
  final double glow;
  final double borderWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            JoyoColors.surface,
            Color.lerp(JoyoColors.surfaceHigh, accent, 0.10 * glow)!,
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: accent.withValues(alpha: 0.10 + 0.22 * glow),
          width: borderWidth,
        ),
        boxShadow: glow <= 0
            ? null
            : [
                BoxShadow(
                  color: accent.withValues(alpha: 0.16 * glow),
                  blurRadius: 34 * glow,
                  spreadRadius: -8,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: child,
    );

    if (onTap == null) return content;
    return _Pressable(onTap: onTap!, child: content);
  }
}

/// Pulsante principale: pieno del colore d'accento, con l'alone che lo fa
/// sembrare acceso.
class JoyoButton extends StatelessWidget {
  const JoyoButton({
    required this.label,
    required this.onPressed,
    this.accent = JoyoColors.lime,
    this.icon,
    this.busy = false,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color accent;
  final IconData? icon;
  final bool busy;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final text = Theme.of(context).textTheme;

    final button = AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: enabled ? 1 : 0.45,
      child: Container(
        height: 58,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, Color.lerp(accent, Colors.white, 0.18)!],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.38),
                    blurRadius: 26,
                    spreadRadius: -6,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  color: JoyoColors.background,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: JoyoColors.background),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelLarge?.copyWith(
                        color: JoyoColors.background,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );

    final sized = expand
        ? SizedBox(width: double.infinity, child: button)
        : button;
    return enabled ? _Pressable(onTap: onPressed, child: sized) : sized;
  }
}

/// Pulsante secondario: solo contorno, nessun alone.
class JoyoGhostButton extends StatelessWidget {
  const JoyoGhostButton({
    required this.label,
    required this.onPressed,
    this.accent = JoyoColors.textSecondary,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color accent;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = Container(
      height: 54,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.45), width: 1.6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: JoyoColors.textPrimary,
        ),
      ),
    );

    final sized = expand
        ? SizedBox(width: double.infinity, child: button)
        : button;
    return _Pressable(onTap: onPressed, child: sized);
  }
}

/// Punto luminoso che respira: è la "o" accesa del marchio Joyo.
class PulseDot extends StatefulWidget {
  const PulseDot({this.size = 16, this.color = JoyoColors.lime, super.key});

  final double size;
  final Color color;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = still ? 0.5 : Curves.easeInOut.transform(_controller.value);
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.45 + 0.35 * t),
                blurRadius: 16 + 14 * t,
                spreadRadius: 1 + 3 * t,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Riflesso che attraversa lentamente un elemento, come una luce che passa.
/// Usato solo sul codice stanza: serve a farlo notare, non a decorare.
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, this.color = Colors.white, super.key});

  final Widget child;
  final Color color;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // pausa lunga fra un passaggio e l'altro
        final t = (_controller.value * 2.6) - 0.8;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(t - 0.6, -0.4),
            end: Alignment(t + 0.6, 0.4),
            colors: [
              widget.color.withValues(alpha: 0),
              widget.color.withValues(alpha: 0.16),
              widget.color.withValues(alpha: 0),
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Etichetta piccola tutta maiuscola sopra i titoli: dà gerarchia senza
/// aggiungere un altro peso tipografico.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {this.color = JoyoColors.textSecondary, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
  );
}

/// Reazione al tocco: la superficie si abbassa leggermente. Un solo gesto,
/// uguale su tutta l'app.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _down = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Entrata scaglionata: gli elementi salgono uno dopo l'altro all'apertura
/// della schermata. Un solo momento di regia per pagina, niente animazioni
/// sparse ovunque.
class RiseIn extends StatelessWidget {
  const RiseIn({
    required this.child,
    this.delayMs = 0,
    this.offset = 18,
    super.key,
  });

  final Widget child;
  final int delayMs;
  final double offset;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delayMs),
      curve: Interval(
        (delayMs / (420 + delayMs)).clamp(0, 0.9),
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, value, child) => Opacity(
        opacity: value.clamp(0, 1),
        child: Transform.translate(
          offset: Offset(0, offset * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
