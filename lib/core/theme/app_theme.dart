import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tema scuro dell'app: titoli in Space Grotesk, testo in Sora.
class JoyoTheme {
  const JoyoTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: JoyoColors.lime,
      onPrimary: JoyoColors.background,
      secondary: JoyoColors.violet,
      onSecondary: JoyoColors.textPrimary,
      tertiary: JoyoColors.aqua,
      error: JoyoColors.coral,
      onError: JoyoColors.background,
      surface: JoyoColors.surface,
      onSurface: JoyoColors.textPrimary,
      surfaceContainerHighest: JoyoColors.surfaceHigh,
      outline: JoyoColors.surfaceHigh,
    );

    final baseText = GoogleFonts.soraTextTheme(ThemeData.dark().textTheme);
    final textTheme = baseText
        .copyWith(
          displayLarge: GoogleFonts.spaceGrotesk(
            fontSize: 52,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.5,
            height: 1.05,
          ),
          displayMedium: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            letterSpacing: -1,
          ),
          headlineLarge: GoogleFonts.spaceGrotesk(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: GoogleFonts.spaceGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        )
        .apply(
          bodyColor: JoyoColors.textPrimary,
          displayColor: JoyoColors.textPrimary,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: JoyoColors.background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: JoyoColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: JoyoColors.lime,
          foregroundColor: JoyoColors.background,
          minimumSize: const Size.fromHeight(58),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: JoyoColors.textPrimary,
          minimumSize: const Size.fromHeight(58),
          side: const BorderSide(color: JoyoColors.surfaceHigh, width: 2),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: JoyoColors.lime),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: JoyoColors.surface,
        hintStyle: const TextStyle(color: JoyoColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: JoyoColors.surfaceHigh, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: JoyoColors.lime, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: JoyoColors.surfaceHigh,
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(
        color: JoyoColors.surfaceHigh,
        thickness: 1,
      ),
    );
  }
}
