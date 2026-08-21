import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/env/app_env.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/diagnostics/missing_config_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/onboarding_state.dart';

class JoyoApp extends ConsumerWidget {
  const JoyoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Joyo',
      debugShowCheckedModeBanner: false,
      theme: JoyoTheme.dark,
      // Joyo è un'app da telefono: su finestre larghe (browser, tablet) il
      // contenuto resta in una colonna stretta invece di allargarsi e
      // sfondare i layout pensati per uno schermo verticale.
      builder: (context, child) => ColoredBox(
        color: JoyoColors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: child,
          ),
        ),
      ),
      home: const _Entry(),
    );
  }
}

class _Entry extends ConsumerWidget {
  const _Entry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppEnv.isConfigured) return const MissingConfigScreen();

    final onboarded = ref.watch(onboardingProvider);
    return switch (onboarded) {
      null => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: JoyoColors.lime),
        ),
      ),
      false => const OnboardingScreen(),
      true => const HomeScreen(),
    };
  }
}
