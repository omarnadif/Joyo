import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env/app_env.dart';
import 'core/notifications/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS: il plugin usa StoreKit 2 di default, e in quel caso il token
  // d'acquisto è un JWS che la Edge Function verify-subscription (basata su
  // verifyReceipt) non sa leggere. Con StoreKit 1 il token è la ricevuta
  // base64 che il server verifica già. Da rimuovere quando la Edge Function
  // passerà alla validazione del JWS (App Store Server API).
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    // ignore: deprecated_member_use
    await InAppPurchaseStoreKitPlatform.enableStoreKit1();
  }

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
