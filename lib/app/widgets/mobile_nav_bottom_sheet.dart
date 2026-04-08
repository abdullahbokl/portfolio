import 'dart:ui';

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
    final isMobile = context.isMobile;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: accent.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceQuaternary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Navigate',
                    style: AppTextStyles.h3(context).copyWith(
                      color: accent,
                      fontSize: isMobile ? 18 : 20,
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppColors.surfaceQuaternary),
                ...List.generate(AppStrings.navSections.length, (i) {
                  return _MobileNavItem(
                    label: AppStrings.navSections[i],
                    icon: _sectionIcon(i),
                    accent: accent,
                    index: i,
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
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

class _MobileNavItem extends StatefulWidget {
  const _MobileNavItem({
    required this.label,
    required this.icon,
    required this.accent,
    required this.index,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final int index;

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.pop(context);
        context.read<NavigationCubit>().scrollTo(widget.index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _pressed
              ? widget.accent.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _pressed
                ? widget.accent.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.accent.withValues(alpha: _pressed ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.icon,
                color: widget.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              widget.label,
              style: AppTextStyles.body(context).copyWith(
                color: _pressed ? widget.accent : AppColors.textPrimary,
                fontWeight: _pressed ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (_pressed)
              Icon(
                Icons.arrow_forward_ios,
                color: widget.accent,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

void showMobileNav(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const MobileNavBottomSheet(),
  );
}