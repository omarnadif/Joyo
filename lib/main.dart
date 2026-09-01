import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env/app_env.dart';
import 'core/notifications/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prepara le notifiche locali (promemoria "torna a giocare"). Non chiede
  // permessi qui: lo fa il provider quando la preferenza è attiva.
  await NotificationsService.instance.init();

  // Senza chiavi l'app parte lo stesso e mostra le istruzioni di setup,
  // invece di crashare al primo frame.
  if (AppEnv.isConfigured) {
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      // accetta sia la publishable key (sb_publishable_…) sia la vecchia anon key
      publishableKey: AppEnv.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  runApp(const ProviderScope(child: JoyoApp()));
}
