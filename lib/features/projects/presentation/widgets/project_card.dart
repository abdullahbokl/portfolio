import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/project_model.dart';
import 'architecture_badge.dart';

/// Expandable project card with hover glow and architecture highlights.
class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.project, super.key});

  final ProjectModel project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final p = widget.project;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        if (context.isDesktop) _expanded = false;
      }),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceTertiary : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? accent : AppColors.surfaceQuaternary,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: accent.withValues(alpha: 0.15), blurRadius: 30)]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: icon + title
              Row(
                children: [
                  Icon(p.icon, color: accent, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: AppTextStyles.h3(context)
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.subtitle,
                          style: AppTextStyles.caption(context)
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: AppColors.textTertiary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tech tags
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: p.techTags.map((t) => ArchitectureBadge(label: t)).toList(),
              ),

              // Push expanded content to the bottom of the card
              const Spacer(),

              // Expanded content
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildExpandedContent(context, p, accent),
                crossFadeState:
                    _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    ProjectModel p,
    Color accent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.description,
            style: AppTextStyles.body(context)
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ...p.architectureHighlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(Icons.arrow_right, color: accent, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      h,
                      style: AppTextStyles.body(context).copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (p.liveUrl != null ||
              p.appleStoreUrl != null ||
              p.webUrl != null ||
              p.githubUrl != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (p.liveUrl != null)
                  _LinkButton(
                    label: 'Play Store',
                    icon: Icons.shop_outlined,
                    url: p.liveUrl!,
                    accent: accent,
                  ),
                if (p.appleStoreUrl != null)
                  _LinkButton(
                    label: 'App Store',
                    icon: Icons.apple_outlined,
                    url: p.appleStoreUrl!,
                    accent: accent,
                  ),
                if (p.webUrl != null)
                  _LinkButton(
                    label: 'Web App',
                    icon: Icons.language_outlined,
                    url: p.webUrl!,
                    accent: accent,
                  ),
                if (p.githubUrl != null)
                  _LinkButton(
                    label: 'Source',
                    icon: Icons.code,
                    url: p.githubUrl!,
                    accent: accent,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.accent,
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
          onTap: () => launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          ),
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

