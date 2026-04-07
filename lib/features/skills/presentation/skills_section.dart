import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../../../../core/widgets/skill_bar_3d.dart';
import '../../../../core/animations/staggered_animation.dart';
import '../data/skills_data.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
        // Section header
        const SectionDivider(
          title: 'Skills',
          icon: Icons.code_outlined,
          subtitle: 'Technical expertise and proficiency',
        ),
        const SizedBox(height: 24),
        // Skills grid with staggered animation
        StaggeredAnimation(
          staggerDelay: const Duration(milliseconds: 100),
          children: SkillsData.categories
              .map(
                (category) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SkillCard3D(
                    title: category.title,
                    icon: category.icon,
                    skills: category.skills.map((s) => s.name).toList(),
                    animation: AlwaysStoppedAnimation(1.0),
                    accent: category.title == 'Frontend'
                        ? Colors.blue
                        : category.title == 'Backend'
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
