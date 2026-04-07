import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../../../../core/widgets/timeline_3d.dart';
import '../data/experience_data.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const SectionDivider(
          title: 'Experience',
          icon: Icons.work_outlined,
          subtitle: 'Professional journey and education',
        ),
        const SizedBox(height: 24),
        // Animated 3D timeline
        AnimatedTimeline(
          children: List.generate(
            ExperienceData.experiences.length,
            (index) {
              final exp = ExperienceData.experiences[index];
              final isLast = index == ExperienceData.experiences.length - 1;
              final showEducationDivider =
                  exp.isEducation &&
                  (index == 0 ||
                      !ExperienceData.experiences[index - 1].isEducation);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showEducationDivider) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, bottom: 16),
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
                  TimelineEntry3D(
                    title: exp.company,
                    subtitle: exp.role,
                    period: exp.period,
                    description: exp.highlights.join('\n'),
                    icon: exp.icon,
                    isLast: isLast,
                    accent: accent,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
