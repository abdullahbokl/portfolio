import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/skill_model.dart';
import 'skill_row.dart';

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

    final shadows = _hovered
        ? [
            BoxShadow(
              color: accent.withValues(alpha: 0.12),
              blurRadius: 24,
            ),
          ]
        : const <BoxShadow>[];

    return VisibilityDetector(
      key: Key('skill-${widget.category.title}'),
      onVisibilityChanged: (info) {
        if (!_hasAnimated && info.visibleFraction > 0.3) {
          _hasAnimated = true;
          _controller.forward();
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: RepaintBoundary(
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
              boxShadow: shadows,
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
                      style: AppTextStyles.h3(
                        context,
                      ).copyWith(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...widget.category.skills.map(
                  (skill) => SkillRow(
                    skill: skill,
                    animation: _controller,
                    accent: accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
