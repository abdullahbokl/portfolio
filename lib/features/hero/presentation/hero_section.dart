import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'widgets/hero_cta_buttons.dart';
import 'widgets/particle_background.dart';
import 'widgets/typing_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final minHeight = max(context.screenHeight * 0.9, 600.0);

    return SizedBox(
      height: minHeight,
      child: Stack(
        children: [
          const Positioned.fill(child: ParticleBackground()),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.heroName,
                      style: AppTextStyles.display(context).copyWith(
                        color: context.accent.accent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Designing scalable architectures.\nEngineering backend-authoritative systems.',
                      style: AppTextStyles.body(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const TypingText(phrases: AppStrings.heroTypingPhrases),
                    const SizedBox(height: 40),
                    const HeroCtaButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


