import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics/haptics_service.dart';
import '../../core/i18n/app_locale.dart';
import '../../core/i18n/i18n.dart';
import '../../core/supabase/supabase_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/aura.dart';
import '../../core/ui/game_art.dart';
import '../../core/ui/joyo_ui.dart';
import '../diagnostics/diagnostics_screen.dart';
import '../games/game_catalog.dart';
import '../premium/entitlements.dart';
import '../premium/premium_promo_dialog.dart';
import '../premium/shop_screen.dart';
import '../room/ui/join_flow_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowPromo());
  }

  /// Propone l'abbonamento all'apertura, una sola volta per avvio e solo a chi
  /// non è già premium. Aspetta che i diritti siano letti dal server, così la
  /// finestra non lampeggia per un abbonato.
  Future<void> _maybeShowPromo() async {
    if (ref.read(premiumPromoShownProvider)) return;
    try {
      await ref.read(entitlementsProvider.future);
    } catch (_) {
      // Se i diritti non si caricano, meglio non insistere col promo.
      return;
    }
    if (!mounted) return;
    if (ref.read(premiumPromoShownProvider)) return;
    if (ref.read(hasPremiumProvider)) return;
    ref.read(premiumPromoShownProvider.notifier).markShown();
    await showPremiumPromo(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    // Il login anonimo parte all'apertura così la sessione è già pronta quando si preme "Crea stanza".
    final session = ref.watch(anonSessionProvider);

    return Aura(
      color: JoyoColors.violet,
      secondary: JoyoColors.lime,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const _ShopButton(),
                  const SizedBox(width: 10),
                  _LanguageChip(t: t),
                ],
              ),
              const SizedBox(height: 8),
              RiseIn(child: _Wordmark(t: t)),
              const SizedBox(height: 34),

              // I bottoni restano premibili durante il login anonimo, altrimenti su rete lenta la home sembrerebbe rotta.
              RiseIn(
                delayMs: 80,
                child: JoyoButton(
                  label: t('home.create'),
                  icon: Icons.add_rounded,
                  onPressed: () => _open(context, JoinFlowMode.create),
                ),
              ),
              const SizedBox(height: 12),
              RiseIn(
                delayMs: 140,
                child: JoyoGhostButton(
                  label: t('home.join'),
                  onPressed: () => _open(context, JoinFlowMode.join),
                ),
              ),

              if (session.hasError) ...[
                const SizedBox(height: 16),
                Text(
                  t('home.connection_failed'),
                  style: text.bodySmall?.copyWith(color: JoyoColors.coral),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(anonSessionProvider),
                  child: Text(t('common.retry')),
                ),
              ],

              const SizedBox(height: 40),
              Eyebrow(t('home.games')),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
                children: [
                  for (var i = 0; i < GameCatalog.all.length; i++)
                    RiseIn(
                      delayMs: 120 + i * 60,
                      child: _GameTile(game: GameCatalog.all[i], t: t),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, JoinFlowMode mode) {
    ref.read(hapticsServiceProvider).fire(Haptic.light);
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => JoinFlowScreen(mode: mode)));
  }
}

/// Il marchio della home; tenendolo premuto si apre la diagnostica di connessione.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.t});

  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onLongPress: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DiagnosticsScreen()),
          ),
          child: const _BrandMark(),
        ),
        const SizedBox(height: 6),
        Text(
          t('app.tagline'),
          style: text.titleMedium?.copyWith(
            color: JoyoColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

/// proporzioni del file assets/brand/wordmark.png
const double _markAspect = 780 / 361;

/// Compensa il margine trasparente attorno alle lettere, che altrimenti farebbe partire la J rientrata rispetto al testo.
const double _markInset = 0.054;

/// La scritta Joyo al neon, che respira sull'insegna stessa perché il file si somma allo sfondo senza lasciare una macchia di colore.
class _BrandMark extends StatefulWidget {
  const _BrandMark();

  @override
  State<_BrandMark> createState() => _BrandMarkState();
}

class _BrandMarkState extends State<_BrandMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Il riquadro va allargato per compensare il margine trasparente e lasciare le lettere della stessa misura.
        final width = math.min(268.0, constraints.maxWidth * 0.84);

        return Transform.translate(
          offset: Offset(-width * _markInset, 0),
          child: SizedBox(
            width: width,
            height: width / _markAspect,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = still
                    ? 0.5
                    : Curves.easeInOut.transform(_controller.value);
                return Opacity(opacity: 0.86 + 0.14 * t, child: child);
              },
              child: Image.asset(
                'assets/brand/wordmark.png',
                fit: BoxFit.contain,
                semanticLabel: 'Joyo',
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pillola shop in home: stesso stile della lingua, con un carrello.
class _ShopButton extends StatelessWidget {
  const _ShopButton();

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      accent: JoyoColors.violet,
      glow: 0.4,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onTap: () => openShop(context),
      child: const Icon(
        Icons.shopping_cart_rounded,
        size: 18,
        color: JoyoColors.textSecondary,
      ),
    );
  }
}

class _LanguageChip extends ConsumerWidget {
  const _LanguageChip({required this.t});

  final Translator t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return GlowCard(
      accent: JoyoColors.violet,
      glow: 0.4,
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      onTap: () => showLanguagePicker(context, ref),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(locale.flag, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            locale.code.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.expand_more_rounded,
            size: 16,
            color: JoyoColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// Scelta della lingua, raggiungibile dalla home e dall'onboarding.
Future<void> showLanguagePicker(BuildContext context, WidgetRef ref) async {
  final t = ref.read(tProvider);
  final current = ref.read(localeProvider);

  final chosen = await showModalBottomSheet<AppLocale>(
    context: context,
    backgroundColor: JoyoColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('home.language'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            for (final locale in AppLocale.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LanguageRow(
                  locale: locale,
                  selected: locale == current,
                  onTap: () => Navigator.of(context).pop(locale),
                ),
              ),
          ],
        ),
      ),
    ),
  );

  if (chosen != null) await ref.read(localeProvider.notifier).set(chosen);
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  final AppLocale locale;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      accent: selected ? JoyoColors.lime : JoyoColors.surfaceHigh,
      glow: selected ? 1.2 : 0,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Text(locale.flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              locale.label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle_rounded, color: JoyoColors.lime),
        ],
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({required this.game, required this.t});

  final GameDefinition game;
  final Translator t;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return GlowCard(
      accent: game.color,
      glow: 0.7,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              child: GameArt(gameId: game.id, color: game.color),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(game.nameKey),
                  style: text.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  t(game.taglineKey),
                  style: text.bodySmall?.copyWith(
                    color: JoyoColors.textSecondary,
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
