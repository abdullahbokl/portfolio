import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../data/experience_data.dart';
import '../domain/experience_model.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.experienceSectionTitle,
          style: AppTextStyles.h2(context).copyWith(color: accent),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.experienceSectionSubtitle,
          style: AppTextStyles.body(context)
              .copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        ...List.generate(ExperienceData.experiences.length, (index) {
          final exp = ExperienceData.experiences[index];
          final isLast = index == ExperienceData.experiences.length - 1;
          // Show "Education" divider before the first education entry
          final showEducationDivider = exp.isEducation &&
              (index == 0 ||
                  !ExperienceData.experiences[index - 1].isEducation);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showEducationDivider) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 40, bottom: 16),
                  child: Row(
                    children: [
                      Icon(Icons.school_outlined, color: accent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'EDUCATION',
                        style: AppTextStyles.caption(context).copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              _TimelineEntry(
                experience: exp,
                isLast: isLast,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _TimelineEntry extends StatefulWidget {
  const _TimelineEntry({
    required this.experience,
    required this.isLast,
  });

  final ExperienceModel experience;
  final bool isLast;

  @override
  State<_TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<_TimelineEntry> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final isMobile = context.isMobile;
    final exp = widget.experience;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline rail
            SizedBox(
              width: isMobile ? 40 : 56,
              child: Column(
                children: [
                  // Dot
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _hovered ? 16 : 12,
                    height: _hovered ? 16 : 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: exp.isLeadership
                          ? accent
                          : _hovered
                              ? accent
                              : AppColors.surfaceQuaternary,
                      border: Border.all(color: accent, width: 2),
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  // Line
                  if (!widget.isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: accent.withValues(alpha: 0.2),
                      ),
                    ),
                ],
              ),
            ),
            // Content card
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 24),
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  color: _hovered
                      ? AppColors.surfaceTertiary
                      : AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _hovered ? accent : AppColors.surfaceQuaternary,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.08),
                            blurRadius: 20,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(exp.icon, color: accent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp.company,
                                style: AppTextStyles.h3(context).copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: isMobile ? 16 : 18,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                exp.role,
                                style: AppTextStyles.caption(context).copyWith(
                                  color: accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          exp.period,
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Highlights
                    ...exp.highlights.map(
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
                                style: AppTextStyles.body(context).copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
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

