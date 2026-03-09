import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Custom ThemeExtension that exposes the current accent color.
class AccentTheme extends ThemeExtension<AccentTheme> {
  const AccentTheme({
    required this.accent,
    required this.accentLight,
    required this.accentDim,
  });

  final Color accent;
  final Color accentLight;
  final Color accentDim;

  @override
  AccentTheme copyWith({Color? accent, Color? accentLight, Color? accentDim}) {
    return AccentTheme(
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentDim: accentDim ?? this.accentDim,
    );
  }

  @override
  AccentTheme lerp(covariant AccentTheme? other, double t) {
    if (other == null) return this;
    return AccentTheme(
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
    );
  }
}

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
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .apply(
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

