import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/env/app_env.dart';
import 'package:joyo/core/theme/app_colors.dart';

void main() {
  test('senza chiavi definite la configurazione risulta incompleta', () {
    // I test girano senza --dart-define, quindi le chiavi sono vuote.
    expect(AppEnv.isConfigured, isFalse);
    expect(AppEnv.missingKeys, contains('SUPABASE_URL'));
  });

  test('c\'è un colore avatar per ognuno dei 10 giocatori massimi', () {
    expect(JoyoColors.avatarPalette.length, 10);
    expect(
      JoyoColors.avatarPalette.values.toSet().length,
      10,
      reason: 'due giocatori non devono poter avere lo stesso colore',
    );
    expect(JoyoColors.avatar('lime'), JoyoColors.lime);
    expect(JoyoColors.avatar('inesistente'), JoyoColors.violet);
  });
}
