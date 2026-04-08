import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/parallax_hero.dart';
import 'widgets/hero_cta_buttons.dart';
import 'widgets/particle_background.dart';
import 'widgets/typing_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final minHeight = max(context.screenHeight * 0.9, 600.0);
    final accentColor = context.accent.accent;

    return SizedBox(
      height: minHeight,
      child: Stack(
        children: [
          // Background layer (particles)
          const Positioned.fill(child: ParticleBackground()),
          
          // Floating geometric shapes
          const Positioned.fill(child: FloatingShapes()),
          
          // Radial gradient overlay for depth
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.5,
                  colors: [
                    accentColor.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Foreground content with parallax
          Positioned.fill(
            child: ParallaxHeroContent(
              name: AppStrings.heroName,
              subtitle: 'Designing scalable architectures.\nEngineering backend-authoritative systems.',
              typingText: const TypingText(phrases: AppStrings.heroTypingPhrases),
              ctaButtons: const HeroCtaButtons(),
              accentColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}