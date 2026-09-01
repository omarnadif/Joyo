import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/env/app_env.dart';
import '../../core/haptics/haptics_service.dart';
import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/aura.dart';
import '../../core/ui/joyo_ui.dart';
import 'entitlements.dart';
import 'purchase_service.dart';

/// Se la proposta Premium è già stata aperta in questo avvio dell'app. È in
/// memoria (non su disco): si azzera a ogni riapertura, così compare una volta
/// per sessione e non a ogni ritorno in home.
class PremiumPromoShownNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markShown() => state = true;
}

final premiumPromoShownProvider =
    NotifierProvider<PremiumPromoShownNotifier, bool>(
      PremiumPromoShownNotifier.new,
    );

/// Apre la proposta Premium come popup a pagina piena (modale a tutto schermo):
/// l'abbonamento si fa qui, senza mandare l'utente allo Shop.
Future<void> showPremiumPromo(BuildContext context) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const PremiumPromoScreen(),
      ),
    );

class PremiumPromoScreen extends ConsumerStatefulWidget {
  const PremiumPromoScreen({super.key});

  @override
  ConsumerState<PremiumPromoScreen> createState() => _PremiumPromoScreenState();
}

class _PremiumPromoScreenState extends ConsumerState<PremiumPromoScreen> {
  bool _busy = false;

  static final _privacyPolicyUrl =
      Uri.parse('https://omarnadif.github.io/joyo-legal/privacy-policy/');
  static final _termsUrl =
      Uri.parse('https://omarnadif.github.io/joyo-legal/terms/');

  static const _fallbackPrice = '€3,99';
  String? _price;

  @override
  void initState() {
    super.initState();
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    final product = await ref
        .read(purchaseServiceProvider)
        .productById(AppEnv.premiumSubProductId);
    if (product != null && mounted) setState(() => _price = product.price);
  }

  Future<void> _subscribe() async {
    setState(() => _busy = true);
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final purchases = ref.read(purchaseServiceProvider);
      if (!await purchases.isAvailable()) {
        messenger.showSnackBar(SnackBar(content: Text(t('premium.no_store'))));
        return;
      }
      final token = await purchases.buySubscription(AppEnv.premiumSubProductId);
      if (token == null || !mounted) return;
      final ok = await ref.read(entitlementsRepositoryProvider).verify(
            productId: AppEnv.premiumSubProductId,
            purchaseToken: token,
          );
      if (ok) await ref.read(entitlementsProvider.notifier).refresh();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(ok ? t('paywall.active') : t('common.retry'))),
      );
      if (ok) Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final price = _price ?? _fallbackPrice;

    return Aura(
      color: JoyoColors.violet,
      secondary: JoyoColors.magenta,
      intensity: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
                children: [
                  RiseIn(
                    child: Column(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
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
                                color: JoyoColors.violet.withValues(alpha: 0.5),
                                blurRadius: 40,
                                spreadRadius: -4,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            size: 40,
                            color: JoyoColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Shimmer(
                          child: Text(
                            t('paywall.title'),
                            textAlign: TextAlign.center,
                            style: text.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          t('paywall.premium_desc'),
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: JoyoColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  RiseIn(
                    delayMs: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final feature in [
                          t('paywall.feat_modes'),
                          t('paywall.feat_rounds'),
                          t('paywall.no_ads_name'),
                        ])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 22,
                                  color: JoyoColors.lime,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(feature, style: text.titleMedium),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RiseIn(
                    delayMs: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price,
                          style: text.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t('paywall.per_month'),
                          style: text.bodyMedium?.copyWith(
                            color: JoyoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RiseIn(
                    delayMs: 200,
                    child: JoyoButton(
                      accent: JoyoColors.lime,
                      label: t('paywall.subscribe'),
                      icon: Icons.workspace_premium_rounded,
                      busy: _busy,
                      onPressed: _busy ? null : _subscribe,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                ],
              ),
              // La X: chiude e basta, l'abbonamento resta facoltativo.
              Positioned(
                top: 4,
                right: 4,
                child: GlowCard(
                  accent: JoyoColors.surfaceHigh,
                  glow: 0,
                  radius: 999,
                  padding: const EdgeInsets.all(8),
                  onTap: () {
                    ref.read(hapticsServiceProvider).fire(Haptic.light);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: JoyoColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
