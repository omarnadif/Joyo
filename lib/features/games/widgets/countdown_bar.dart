import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Barra del tempo rimasto per votare. Il tempo è calcolato dall'orario di
/// creazione del round sul server, così scorre uguale su tutti i telefoni.
class CountdownBar extends StatefulWidget {
  const CountdownBar({required this.deadline, required this.total, super.key});

  final DateTime deadline;
  final Duration total;

  @override
  State<CountdownBar> createState() => _CountdownBarState();
}

class _CountdownBarState extends State<CountdownBar> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.total.inMilliseconds.clamp(1, 1 << 30);
    final left = widget.deadline
        .difference(DateTime.now().toUtc())
        .inMilliseconds
        .clamp(0, total);
    final seconds = (left / 1000).ceil();
    final urgent = seconds <= 5;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: left / total,
              minHeight: 8,
              backgroundColor: JoyoColors.surface,
              color: urgent ? JoyoColors.coral : JoyoColors.violet,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 28,
          child: Text(
            '$seconds',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: urgent ? JoyoColors.coral : JoyoColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
