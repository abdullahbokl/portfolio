import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

class SocialLink extends StatefulWidget {
  const SocialLink({
    required this.icon,
    required this.label,
    required this.url,
    super.key,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  State<SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<SocialLink> {
  final _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: RepaintBoundary(
        child: ValueListenableBuilder<bool>(
          valueListenable: _hovered,
          builder: (context, hovered, child) {
            return Semantics(
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
                      color: hovered ? accent : AppColors.surfaceQuaternary,
                      width: hovered ? 1.5 : 1.0,
                    ),
                    color: hovered
                        ? accent.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  child: AnimatedScale(
                    scale: hovered ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.icon,
                      color: hovered ? accent : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
