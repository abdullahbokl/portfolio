import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../core/constants/project_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../data/project_data.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final crossAxisCount = isDesktop ? 3 : isTablet ? 2 : 1;
    final projects = ProjectData.projects;

    // Build rows of crossAxisCount columns
    final rows = <List>[];
    for (int i = 0; i < projects.length; i += crossAxisCount) {
      rows.add(
        projects.sublist(
          i,
          (i + crossAxisCount > projects.length)
              ? projects.length
              : i + crossAxisCount,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ProjectStrings.projectsSectionTitle,
          style: AppTextStyles.h2(context).copyWith(
            color: context.accent.accent,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          ProjectStrings.projectsSectionSubtitle,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap any project to explore details, screenshots & architecture.',
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.textTertiary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 28),
        // Simple grid — no IntrinsicHeight, each card is self-contained
        for (final row in rows) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < row.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: ProjectCard(project: row[i])),
              ],
              // Fill remaining slots so alignment is consistent
              for (int i = row.length; i < crossAxisCount; i++) ...[
                const SizedBox(width: 16),
                const Expanded(child: SizedBox.shrink()),
              ],
            ],
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
