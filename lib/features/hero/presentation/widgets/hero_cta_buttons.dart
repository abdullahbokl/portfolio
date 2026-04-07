import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../bloc/navigation/navigation_cubit.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enhanced CTA buttons with gradient border and glow effects.
class HeroCtaButtons extends StatefulWidget {
  const HeroCtaButtons({super.key});

  @override
  State<HeroCtaButtons> createState() => _HeroCtaButtonsState();
}

class _HeroCtaButtonsState extends State<HeroCtaButtons> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final accent = context.accent.accent;

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GradientButton(
            label: AppStrings.heroCtaExplore,
            icon: Icons.code_outlined,
            isPrimary: true,
            accent: accent,
            isHovered: _hoveredIndex == 0,
            onTap: () => context.read<NavigationCubit>().scrollTo(2),
            onHover: (hovered) => setState(() => _hoveredIndex = hovered ? 0 : -1),
          ),
          const SizedBox(height: 12),
          _GradientButton(
            label: AppStrings.heroCtaResume,
            icon: Icons.download_outlined,
            isPrimary: false,
            accent: accent,
            isHovered: _hoveredIndex == 1,
            onTap: _downloadResume,
            onHover: (hovered) => setState(() => _hoveredIndex = hovered ? 1 : -1),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GradientButton(
          label: AppStrings.heroCtaExplore,
          icon: Icons.code_outlined,
          isPrimary: true,
          accent: accent,
          isHovered: _hoveredIndex == 0,
          onTap: () => context.read<NavigationCubit>().scrollTo(2),
          onHover: (hovered) => setState(() => _hoveredIndex = hovered ? 0 : -1),
        ),
        const SizedBox(width: 16),
        _GradientButton(
          label: AppStrings.heroCtaResume,
          icon: Icons.download_outlined,
          isPrimary: false,
          accent: accent,
          isHovered: _hoveredIndex == 1,
          onTap: _downloadResume,
          onHover: (hovered) => setState(() => _hoveredIndex = hovered ? 1 : -1),
        ),
      ],
    );
  }

  Future<void> _downloadResume() async {
    final uri = Uri.parse(AppAssets.resumeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Gradient border button with glow effect.
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.accent,
    required this.isHovered,
    required this.onTap,
    required this.onHover,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final Color accent;
  final bool isHovered;
  final VoidCallback onTap;
  final void Function(bool) onHover;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isPrimary
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent,
                      accent.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            border: isPrimary
                ? null
                : Border.all(
                    color: isHovered ? accent : accent.withValues(alpha: 0.5),
                    width: isHovered ? 2 : 1.5,
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: isHovered ? 0.5 : 0.3),
                      blurRadius: isHovered ? 24 : 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isHovered
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
          ),
          transform: isHovered
              ? (Matrix4.identity()..translate(0.0, -2.0, 0.0))
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary ? AppColors.surfacePrimary : accent,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? AppColors.surfacePrimary : accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}