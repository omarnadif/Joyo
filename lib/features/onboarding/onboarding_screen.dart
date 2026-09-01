import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/sound_service.dart';
import '../../core/haptics/haptics_service.dart';
import '../../core/i18n/app_locale.dart';
import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/aura.dart';
import '../../core/ui/game_art.dart';
import '../../core/ui/joyo_ui.dart';
import '../games/game_catalog.dart';
import '../games/game_mode.dart';
import '../home/home_screen.dart' show showLanguagePicker;
import 'onboarding_state.dart';

/// Presentazione iniziale: quattro schermate che spiegano Joyo in dieci secondi,
/// più la scelta della lingua; ogni scena si muove più lentamente del testo per dare profondità.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  double _page = 0;
  int _lastIndex = 0;

  static const _accents = [
    JoyoColors.violet,
    JoyoColors.lime,
    JoyoColors.sky,
    JoyoColors.coral,
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final page = _controller.page ?? 0;
      setState(() => _page = page);
      // Un fruscio a ogni pagina superata, come sfogliando delle carte.
      final index = page.round();
      if (index != _lastIndex) {
        _lastIndex = index;
        ref.read(soundServiceProvider).play(Sfx.swish);
        ref.read(hapticsServiceProvider).fire(Haptic.selection);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _index => _page.round().clamp(0, 3);

  Color get _accent {
    final low = _accents[_page.floor().clamp(0, 3)];
    final high = _accents[_page.ceil().clamp(0, 3)];
    return Color.lerp(low, high, _page - _page.floor()) ?? low;
  }

  Future<void> _finish() async {
    await ref.read(onboardingProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(tProvider);
    final locale = ref.watch(localeProvider);
    final isLast = _index == 3;

    return Aura(
      color: _accent,
      secondary: JoyoColors.violet,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    GlowCard(
                      accent: JoyoColors.violet,
                      glow: 0.3,
                      radius: 14,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      onTap: () => showLanguagePicker(context, ref),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            locale.flag,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            locale.code.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        t('onboarding.skip'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: JoyoColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    // Distanza dalla pagina corrente: la scena si muove meno del testo, il testo meno del dito.
                    final delta = _page - index;
                    return _Slide(
                      index: index,
                      delta: delta,
                      accent: _accents[index],
                      title: t('onboarding.slide${index + 1}.title'),
                      body: t('onboarding.slide${index + 1}.body'),
                      t: t,
                    );
                  },
                ),
              ),

              if (isLast)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Column(
                    children: [
                      Eyebrow(t('onboarding.language')),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 46,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: AppLocale.values.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final option = AppLocale.values[i];
                            final selected = option == locale;
                            return GlowCard(
                              accent: selected
                                  ? JoyoColors.lime
                                  : JoyoColors.surfaceHigh,
                              glow: selected ? 1.1 : 0,
                              radius: 16,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              onTap: () =>
                                  ref.read(localeProvider.notifier).set(option),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      option.flag,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      option.label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Column(
                  children: [
                    _Dots(page: _page, accent: _accent),
                    const SizedBox(height: 18),
                    JoyoButton(
                      label: isLast
                          ? t('onboarding.start')
                          : t('common.continue'),
                      accent: isLast ? JoyoColors.lime : _accent,
                      onPressed: isLast
                          ? _finish
                          : () => _controller.nextPage(
                              duration: const Duration(milliseconds: 420),
                              curve: Curves.easeOutCubic,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.index,
    required this.delta,
    required this.accent,
    required this.title,
    required this.body,
    required this.t,
  });

  final int index;
  final double delta;
  final Color accent;
  final String title;
  final String body;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Il testo resta ancorato in basso così le quattro slide hanno lo stesso ritmo anche con titoli di lunghezza diversa.
          Expanded(
            child: Align(
              // La scena si appoggia sopra al titolo invece di galleggiare a metà, lasciando l'aria in alto.
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(delta * -60, 0),
                child: Opacity(
                  opacity: (1 - delta.abs()).clamp(0.0, 1.0),
                  child: SizedBox(
                    height: 300,
                    child: _Scene(index: index, accent: accent, t: t),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Transform.translate(
            offset: Offset(delta * -110, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.displayMedium?.copyWith(
                    fontSize: 34,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  body,
                  style: text.bodyLarge?.copyWith(
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Le quattro scene, costruite con gli stessi elementi dell'app invece che con illustrazioni.
class _Scene extends StatelessWidget {
  const _Scene({required this.index, required this.accent, required this.t});

  final int index;
  final Color accent;
  final Translator t;

  @override
  Widget build(BuildContext context) => switch (index) {
    0 => const _PhonesScene(),
    1 => const _CodeScene(),
    2 => const _GamesScene(),
    _ => _ModesScene(t: t),
  };
}

/// Tre telefoni accesi attorno a un tavolo.
class _PhonesScene extends StatelessWidget {
  const _PhonesScene();

  @override
  Widget build(BuildContext context) {
    const colors = [JoyoColors.lime, JoyoColors.coral, JoyoColors.sky];

    return Center(
      child: SizedBox(
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < 3; i++)
              Transform.translate(
                offset: Offset((i - 1) * 78, (i == 1 ? -14 : 10).toDouble()),
                child: Transform.rotate(
                  angle: (i - 1) * 0.16,
                  child: Container(
                    width: 84,
                    height: 158,
                    decoration: BoxDecoration(
                      color: JoyoColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colors[i].withValues(alpha: 0.55),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors[i].withValues(alpha: 0.35),
                          blurRadius: 36,
                          spreadRadius: -6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: colors[i].withValues(alpha: 0.75),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors[i].withValues(alpha: 0.5),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 44,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colors[i],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Il codice stanza, come si vedrà in lobby.
class _CodeScene extends StatelessWidget {
  const _CodeScene();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlowCard(
        accent: JoyoColors.lime,
        glow: 1.8,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Eyebrow('JOYO'),
            const SizedBox(height: 10),
            Text(
              'K7QP2M',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: JoyoColors.lime,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// I sei giochi, disposti come nella home.
class _GamesScene extends StatelessWidget {
  const _GamesScene();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // tre per riga: due file uguali invece di 4 + 2
        width: 262,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final game in GameCatalog.all)
              GlowCard(
                accent: game.color,
                glow: 0.8,
                radius: 20,
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  width: 74,
                  height: 74,
                  child: GameArt(gameId: game.id, color: game.color),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Le tre modalità, con la temperatura che sale.
class _ModesScene extends StatelessWidget {
  const _ModesScene({required this.t});

  final Translator t;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final mode in GameMode.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlowCard(
                accent: mode.color,
                glow: mode == GameMode.hot ? 1.6 : 0.7,
                radius: 20,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(mode.icon, color: mode.color, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      t('mode.${mode.id}'),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: mode.color),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Indicatore di pagina: il trattino attivo si allunga invece di accendersi.
class _Dots extends StatelessWidget {
  const _Dots({required this.page, required this.accent});

  final double page;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 8 + 22 * max(0, 1 - (page - i).abs()),
              height: 6,
              decoration: BoxDecoration(
                color: Color.lerp(
                  JoyoColors.surfaceHigh,
                  accent,
                  max(0, 1 - (page - i).abs()),
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
      ],
    );
  }
}
