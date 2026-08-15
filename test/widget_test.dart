import 'package:flutter_test/flutter_test.dart';
import 'package:joyo/core/env/app_env.dart';
import 'package:joyo/core/theme/app_colors.dart';

void main() {
  test('senza chiavi definite la configurazione risulta incompleta', () {
    // I test girano senza --dart-define, quindi le chiavi sono vuote.
    expect(AppEnv.isConfigured, isFalse);
    expect(AppEnv.missingKeys, contains('SUPABASE_URL'));
  });

  test('la palette avatar copre i cinque colori accento', () {
    expect(JoyoColors.avatarPalette.length, 5);
    expect(JoyoColors.avatar('lime'), JoyoColors.lime);
    expect(JoyoColors.avatar('inesistente'), JoyoColors.violet);
  });
}
