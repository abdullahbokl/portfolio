import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../bloc/navigation/navigation_cubit.dart';
import '../../core/extensions/context_extensions.dart';
import 'desktop_nav_list.dart';
import 'mobile_nav_bottom_sheet.dart';
import 'theme_toggle_button.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final accent = context.accent.accent;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 64,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary.withValues(alpha: 0.7),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.surfaceQuaternary.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.read<NavigationCubit>().scrollTo(0),
          child: Text(
            'AE',
            style: AppTextStyles.h3(context).copyWith(color: accent),
          ),
        ),
      ),
      actions: [
        if (isDesktop) const DesktopNavList(),
        // Accent toggle button
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: ThemeToggleButton(),
        ),
        // Mobile hamburger
        if (!isDesktop)
          Builder(
            builder: (ctx) {
              return IconButton(
                onPressed: () => showMobileNav(ctx),
                icon: Icon(Icons.menu, color: accent),
                tooltip: 'Navigation menu',
              );
            },
          ),
      ],
    );
  }
}
