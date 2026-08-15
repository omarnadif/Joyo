import 'package:flutter/material.dart';

import '../../core/env/app_env.dart';
import '../../core/theme/app_colors.dart';

/// Mostrata quando l'app viene avviata senza le chiavi Supabase.
class MissingConfigScreen extends StatelessWidget {
  const MissingConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Configurazione mancante', style: text.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Variabili non impostate: ${AppEnv.missingKeys.join(', ')}.',
                style: text.bodyMedium?.copyWith(
                  color: JoyoColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: JoyoColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Come sistemare', style: text.titleMedium),
                    const SizedBox(height: 12),
                    Text(
                      '1. Copia env.example.json in env.json\n'
                      '2. Incolla Project URL e anon key del progetto Supabase\n'
                      '3. Riavvia con:\n'
                      '   flutter run --dart-define-from-file=env.json',
                      style: text.bodySmall?.copyWith(height: 1.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
