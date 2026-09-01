import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/env/app_env.dart';
import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/aura.dart';
import '../../core/ui/joyo_ui.dart';
import 'ads/ads_service.dart';
import 'entitlements.dart';
import 'purchase_service.dart';

/// Apre la pagina Shop. È raggiungibile da ovunque (home compresa): tutto —
/// abbonamenti e sblocco con annunci — è legato all'account, non alla stanza.
Future<void> openShop(BuildContext context) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => const ShopScreen()),
);

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  bool _busy = false;

  // Google impone un punto di rientro alle opzioni privacy solo in EEA/UK:
  // altrove il link non compare.
  bool _privacyOptionsRequired = false;

  // Numero di annunci per sbloccare una partita.
  static const _adsPerGame = 3;

  static final _privacyPolicyUrl =
      Uri.parse('https://omarnadif.github.io/joyo-legal/privacy-policy/');
  static final _termsUrl =
      Uri.parse('https://omarnadif.github.io/joyo-legal/terms/');

  // Prezzi di riserva se lo store non risponde (in dev/desktop).
  static const _fallbackPrice = {
    AppEnv.noAdsProductId: '€1,99',
    AppEnv.premiumSubProductId: '€3,99',
  };
  final Map<String, String> _price = {};

  @override
  void initState() {
    super.initState();
    _loadPrices();
    ref.read(adsServiceProvider).isPrivacyOptionsRequired().then((required) {
      if (mounted && required) setState(() => _privacyOptionsRequired = true);
    });
  }

  Future<void> _loadPrices() async {
    final purchases = ref.read(purchaseServiceProvider);
    for (final id in const [
      AppEnv.noAdsProductId,
      AppEnv.premiumSubProductId,
    ]) {
      final product = await purchases.productById(id);
      if (product != null && mounted) {
        setState(() => _price[id] = product.price);
      }
    }
  }

  Future<void> _subscribe(String productId) async {
    setState(() => _busy = true);
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final purchases = ref.read(purchaseServiceProvider);
      if (!await purchases.isAvailable()) {
        messenger.showSnackBar(SnackBar(content: Text(t('premium.no_store'))));
        return;
      }
      final token = await purchases.buySubscription(productId);
      if (token == null || !mounted) return;
      final ok = await ref
          .read(entitlementsRepositoryProvider)
          .verify(productId: productId, purchaseToken: token);
      if (ok) await ref.read(entitlementsProvider.notifier).refresh();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(ok ? t('paywall.active') : t('common.retry'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() => _busy = true);
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final purchases = ref.read(purchaseServiceProvider);
      final repo = ref.read(entitlementsRepositoryProvider);
      final restored = await purchases.restoreSubscriptions(const {
        AppEnv.noAdsProductId,
        AppEnv.premiumSubProductId,
      });
      var any = false;
      for (final item in restored) {
        final ok = await repo.verify(
          productId: item.productId,
          purchaseToken: item.token,
        );
        any = any || ok;
      }
      if (any) await ref.read(entitlementsProvider.notifier).refresh();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            any ? t('paywall.restored') : t('paywall.nothing_restored'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _watchAd() async {
    setState(() => _busy = true);
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ads = ref.read(adsServiceProvider);
      if (!ads.isSupported) {
        messenger.showSnackBar(
          SnackBar(content: Text(t('premium.ads_mobile_only'))),
        );
        return;
      }
      final earned = await ads.showRewarded();
      if (!mounted) return;
      if (!earned) {
        messenger.showSnackBar(
          SnackBar(content: Text(t('premium.ad_incomplete'))),
        );
        return;
      }
      await ref.read(premiumCreditsProvider.notifier).grantAd();
    } on PostgrestException catch (e) {
      // Limiti del server sui crediti da annuncio: messaggi dedicati per i due
      // casi che un utente reale può incontrare, "riprova" per il resto.
      if (mounted) {
        final key = e.message.contains('DAILY_LIMIT')
            ? 'premium.ad_limit'
            : e.message.contains('BANK_FULL')
            ? 'premium.bank_full'
            : 'common.retry';
        messenger.showSnackBar(SnackBar(content: Text(t(key))));
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(t('common.retry'))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final active = ref.watch(entitlementsProvider).value ?? const {};
    final isPremium = ref.watch(hasPremiumProvider);

    return Aura(
      color: JoyoColors.violet,
      secondary: JoyoColors.amber,
      intensity: 0.7,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(t('shop.page_title'), style: text.titleLarge),
          leading: const BackButton(color: JoyoColors.textSecondary),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              RiseIn(child: _ShopHero(title: t('paywall.title'))),
              const SizedBox(height: 22),
              RiseIn(
                delayMs: 60,
                child: _PlanCard(
                  accent: JoyoColors.violet,
                  icon: Icons.workspace_premium_rounded,
                  name: t('paywall.premium_name'),
                  features: [
                    t('paywall.feat_modes'),
                    t('paywall.feat_rounds'),
                    t('paywall.no_ads_name'),
                  ],
                  badge: t('paywall.best_value'),
                  featured: true,
                  price: _price[AppEnv.premiumSubProductId] ??
                      _fallbackPrice[AppEnv.premiumSubProductId]!,
                  priceSuffix: t('paywall.per_month'),
                  active: active.contains(AppEnv.premiumSubProductId),
                  activeLabel: t('paywall.active'),
                  buttonLabel: t('paywall.subscribe'),
                  busy: _busy,
                  onTap: () => _subscribe(AppEnv.premiumSubProductId),
                ),
              ),
              const SizedBox(height: 14),
              RiseIn(
                delayMs: 120,
                child: _PlanCard(
                  accent: JoyoColors.aqua,
                  icon: Icons.block_rounded,
                  name: t('paywall.no_ads_name'),
                  desc: t('paywall.no_ads_desc'),
                  price: _price[AppEnv.noAdsProductId] ??
                      _fallbackPrice[AppEnv.noAdsProductId]!,
                  priceSuffix: t('paywall.per_month'),
                  active: active.contains(AppEnv.noAdsProductId) || isPremium,
                  activeLabel: t('paywall.active'),
                  buttonLabel: t('paywall.subscribe'),
                  busy: _busy,
                  onTap: () => _subscribe(AppEnv.noAdsProductId),
                ),
              ),

              // Sblocco con annunci: inutile mostrarlo se il premium copre tutto.
              if (!isPremium) ...[
                const SizedBox(height: 14),
                RiseIn(delayMs: 180, child: _buildFreeCard(t, text)),
              ],

              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: _busy ? null : _restore,
                  child: Text(t('paywall.restore')),
                ),
              ),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => launchUrl(
                        _termsUrl,
                        mode: LaunchMode.inAppBrowserView,
                      ),
                      child: Text(
                        t('paywall.terms'),
                        style: text.bodySmall?.copyWith(
                          color: JoyoColors.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      '·',
                      style: text.bodySmall?.copyWith(
                        color: JoyoColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => launchUrl(
                        _privacyPolicyUrl,
                        mode: LaunchMode.inAppBrowserView,
                      ),
                      child: Text(
                        t('shop.privacy'),
                        style: text.bodySmall?.copyWith(
                          color: JoyoColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_privacyOptionsRequired)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        ref.read(adsServiceProvider).showPrivacyOptions(),
                    child: Text(
                      t('shop.ad_privacy'),
                      style: text.bodySmall?.copyWith(
                        color: JoyoColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreeCard(Translator t, TextTheme text) {
    final credits =
        ref.watch(premiumCreditsProvider).value ??
        (adProgress: 0, games: 0);

    return GlowCard(
      accent: JoyoColors.lime,
      glow: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: JoyoColors.lime.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: JoyoColors.lime.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 22,
                  color: JoyoColors.lime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(t('shop.free_title'), style: text.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            t('shop.body'),
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
          ),
          const SizedBox(height: 14),
          _ProgressDots(progress: credits.adProgress, target: _adsPerGame),
          const SizedBox(height: 8),
          if (credits.games > 0)
            Text(
              t('shop.games', {'n': '${credits.games}'}),
              style: text.bodyMedium?.copyWith(color: JoyoColors.lime),
            )
          else
            Text(
              t('shop.progress', {'n': '${credits.adProgress}'}),
              style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
            ),
          const SizedBox(height: 14),
          JoyoButton(
            accent: JoyoColors.lime,
            label: t('shop.watch'),
            busy: _busy,
            onPressed: _busy ? null : _watchAd,
          ),
        ],
      ),
    );
  }
}

/// Apertura della pagina: stemma premium luminoso e titolo con riflesso, per
/// dare subito il tono "vetrina" prima delle card.
class _ShopHero extends StatelessWidget {
  const _ShopHero({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [JoyoColors.violet, JoyoColors.magenta],
            ),
            boxShadow: [
              BoxShadow(
                color: JoyoColors.violet.withValues(alpha: 0.45),
                blurRadius: 34,
                spreadRadius: -4,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            size: 36,
            color: JoyoColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Shimmer(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.accent,
    required this.icon,
    required this.name,
    required this.price,
    required this.priceSuffix,
    required this.active,
    required this.activeLabel,
    required this.buttonLabel,
    required this.busy,
    required this.onTap,
    this.desc,
    this.features = const [],
    this.badge,
    this.featured = false,
  });

  final Color accent;
  final IconData icon;
  final String name;
  final String? desc;
  final List<String> features;
  final String? badge;
  final bool featured;
  final String price;
  final String priceSuffix;
  final bool active;
  final String activeLabel;
  final String buttonLabel;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (featured)
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent, JoyoColors.magenta],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Icon(icon, size: 22, color: JoyoColors.textPrimary),
              )
            else
              Icon(icon, color: accent),
            SizedBox(width: featured ? 12 : 10),
            Expanded(child: Text(name, style: text.titleMedium)),
            if (badge != null)
              _Badge(label: badge!)
            else
              Text(
                '$price$priceSuffix',
                style: text.titleSmall?.copyWith(color: accent),
              ),
          ],
        ),
        if (featured) ...[
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: text.headlineSmall?.copyWith(
                  color: JoyoColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                priceSuffix,
                style: text.bodySmall?.copyWith(
                  color: JoyoColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
        if (desc != null) ...[
          const SizedBox(height: 6),
          Text(
            desc!,
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
          ),
        ],
        if (features.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, size: 16, color: accent),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature, style: text.bodyMedium)),
                ],
              ),
            ),
        ],
        const SizedBox(height: 10),
        if (active)
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: JoyoColors.lime, size: 18),
              const SizedBox(width: 6),
              Text(
                activeLabel,
                style: text.bodyMedium?.copyWith(color: JoyoColors.lime),
              ),
            ],
          )
        else
          SizedBox(
            width: double.infinity,
            child: JoyoButton(
              accent: featured ? JoyoColors.lime : accent,
              label: buttonLabel,
              busy: busy,
              onPressed: busy ? null : onTap,
            ),
          ),
      ],
    );

    if (!featured) {
      return GlowCard(
        accent: accent,
        glow: active ? 1.0 : 0.6,
        child: content,
      );
    }

    // La card in evidenza ha un bordo a gradiente tutto suo: è l'unica della
    // pagina, così l'occhio cade prima qui.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [JoyoColors.aqua, JoyoColors.violet, JoyoColors.magenta],
        ),
        boxShadow: [
          BoxShadow(
            color: JoyoColors.violet.withValues(alpha: 0.38),
            blurRadius: 42,
            spreadRadius: -6,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              JoyoColors.surface,
              Color.lerp(JoyoColors.surfaceHigh, accent, 0.16)!,
            ],
          ),
        ),
        child: content,
      ),
    );
  }
}

/// Chip dorata "il più scelto" sulla card in evidenza.
class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [JoyoColors.gold, JoyoColors.amber],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 12,
            color: JoyoColors.background,
          ),
          const SizedBox(width: 4),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: JoyoColors.background,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pallini di avanzamento: pieni fino a [progress], vuoti fino a [target].
class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.progress, required this.target});

  final int progress;
  final int target;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < target; i++) ...[
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: i < progress ? JoyoColors.lime : JoyoColors.surfaceHigh,
              shape: BoxShape.circle,
              border: Border.all(
                color: i < progress ? JoyoColors.lime : Colors.transparent,
                width: 2,
              ),
            ),
            child: i < progress
                ? const Icon(Icons.check, size: 14, color: Colors.black)
                : null,
          ),
          if (i != target - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
