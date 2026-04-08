import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../bloc/navigation/navigation_cubit.dart';
import '../../bloc/navigation/navigation_state.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/context_extensions.dart';

class DesktopNavList extends StatelessWidget {
  const DesktopNavList({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navState) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(AppStrings.navSections.length, (i) {
            final isActive = navState.activeIndex == i;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () => context.read<NavigationCubit>().scrollTo(i),
                  child: Text(
                    AppStrings.navSections[i],
                    style: AppTextStyles.caption(context).copyWith(
                      color: isActive ? accent : AppColors.textSecondary,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
