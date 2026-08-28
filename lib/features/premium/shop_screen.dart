import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // Numero di annunci per sbloccare una partita.
  static const _adsPerGame = 3;

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
              RiseIn(
                child: _PlanCard(
                  accent: JoyoColors.aqua,
                  icon: Icons.workspace_premium_rounded,
                  name: t('paywall.premium_name'),
                  desc: t('paywall.premium_desc'),
                  price: _priceLabel(AppEnv.premiumSubProductId, t),
                  active: active.contains(AppEnv.premiumSubProductId),
                  activeLabel: t('paywall.active'),
                  buttonLabel: t('paywall.subscribe'),
                  busy: _busy,
                  onTap: () => _subscribe(AppEnv.premiumSubProductId),
                ),
              ),
              const SizedBox(height: 14),
              RiseIn(
                delayMs: 70,
                child: _PlanCard(
                  accent: JoyoColors.violet,
                  icon: Icons.block_rounded,
                  name: t('paywall.no_ads_name'),
                  desc: t('paywall.no_ads_desc'),
                  price: _priceLabel(AppEnv.noAdsProductId, t),
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
                RiseIn(delayMs: 140, child: _buildFreeCard(t, text)),
              ],

              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: _busy ? null : _restore,
                  child: Text(t('paywall.restore')),
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
              const Icon(Icons.play_circle_fill_rounded,
                  color: JoyoColors.lime),
              const SizedBox(width: 10),
              Expanded(
                child: Text(t('shop.free_title'), style: text.titleMedium),
              ),
            ],
          ),
          const SizedBox(height: 6),
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

  String _priceLabel(String id, Translator t) {
    final base = _price[id] ?? _fallbackPrice[id] ?? '';
    return '$base${t('paywall.per_month')}';
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.accent,
    required this.icon,
    required this.name,
    required this.desc,
    required this.price,
    required this.active,
    required this.activeLabel,
    required this.buttonLabel,
    required this.busy,
    required this.onTap,
  });

  final Color accent;
  final IconData icon;
  final String name;
  final String desc;
  final String price;
  final bool active;
  final String activeLabel;
  final String buttonLabel;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return GlowCard(
      accent: accent,
      glow: active ? 1.0 : 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent),
              const SizedBox(width: 10),
              Expanded(child: Text(name, style: text.titleMedium)),
              Text(price, style: text.titleSmall?.copyWith(color: accent)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: text.bodySmall?.copyWith(color: JoyoColors.textSecondary),
          ),
          const SizedBox(height: 14),
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
                accent: accent,
                label: buttonLabel,
                busy: busy,
                onPressed: busy ? null : onTap,
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
