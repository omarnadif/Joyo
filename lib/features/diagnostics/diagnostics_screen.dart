import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/env/app_env.dart';
import '../../core/supabase/supabase_providers.dart';
import '../../core/theme/app_colors.dart';

/// Diagnostica di connessione (aperta tenendo premuto il marchio in home): verifica chiavi, login anonimo, database + RLS e realtime.
class DiagnosticsScreen extends ConsumerWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final session = ref.watch(anonSessionProvider);
    final ping = ref.watch(databasePingProvider);
    final realtime = ref.watch(realtimePingProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text('Joyo', style: text.displayLarge),
              const SizedBox(height: 4),
              Text(
                'Diagnostica di connessione',
                style: text.bodyMedium?.copyWith(
                  color: JoyoColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              _CheckTile(
                title: 'Configurazione',
                accent: JoyoColors.violet,
                state: _CheckState.ok,
                detail: _host(AppEnv.supabaseUrl),
              ),
              const SizedBox(height: 12),
              _CheckTile(
                title: 'Login anonimo',
                accent: JoyoColors.aqua,
                state: _stateOf(session),
                detail: session.when(
                  data: (s) =>
                      'uid ${s.user.id.length > 8 ? '${s.user.id.substring(0, 8)}…' : s.user.id}',
                  loading: () => 'in corso…',
                  error: (e, _) => '$e',
                ),
              ),
              const SizedBox(height: 12),
              _CheckTile(
                title: 'Database + RLS',
                accent: JoyoColors.lime,
                state: _stateOf(ping),
                detail: ping.when(
                  data: (rows) => 'PostgREST ok · $rows stanze visibili',
                  loading: () => 'in corso…',
                  error: (e, _) => '$e',
                ),
              ),
              const SizedBox(height: 12),
              _CheckTile(
                title: 'Realtime',
                accent: JoyoColors.amber,
                state: _stateOf(realtime),
                detail: realtime.when(
                  data: (msg) => msg,
                  loading: () => 'in corso…',
                  error: (e, _) => '$e',
                ),
              ),

              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () {
                  ref.invalidate(anonSessionProvider);
                  ref.invalidate(databasePingProvider);
                  ref.invalidate(realtimePingProvider);
                },
                child: const Text('RIPROVA'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _host(String url) =>
      Uri.tryParse(url)?.host ?? 'url non valido';

  static _CheckState _stateOf(AsyncValue<Object?> value) => value.when(
    data: (_) => _CheckState.ok,
    loading: () => _CheckState.running,
    error: (_, _) => _CheckState.failed,
  );
}

enum _CheckState { running, ok, failed }

class _CheckTile extends StatelessWidget {
  const _CheckTile({
    required this.title,
    required this.detail,
    required this.state,
    required this.accent,
  });

  final String title;
  final String detail;
  final _CheckState state;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: JoyoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: state == _CheckState.failed
              ? JoyoColors.coral
              : JoyoColors.surfaceHigh,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 28, height: 28, child: _indicator(accent)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: text.bodySmall?.copyWith(
                    color: state == _CheckState.failed
                        ? JoyoColors.coral
                        : JoyoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _indicator(Color accent) {
    switch (state) {
      case _CheckState.running:
        return const Padding(
          padding: EdgeInsets.all(4),
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: JoyoColors.textSecondary,
          ),
        );
      case _CheckState.ok:
        return DecoratedBox(
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          child: const Icon(
            Icons.check_rounded,
            size: 20,
            color: JoyoColors.background,
          ),
        );
      case _CheckState.failed:
        return const DecoratedBox(
          decoration: BoxDecoration(
            color: JoyoColors.coral,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close_rounded,
            size: 20,
            color: JoyoColors.background,
          ),
        );
    }
  }
}
