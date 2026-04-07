import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../../../../core/animations/micro_interactions.dart';
import '../../stats/presentation/stats_bar_section.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const SectionDivider(
          title: 'About',
          icon: Icons.person_outline,
          subtitle: 'Get to know me better',
        ),
        const SizedBox(height: 24),
        // About card with hover glow
        HoverGlow(
          color: accent,
          baseBlur: 0,
          hoverBlur: 30,
          baseAlpha: 0,
          hoverAlpha: 0.2,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 20 : 32),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.surfaceQuaternary,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person_outline, color: accent, size: 28),
                ),
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
          ),
        ),
        const SizedBox(height: 32),
        // Stats bar
        const StatsBarSection(),
      ],
    );
  }
}
