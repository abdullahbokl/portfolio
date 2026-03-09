import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Small chip badge for tech tags on project cards.
class ArchitectureBadge extends StatelessWidget {
  const ArchitectureBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(context).copyWith(
          color: accent.withValues(alpha: 0.9),
          fontSize: 11,
        ),
      ),
    );
  }
}

