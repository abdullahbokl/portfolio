import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/experience_model.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    required this.experience,
    required this.isHovered,
    required this.accent,
    required this.isMobile,
    super.key,
  });

  final ExperienceModel experience;
  final bool isHovered;
  final Color accent;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final shadows = isHovered
        ? [BoxShadow(color: accent.withValues(alpha: 0.08), blurRadius: 20)]
        : const <BoxShadow>[];

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.surfaceTertiary
              : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHovered ? accent : AppColors.surfaceQuaternary,
          ),
          boxShadow: shadows,
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(experience.icon, color: accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.company,
                      style: AppTextStyles.h3(context).copyWith(
                        color: AppColors.textPrimary,
                        fontSize: isMobile ? 16 : 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      experience.role,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: accent),
                    ),
                  ],
                ),
              ),
              Text(
                experience.period,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Highlights
          ...experience.highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.arrow_right,
                      color: accent.withValues(alpha: 0.6),
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      h,
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
