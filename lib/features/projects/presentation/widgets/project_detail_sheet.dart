import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/project_model.dart';
import 'architecture_badge.dart';
import 'link_button.dart';
import 'project_image_carousel.dart';

/// Centered floating dialog for project details.
class ProjectDetailSheet extends StatelessWidget {
  const ProjectDetailSheet({
    required this.project,
    required this.accent,
    super.key,
  });

  final ProjectModel project;
  final Color accent;

  static void show(BuildContext context, ProjectModel project, Color accent) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (_) => ProjectDetailSheet(project: project, accent: accent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    // Responsive width: full on mobile, capped at 680 on desktop
    final dialogW = (screen.width * 0.9).clamp(0.0, 680.0);
    final dialogH = (screen.height * 0.85).clamp(0.0, 800.0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: dialogW,
              height: dialogH,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary.withValues(alpha: 0.97),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: accent.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.12),
                    blurRadius: 40,
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(project.icon, color: accent, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.title,
                                style: AppTextStyles.h3(context).copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                project.subtitle,
                                style: AppTextStyles.caption(context).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Close button
                        _CloseButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.surfaceQuaternary),
                  // ── Scrollable body ──────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image carousel
                          if (project.imageUrls.isNotEmpty) ...[
                            ProjectImageCarousel(
                              images: project.imageUrls,
                              accent: accent,
                            ),
                            const SizedBox(height: 20),
                          ],
                          // Tech tags
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: project.techTags
                                .map((t) => ArchitectureBadge(label: t))
                                .toList(),
                          ),
                          const SizedBox(height: 18),
                          // Description
                          Text(
                            project.description,
                            style: AppTextStyles.body(context).copyWith(
                              color: AppColors.textSecondary,
                              height: 1.7,
                            ),
                          ),
                          // Architecture highlights
                          if (project.architectureHighlights.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Text(
                              'Architecture Highlights',
                              style: AppTextStyles.h3(context).copyWith(
                                color: accent,
                                fontSize: 13,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...project.architectureHighlights.map(
                              (h) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: accent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        h,
                                        style: AppTextStyles.body(
                                          context,
                                        ).copyWith(
                                          color: AppColors.textPrimary,
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          // Links
                          if (project.liveUrl != null ||
                              project.appleStoreUrl != null ||
                              project.webUrl != null ||
                              project.githubUrl != null) ...[
                            const SizedBox(height: 20),
                            const Divider(color: AppColors.surfaceQuaternary),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                if (project.liveUrl != null)
                                  LinkButton(
                                    label: 'Play Store',
                                    icon: Icons.shop_outlined,
                                    url: project.liveUrl!,
                                    accent: accent,
                                  ),
                                if (project.appleStoreUrl != null)
                                  LinkButton(
                                    label: 'App Store',
                                    icon: Icons.apple_outlined,
                                    url: project.appleStoreUrl!,
                                    accent: accent,
                                  ),
                                if (project.webUrl != null)
                                  LinkButton(
                                    label: 'Web App',
                                    icon: Icons.language_outlined,
                                    url: project.webUrl!,
                                    accent: accent,
                                  ),
                                if (project.githubUrl != null)
                                  LinkButton(
                                    label: 'Source Code',
                                    icon: Icons.code,
                                    url: project.githubUrl!,
                                    accent: accent,
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surfaceTertiary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.close,
            size: 18,
            color: _hovered ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
