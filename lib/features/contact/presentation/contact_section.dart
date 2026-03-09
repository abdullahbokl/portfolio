import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return Column(
      children: [
        Text(
          AppStrings.contactTitle,
          style: AppTextStyles.h2(context).copyWith(color: accent),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.contactSubtitle,
          style: AppTextStyles.body(context)
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _SocialLink(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              url: AppStrings.githubUrl,
            ),
            _SocialLink(
              icon: FontAwesomeIcons.linkedin,
              label: 'LinkedIn',
              url: AppStrings.linkedinUrl,
            ),
            _SocialLink(
              icon: FontAwesomeIcons.code,
              label: 'LeetCode',
              url: AppStrings.leetcodeUrl,
            ),
            _SocialLink(
              icon: FontAwesomeIcons.rankingStar,
              label: 'Codeforces',
              url: AppStrings.codeforcesUrl,
            ),
            _SocialLink(
              icon: Icons.email_outlined,
              label: 'Email',
              url: AppStrings.emailUrl,
            ),
          ],
        ),
        const SizedBox(height: 48),
        Divider(color: AppColors.surfaceQuaternary, height: 1),
        const SizedBox(height: 24),
        Text(
          AppStrings.contactBuiltWith,
          style: AppTextStyles.caption(context)
              .copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.contactCopyright,
          style: AppTextStyles.caption(context)
              .copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

class _SocialLink extends StatefulWidget {
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        label: 'Open ${widget.label}',
        child: GestureDetector(
          onTap: () => launchUrl(
            Uri.parse(widget.url),
            mode: LaunchMode.externalApplication,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _hovered ? accent : AppColors.surfaceQuaternary,
                width: _hovered ? 1.5 : 1.0,
              ),
              color: _hovered
                  ? accent.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: AnimatedScale(
              scale: _hovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                widget.icon,
                color: _hovered ? accent : AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


