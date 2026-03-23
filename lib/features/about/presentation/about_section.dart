import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/tilt_card_wrapper.dart';
import '../../stats/presentation/stats_bar_section.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.aboutSectionTitle,
          style: AppTextStyles.h2(context).copyWith(color: accent),
        ),
        const SizedBox(height: 24),
        TiltCardWrapper(
          maxTilt: 0.05,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _hovered ? accent.withValues(alpha: 0.5) : AppColors.surfaceQuaternary,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.15),
                          blurRadius: 30,
                        ),
                      ]
                    : [],
              ),
              child: Stack(
                children: [
                  if (_hovered)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.05),
                                Colors.transparent,
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.3, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.person_outline, color: accent, size: 28),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              AppStrings.aboutSummary,
                              style: AppTextStyles.body(context).copyWith(
                                color: AppColors.textPrimary,
                                height: 1.7,
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const StatsBarSection(),
      ],
    );
  }
}
