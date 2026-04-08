import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/skill_model.dart';

class SkillRow extends StatelessWidget {
  const SkillRow({
    required this.skill,
    required this.animation,
    required this.accent,
    super.key,
  });

  final Skill skill;
  final AnimationController animation;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  skill.name,
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(color: AppColors.textPrimary, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                skill.level,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final progress = Curves.easeOutCubic.transform(animation.value);
              return ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceQuaternary,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: skill.proficiency * progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withValues(alpha: 0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
