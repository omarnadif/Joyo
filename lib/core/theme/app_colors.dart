import 'package:flutter/material.dart';

/// Palette Joyo.
class JoyoColors {
  const JoyoColors._();

  static const Color background = Color(0xFF17142A);
  static const Color surface = Color(0xFF211D3B);
  static const Color surfaceHigh = Color(0xFF2A2450);

  static const Color lime = Color(0xFFD6FF3F);
  static const Color coral = Color(0xFFFF5C77);
  static const Color violet = Color(0xFF7F77DD);
  static const Color aqua = Color(0xFF5DCAA5);
  static const Color amber = Color(0xFFF0997B);

  static const Color textPrimary = Color(0xFFF4F2FF);
  static const Color textSecondary = Color(0xFF9C96C4);

  // Con 10 giocatori servono 10 tinte distinguibili a colpo d'occhio anche su sfondo scuro.
  static const Color sky = Color(0xFF5AB0FF);
  static const Color magenta = Color(0xFFE85CFF);
  static const Color gold = Color(0xFFFFD84D);
  static const Color teal = Color(0xFF3FD9D1);
  static const Color rose = Color(0xFFFF9AC1);

  /// Colori selezionabili come avatar; la chiave è quella salvata in `players.color`.
  static const Map<String, Color> avatarPalette = <String, Color>{
    'lime': lime,
    'coral': coral,
    'violet': violet,
    'aqua': aqua,
    'amber': amber,
    'sky': sky,
    'magenta': magenta,
    'gold': gold,
    'teal': teal,
    'rose': rose,
  };

  static Color avatar(String key) => avatarPalette[key] ?? violet;
}
