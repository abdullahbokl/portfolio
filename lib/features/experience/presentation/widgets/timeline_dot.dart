import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class TimelineDot extends StatelessWidget {
  const TimelineDot({
    required this.isHovered,
    required this.isLeadership,
    required this.accent,
    required this.isLast,
    super.key,
  });

  final bool isHovered;
  final bool isLeadership;
  final Color accent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dot
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHovered ? 16 : 12,
          height: isHovered ? 16 : 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLeadership
                ? accent
                : isHovered
                ? accent
                : AppColors.surfaceQuaternary,
            border: Border.all(color: accent, width: 2),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
        ),
        // Line
        if (!isLast)
          Expanded(
            child: Container(width: 2, color: accent.withValues(alpha: 0.2)),
          ),
      ],
    );
  }
}
