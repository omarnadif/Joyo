// Entrypoint usa-e-getta per lo screenshot dello shop richiesto dalla review
// degli abbonamenti su App Store Connect:
//   flutter build web -t tool/shop_shot.dart --dart-define-from-file=env.json
// Apre direttamente ShopScreen, senza onboarding.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joyo/core/env/app_env.dart';
import 'package:joyo/core/theme/app_theme.dart';
import 'package:joyo/features/premium/shop_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    publishableKey: AppEnv.supabaseAnonKey,
  );
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: JoyoTheme.dark,
        // Le animazioni d'ingresso (RiseIn) lasciano le card invisibili nel
        // primo frame: per lo screenshot si disattivano.
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: const ShopScreen(),
      ),
    ),
  );
}
