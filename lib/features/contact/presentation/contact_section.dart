import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../../../../core/animations/staggered_animation.dart';
import 'widgets/social_link.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const SectionDivider(
            title: 'Contact',
            icon: Icons.mail_outline,
            subtitle: 'Get in touch',
          ),
          const SizedBox(height: 16),
          // Availability badge
          _AvailabilityBadge(accent: accent),
          const SizedBox(height: 20),
          Text(
            AppStrings.contactSubtitle,
            style: AppTextStyles.body(context).copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Social links with staggered animation
          StaggeredRow(
            staggerDelay: const Duration(milliseconds: 80),
            children: [
              SocialLink(icon: FontAwesomeIcons.github, label: 'GitHub', url: AppStrings.githubUrl),
              SocialLink(icon: FontAwesomeIcons.linkedin, label: 'LinkedIn', url: AppStrings.linkedinUrl),
              SocialLink(icon: FontAwesomeIcons.code, label: 'LeetCode', url: AppStrings.leetcodeUrl),
              SocialLink(icon: FontAwesomeIcons.rankingStar, label: 'Codeforces', url: AppStrings.codeforcesUrl),
              SocialLink(icon: Icons.email_outlined, label: 'Email', url: AppStrings.emailUrl),
            ],
          ),
          const SizedBox(height: 48),
          DottedDivider(color: AppColors.surfaceQuaternary),
          const SizedBox(height: 24),
          Text(
            AppStrings.contactCopyright,
            style: AppTextStyles.caption(context).copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

/// Animated availability status badge.
class _AvailabilityBadge extends StatefulWidget {
  const _AvailabilityBadge({required this.accent});

  final Color accent;

  @override
  State<_AvailabilityBadge> createState() => _AvailabilityBadgeState();
}

class _AvailabilityBadgeState extends State<_AvailabilityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: widget.accent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: _pulseAnimation.value),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Text(
            'Available for work',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.accent,
            ),
          ),
        ],
      ),
    );
  }
}