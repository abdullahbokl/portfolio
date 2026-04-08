import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/project_model.dart';

class ProjectCardHeader extends StatelessWidget {
  const ProjectCardHeader({
    required this.project,
    required this.accent,
    required this.expanded,
    super.key,
  });

  final ProjectModel project;
  final Color accent;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(project.icon, color: accent, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: AppTextStyles.h3(
                  context,
                ).copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                project.subtitle,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        AnimatedRotation(
          turns: expanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.expand_more,
            color: AppColors.textTertiary,
            size: 20,
          ),
        ),
      ],
    );
  }
}
