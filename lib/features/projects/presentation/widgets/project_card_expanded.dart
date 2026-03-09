import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/project_model.dart';
import 'link_button.dart';

class ProjectCardExpanded extends StatelessWidget {
  const ProjectCardExpanded({
    required this.project,
    required this.accent,
    super.key,
  });

  final ProjectModel project;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.description,
            style: AppTextStyles.body(
              context,
            ).copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...project.architectureHighlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(Icons.arrow_right, color: accent, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      h,
                      style: AppTextStyles.body(
                        context,
                      ).copyWith(color: AppColors.textPrimary, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (project.liveUrl != null ||
              project.appleStoreUrl != null ||
              project.webUrl != null ||
              project.githubUrl != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (project.liveUrl != null)
                  LinkButton(
                    label: 'Play Store',
                    icon: Icons.shop_outlined,
                    url: project.liveUrl!,
                    accent: accent,
                  ),
                if (project.appleStoreUrl != null)
                  LinkButton(
                    label: 'App Store',
                    icon: Icons.apple_outlined,
                    url: project.appleStoreUrl!,
                    accent: accent,
                  ),
                if (project.webUrl != null)
                  LinkButton(
                    label: 'Web App',
                    icon: Icons.language_outlined,
                    url: project.webUrl!,
                    accent: accent,
                  ),
                if (project.githubUrl != null)
                  LinkButton(
                    label: 'Source',
                    icon: Icons.code,
                    url: project.githubUrl!,
                    accent: accent,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
