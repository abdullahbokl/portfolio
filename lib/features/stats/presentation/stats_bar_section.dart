import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'widgets/animated_counter.dart';

class StatsBarSection extends StatelessWidget {
  const StatsBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final isMobile = context.isMobile;

    final counters = [
      const AnimatedCounter(
        targetValue: 1000,
        suffix: '+',
        label: AppStrings.statProblems,
      ),
      const AnimatedCounter(
        targetValue: 3,
        suffix: '+',
        label: AppStrings.statExperience,
      ),
    ];

    final divider = isMobile
        ? Divider(
            color: accent.withValues(alpha: 0.3),
            height: 32,
            indent: 40,
            endIndent: 40,
          )
        : Container(
            width: 1,
            height: 40,
            color: accent.withValues(alpha: 0.3),
          );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: accent.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: isMobile
          ? Column(
              children: _interleave(
                counters.map<Widget>((c) => c).toList(),
                divider,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _interleave(
                counters.map<Widget>((c) => Expanded(child: c)).toList(),
                divider,
              ),
            ),
    );
  }

  /// Interleaves a list of widgets with a divider between each.
  List<Widget> _interleave(List<Widget> items, Widget divider) {
    final result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) result.add(divider);
    }
    return result;
  }
}


