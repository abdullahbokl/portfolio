import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/equal_height_grid.dart';
import '../data/project_data.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = context.isDesktop
        ? 3
        : context.isTablet
            ? 2
            : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.projectsSectionTitle,
          style: AppTextStyles.h2(context).copyWith(
            color: context.accent.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.projectsSectionSubtitle,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        EqualHeightGrid(
          columns: columns,
          children: ProjectData.projects
              .map((project) => ProjectCard(project: project))
              .toList(),
        ),
      ],
    );
  }
}


