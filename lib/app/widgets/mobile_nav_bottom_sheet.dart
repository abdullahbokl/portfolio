import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../bloc/navigation/navigation_cubit.dart';
import '../../core/constants/app_strings.dart';
import '../../core/extensions/context_extensions.dart';

class MobileNavBottomSheet extends StatelessWidget {
  const MobileNavBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(AppStrings.navSections.length, (i) {
          return ListTile(
            title: Text(
              AppStrings.navSections[i],
              style: AppTextStyles.body(
                context,
              ).copyWith(color: AppColors.textPrimary),
            ),
            leading: Icon(_sectionIcon(i), color: accent),
            onTap: () {
              Navigator.pop(context);
              context.read<NavigationCubit>().scrollTo(i);
            },
          );
        }),
      ),
    );
  }

  IconData _sectionIcon(int index) {
    return switch (index) {
      0 => Icons.home_outlined,
      1 => Icons.person_outline,
      2 => Icons.code_outlined,
      3 => Icons.work_history_outlined,
      4 => Icons.psychology_outlined,
      5 => Icons.mail_outlined,
      _ => Icons.circle_outlined,
    };
  }
}

void showMobileNav(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surfaceTertiary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const MobileNavBottomSheet(),
  );
}
