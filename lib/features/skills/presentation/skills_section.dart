import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/equal_height_grid.dart';
import '../data/skills_data.dart';
import 'widgets/skill_category_card.dart';

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
        Text(
          AppStrings.skillsSectionTitle,
          style: AppTextStyles.h2(context).copyWith(
            color: context.accent.accent,
          ),
        ),
        const SizedBox(height: 32),
        EqualHeightGrid(
          columns: columns,
          children: SkillsData.categories
              .map((category) => SkillCategoryCard(category: category))
              .toList(),
        ),
      ],
    );
  }
}


