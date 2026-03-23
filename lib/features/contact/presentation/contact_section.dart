import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/social_link.dart';

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
          style: AppTextStyles.body(
            context,
          ).copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            SocialLink(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              url: AppStrings.githubUrl,
            ),
            SocialLink(
              icon: FontAwesomeIcons.linkedin,
              label: 'LinkedIn',
              url: AppStrings.linkedinUrl,
            ),
            SocialLink(
              icon: FontAwesomeIcons.code,
              label: 'LeetCode',
              url: AppStrings.leetcodeUrl,
            ),
            SocialLink(
              icon: FontAwesomeIcons.rankingStar,
              label: 'Codeforces',
              url: AppStrings.codeforcesUrl,
            ),
            SocialLink(
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
          AppStrings.contactCopyright,
          style: AppTextStyles.caption(
            context,
          ).copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }
}
