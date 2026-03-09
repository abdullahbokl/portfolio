import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_text_styles.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.accent,
    super.key,
  });

  final String label;
  final IconData icon;
  final String url;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Semantics(
        button: true,
        label: '$label link',
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () =>
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: accent),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.caption(context).copyWith(color: accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
