import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/theme/app_colors.dart';

const _key = 'joyo.adult_confirmed';

/// Disclaimer 18+ prima di attivare Mix o Hot: contengono contenuti espliciti
/// e il rating store alto richiede un gate coerente in app. La conferma vale
/// una volta per dispositivo. Torna `true` se si può procedere.
Future<bool> ensureAdultConfirmed(BuildContext context, Translator t) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_key) ?? false) return true;
  if (!context.mounted) return false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: JoyoColors.surfaceHigh,
      title: Text(t('age.title')),
      content: Text(t('age.body')),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t('common.cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(t('age.confirm')),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;

  await prefs.setBool(_key, true);
  return true;
}
