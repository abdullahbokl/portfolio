import 'package:flutter/material.dart';

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
