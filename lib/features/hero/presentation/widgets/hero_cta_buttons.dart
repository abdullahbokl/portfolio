import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/navigation/navigation_cubit.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/accent_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hero section CTA buttons: "Explore Systems" + "Download Resume".
class HeroCtaButtons extends StatelessWidget {
  const HeroCtaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final buttons = [
      AccentButton(
        label: AppStrings.heroCtaExplore,
        icon: Icons.code_outlined,
        onPressed: () => context.read<NavigationCubit>().scrollTo(2),
      ),
      if (isMobile) const SizedBox(height: 12) else const SizedBox(width: 16),
      AccentButton(
        label: AppStrings.heroCtaResume,
        icon: Icons.download_outlined,
        isPrimary: false,
        onPressed: () => _downloadResume(),
      ),
    ];

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: buttons,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons,
    );
  }

  Future<void> _downloadResume() async {
    final uri = Uri.parse(AppAssets.resumeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

