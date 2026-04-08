import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accent_theme.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  // ── Dark (neutral — no UV accent) ────────────
  static ThemeData get dark => _buildTheme(
    accent: AppColors.textPrimary,
    accentLight: AppColors.textSecondary,
    accentDim: AppColors.surfaceTertiary,
    seedColor: AppColors.surfaceTertiary,
  );

  // ── UV Green ─────────────────────────────────
  static ThemeData get uvGreen => _buildTheme(
    accent: AppColors.accentGreen,
    accentLight: AppColors.accentGreenLight,
    accentDim: AppColors.accentGreenDim,
    seedColor: AppColors.accentGreen,
  );

  // ── UV Violet ────────────────────────────────
  static ThemeData get uvViolet => _buildTheme(
    accent: AppColors.accentViolet,
    accentLight: AppColors.accentVioletLight,
    accentDim: AppColors.accentVioletDim,
    seedColor: AppColors.accentViolet,
  );

  static ThemeData _buildTheme({
    required Color accent,
    required Color accentLight,
    required Color accentDim,
    required Color seedColor,
  }) {
    final colorScheme = ColorScheme.dark(
      surface: AppColors.surfacePrimary,
      onSurface: AppColors.textPrimary,
      primary: accent,
      onPrimary: AppColors.surfacePrimary,
      secondary: accentLight,
      onSecondary: AppColors.surfacePrimary,
      tertiary: accentDim,
      error: AppColors.error,
      onError: AppColors.textPrimary,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surfacePrimary,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceQuaternary),
        ),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: AppColors.surfacePrimary,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: accent),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: [
        AccentTheme(
          accent: accent,
          accentLight: accentLight,
          accentDim: accentDim,
        ),
      ],
    );
  }
}
