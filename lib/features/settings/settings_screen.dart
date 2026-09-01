import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/env/app_env.dart';
import '../../core/haptics/haptics_service.dart';
import '../../core/i18n/i18n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/ui/aura.dart';
import '../../core/ui/joyo_ui.dart';
import '../premium/entitlements.dart';
import '../premium/purchase_service.dart';
import 'notifications_pref.dart';

/// Link da collegare al momento della pubblicazione. Restano qui, uno accanto
/// all'altro, così sono facili da aggiornare.
class _Links {
  // Scheda dell'app sugli store, per la valutazione. Finché è null, il tasto
  // "Valuta" mostra "presto disponibile".
  static final Uri? rate = null;

  // Email di supporto: apre l'app di posta con destinatario già compilato.
  static const contactEmail = 'gestion.blueinhope@gmail.com';
}

/// Apre la pagina Impostazioni.
Future<void> openSettings(BuildContext context) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  Future<void> _manageSubscription() async {
    // Lo store gestisce rinnovo/disdetta: rimandiamo alla sua pagina abbonamenti.
    final url = defaultTargetPlatform == TargetPlatform.iOS
        ? Uri.parse('https://apps.apple.com/account/subscriptions')
        : Uri.parse('https://play.google.com/store/account/subscriptions');
    await launchUrl(url, mode: LaunchMode.externalApplication);
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

  Future<void> _rate() async {
    final url = _Links.rate;
    if (url == null) {
      final t = ref.read(tProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t('settings.coming_soon'))));
      return;
    }
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _contact() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _Links.contactEmail,
      queryParameters: {'subject': 'Joyo'},
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final notifications = ref.watch(notificationsPrefProvider);

    return Aura(
      color: JoyoColors.violet,
      secondary: JoyoColors.aqua,
      intensity: 0.6,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(t('settings.title'), style: text.titleLarge),
          leading: const BackButton(color: JoyoColors.textSecondary),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              RiseIn(
                child: _SettingTile(
                  icon: Icons.notifications_rounded,
                  accent: JoyoColors.amber,
                  title: t('settings.notifications'),
                  subtitle: t('settings.notifications_desc'),
                  trailing: Switch(
                    value: notifications,
                    activeThumbColor: JoyoColors.lime,
                    // Da spento i colori di default sparivano sul tema scuro:
                    // forziamo pallina e binario ben visibili.
                    inactiveThumbColor: JoyoColors.textSecondary,
                    inactiveTrackColor: JoyoColors.surfaceHigh,
                    trackOutlineColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? JoyoColors.lime
                          : JoyoColors.textSecondary,
                    ),
                    onChanged: (v) {
                      ref.read(hapticsServiceProvider).fire(Haptic.light);
                      ref.read(notificationsPrefProvider.notifier).set(v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RiseIn(
                delayMs: 60,
                child: _SettingTile(
                  icon: Icons.workspace_premium_rounded,
                  accent: JoyoColors.violet,
                  title: t('settings.manage_sub'),
                  subtitle: t('settings.manage_sub_desc'),
                  onTap: _manageSubscription,
                ),
              ),
              const SizedBox(height: 12),
              RiseIn(
                delayMs: 120,
                child: _SettingTile(
                  icon: Icons.restore_rounded,
                  accent: JoyoColors.aqua,
                  title: t('settings.restore'),
                  busy: _busy,
                  onTap: _busy ? null : _restore,
                ),
              ),
              const SizedBox(height: 12),
              RiseIn(
                delayMs: 180,
                child: _SettingTile(
                  icon: Icons.star_rounded,
                  accent: JoyoColors.gold,
                  title: t('settings.rate'),
                  subtitle: t('settings.rate_desc'),
                  onTap: _rate,
                ),
              ),
              const SizedBox(height: 12),
              RiseIn(
                delayMs: 240,
                child: _SettingTile(
                  icon: Icons.mail_rounded,
                  accent: JoyoColors.lime,
                  title: t('settings.contact'),
                  subtitle: t('settings.contact_desc'),
                  onTap: _contact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Riga impostazione: icona colorata a sinistra, titolo/sottotitolo, e a destra
/// un chevron (se apre qualcosa) o un widget custom (es. lo switch notifiche).
class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.accent,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.busy = false,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return GlowCard(
      accent: accent,
      glow: 0.5,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: busy ? null : onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.35)),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: text.bodySmall?.copyWith(
                      color: JoyoColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (busy)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (trailing != null)
            trailing!
          else if (onTap != null)
            const Icon(
              Icons.chevron_right_rounded,
              color: JoyoColors.textSecondary,
            ),
        ],
      ),
    );
  }
}
