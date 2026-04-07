import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../../../../core/animations/staggered_animation.dart';
import '../data/project_data.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final crossAxisCount = isDesktop ? 2 : isTablet ? 2 : 1;
    final projects = ProjectData.projects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with divider
        const SectionDivider(
          title: 'Projects',
          icon: Icons.folder_outlined,
          subtitle: 'Featured work and case studies',
        ),
        const SizedBox(height: 24),
        // Project cards with staggered animation
        StaggeredAnimation(
          staggerDelay: const Duration(milliseconds: 120),
          children: [
            for (int i = 0; i < projects.length; i += crossAxisCount)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int j = i; j < min(i + crossAxisCount, projects.length); j++) ...[
                      if (j > i) const SizedBox(width: 24),
                      Expanded(child: ProjectCard(project: projects[j])),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  int min(int a, int b) => a < b ? a : b;
}
