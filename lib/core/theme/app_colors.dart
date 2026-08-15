import 'package:flutter/material.dart';

/// Palette Joyo.
class JoyoColors {
  const JoyoColors._();

  // Sfondi
  static const Color background = Color(0xFF17142A);
  static const Color surface = Color(0xFF211D3B);
  static const Color surfaceHigh = Color(0xFF2A2450);

  // Accenti
  static const Color lime = Color(0xFFD6FF3F);
  static const Color coral = Color(0xFFFF5C77);
  static const Color violet = Color(0xFF7F77DD);
  static const Color aqua = Color(0xFF5DCAA5);
  static const Color amber = Color(0xFFF0997B);

  // Testo
  static const Color textPrimary = Color(0xFFF4F2FF);
  static const Color textSecondary = Color(0xFF9C96C4);

  /// Colori selezionabili come avatar dai giocatori.
  /// La chiave è quella salvata in `players.color`.
  static const Map<String, Color> avatarPalette = <String, Color>{
    'lime': lime,
    'coral': coral,
    'violet': violet,
    'aqua': aqua,
    'amber': amber,
  };

  static Color avatar(String key) => avatarPalette[key] ?? violet;
}
