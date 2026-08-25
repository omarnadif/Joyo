import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/i18n.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/ui/aura.dart';
import '../../../core/ui/joyo_ui.dart';
import '../data/room_repository.dart';
import '../state/room_providers.dart';
import 'room_shell.dart';

enum JoinFlowMode { create, join }

/// Schermata unica per "crea" e "unisciti": cambia solo il campo codice e la CTA.
class JoinFlowScreen extends ConsumerStatefulWidget {
  const JoinFlowScreen({required this.mode, super.key});

  final JoinFlowMode mode;

  @override
  ConsumerState<JoinFlowScreen> createState() => _JoinFlowScreenState();
}

class _JoinFlowScreenState extends ConsumerState<JoinFlowScreen> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  String _color = JoyoColors.avatarPalette.keys.first;
  bool _busy = false;
  String? _error;

  bool get _isJoin => widget.mode == JoinFlowMode.join;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = ref.read(tProvider);
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = t('join.error_name'));
      return;
    }
    if (_isJoin && code.length != 6) {
      setState(() => _error = t('join.error_code'));
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      // Attende qui il login anonimo, dove lo spinner ha senso.
      await ref.read(anonSessionProvider.future);

      final repo = ref.read(roomRepositoryProvider);
      final session = _isJoin
          ? await repo.joinRoom(code: code, name: name, color: _color)
          : await repo.createRoom(name: name, color: _color);

      if (!mounted) return;
      ref.read(roomSessionProvider.notifier).enter(session);
      // Senza await: il Future di pushReplacement dura tutta la partita e
      // terrebbe vivo questo State (e il suo `finally`).
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const RoomShell()),
        ),
      );
    } on RoomException catch (e) {
      if (mounted) setState(() => _error = t(e.messageKey));
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final t = ref.watch(tProvider);
    final accent = JoyoColors.avatar(_color);

    return Aura(
      // Ambiente sempre viola: col colore dell'avatar il lime tingeva tutto di oliva.
      color: JoyoColors.violet,
      secondary: accent,
      intensity: 0.7,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            _isJoin ? t('join.title_join') : t('join.title_create'),
            style: text.titleLarge,
          ),
          leading: const BackButton(color: JoyoColors.textSecondary),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  children: [
                    RiseIn(
                      child: Text(
                        t('join.name_question'),
                        style: text.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RiseIn(
                      delayMs: 60,
                      child: TextField(
                        controller: _nameController,
                        maxLength: 20,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: t('join.name_hint'),
                          counterText: '',
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                    RiseIn(delayMs: 120, child: Eyebrow(t('join.color'))),
                    const SizedBox(height: 12),
                    RiseIn(
                      delayMs: 160,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (final entry in JoyoColors.avatarPalette.entries)
                            _ColorDot(
                              color: entry.value,
                              selected: _color == entry.key,
                              onTap: () => setState(() => _color = entry.key),
                            ),
                        ],
                      ),
                    ),

                    if (_isJoin) ...[
                      const SizedBox(height: 28),
                      Eyebrow(t('join.code')),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _codeController,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        autocorrect: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]'),
                          ),
                          UpperCaseFormatter(),
                        ],
                        style: text.headlineLarge?.copyWith(letterSpacing: 6),
                        decoration: const InputDecoration(
                          hintText: 'ABC123',
                          counterText: '',
                        ),
                      ),
                    ],

                    if (_error != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        _error!,
                        style: text.bodyMedium?.copyWith(
                          color: JoyoColors.coral,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Pulsante ancorato in fondo, dove sta il pollice.
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: JoyoButton(
                  accent: accent,
                  busy: _busy,
                  label: _isJoin ? t('join.cta_join') : t('join.cta_create'),
                  onPressed: _busy ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Il codice stanza è sempre maiuscolo, anche se digitato minuscolo.
class UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? JoyoColors.textPrimary : Colors.transparent,
            width: 3,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.55),
                    blurRadius: 24,
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                color: JoyoColors.background,
                size: 24,
              )
            : null,
      ),
    );
  }
}
