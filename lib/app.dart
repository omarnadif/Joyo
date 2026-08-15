import 'package:flutter/material.dart';

import 'core/env/app_env.dart';
import 'core/theme/app_theme.dart';
import 'features/diagnostics/diagnostics_screen.dart';
import 'features/diagnostics/missing_config_screen.dart';

class JoyoApp extends StatelessWidget {
  const JoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joyo',
      debugShowCheckedModeBanner: false,
      theme: JoyoTheme.dark,
      home: AppEnv.isConfigured
          ? const DiagnosticsScreen()
          : const MissingConfigScreen(),
    );
  }
}
