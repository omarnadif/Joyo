import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/haptics/haptics_service.dart';
import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/joyo_ui.dart';
import 'shop_screen.dart';

/// Se il promo Premium è già stato mostrato in questo avvio dell'app. È in
/// memoria (non su disco): si azzera a ogni riapertura, così la finestra
/// compare una volta per sessione e non a ogni ritorno in home.
class PremiumPromoShownNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markShown() => state = true;
}

final premiumPromoShownProvider =
    NotifierProvider<PremiumPromoShownNotifier, bool>(
      PremiumPromoShownNotifier.new,
    );

/// Finestrella che propone l'abbonamento all'apertura: titolo, vantaggi e un
/// invito ad aprire lo Shop. In alto a destra una X per chiudere senza impegno.
Future<void> showPremiumPromo(BuildContext context) => showDialog<void>(
  context: context,
  barrierColor: Colors.black.withValues(alpha: 0.72),
  builder: (_) => const _PremiumPromoDialog(),
);

class _PremiumPromoDialog extends ConsumerWidget {
  const _PremiumPromoDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GlowCard(
            accent: JoyoColors.violet,
            glow: 1.2,
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
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
                        blurRadius: 30,
                        spreadRadius: -4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    size: 32,
                    color: JoyoColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Shimmer(
                  child: Text(
                    t('paywall.title'),
                    textAlign: TextAlign.center,
                    style: text.headlineSmall,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  t('paywall.premium_desc'),
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(
                    color: JoyoColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                for (final feature in [
                  t('paywall.feat_modes'),
                  t('paywall.feat_rounds'),
                  t('paywall.no_ads_name'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: JoyoColors.lime,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(feature, style: text.bodyMedium),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: JoyoButton(
                    accent: JoyoColors.lime,
                    label: t('endgame.shop_cta'),
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      ref.read(hapticsServiceProvider).fire(Haptic.light);
                      Navigator.of(context).pop();
                      openShop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          // La X: chiude e basta, l'abbonamento resta facoltativo.
          Positioned(
            top: -6,
            right: -6,
            child: GlowCard(
              accent: JoyoColors.surfaceHigh,
              glow: 0,
              radius: 999,
              padding: const EdgeInsets.all(8),
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: JoyoColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
