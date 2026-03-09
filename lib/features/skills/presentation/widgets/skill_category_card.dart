import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/skill_model.dart';

/// Card displaying a skill category with animated proficiency bars.
class SkillCategoryCard extends StatefulWidget {
  const SkillCategoryCard({required this.category, super.key});

  final SkillCategory category;

  @override
  State<SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<SkillCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasAnimated = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final reduceMotion = context.reduceMotion;

    if (reduceMotion && !_hasAnimated) {
      _hasAnimated = true;
      _controller.value = 1.0;
    }

    return VisibilityDetector(
      key: Key('skill-${widget.category.title}'),
      onVisibilityChanged: (info) {
        if (!_hasAnimated && info.visibleFraction > 0.4) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surfaceTertiary
                : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? accent : AppColors.surfaceQuaternary,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.12),
                      blurRadius: 24,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.category.icon, color: accent, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    widget.category.title,
                    style: AppTextStyles.h3(context)
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...widget.category.skills.map(
                (skill) => _SkillRow(
                  skill: skill,
                  animation: _controller,
                  accent: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.skill,
    required this.animation,
    required this.accent,
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
                  style: AppTextStyles.body(context)
                      .copyWith(color: AppColors.textPrimary, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                skill.level,
                style: AppTextStyles.caption(context)
                    .copyWith(color: AppColors.textSecondary),
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

