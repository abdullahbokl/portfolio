import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
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
        Text(
          AppStrings.aboutSectionTitle,
          style: AppTextStyles.h2(context).copyWith(color: accent),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 20 : 32),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceQuaternary),
          ),
          child: Column(
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
        ),
        const SizedBox(height: 32),
        const StatsBarSection(),
      ],
    );
  }
}

