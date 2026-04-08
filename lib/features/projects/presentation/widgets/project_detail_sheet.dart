import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

    final decoration = BoxDecoration(
      color: AppColors.charcoalBlue,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.limeGreen.withValues(alpha: 0.3), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: AppColors.limeGreen.withValues(alpha: 0.1),
          blurRadius: 50,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.6),
          blurRadius: 80,
          offset: const Offset(0, 30),
        ),
      ],
    );

    Widget content = Container(
      width: dialogW,
      height: dialogH,
      decoration: decoration,
      child: RepaintBoundary(child: _buildBody(context, dialogW, dialogH)),
    );

    if (!kIsWeb) {
      content = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent taps on content from closing dialog
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double dialogW, double dialogH) {
    return Column(
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
                      style: AppTextStyles.h2(
                        context,
                      ).copyWith(
                        color: AppColors.silverGray,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      project.subtitle,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(
                        color: AppColors.limeGreen,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Close button
              _CloseButton(onTap: () => Navigator.of(context).pop()),
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
                // Links (Moved to Top)
                if (project.liveUrl != null ||
                    project.appleStoreUrl != null ||
                    project.webUrl != null ||
                    project.githubUrl != null ||
                    project.linkedinPostUrl != null) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (project.githubUrl != null)
                        LinkButton(
                          label: 'Source Code',
                          icon: FontAwesomeIcons.github,
                          url: project.githubUrl!,
                          accent: accent,
                        ),
                      if (project.liveUrl != null)
                        LinkButton(
                          label: 'Play Store',
                          icon: FontAwesomeIcons.googlePlay,
                          url: project.liveUrl!,
                          accent: accent,
                        ),
                      if (project.appleStoreUrl != null)
                        LinkButton(
                          label: 'App Store',
                          icon: FontAwesomeIcons.apple,
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
                      if (project.linkedinPostUrl != null)
                        LinkButton(
                          label: 'LinkedIn',
                          icon: FontAwesomeIcons.linkedin,
                          url: project.linkedinPostUrl!,
                          accent: accent,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Description
                Text(
                  project.description,
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(color: AppColors.textSecondary, height: 1.7),
                ),
                // Architecture highlights
                if (project.architectureHighlights.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Architecture Highlights',
                    style: AppTextStyles.h3(
                      context,
                    ).copyWith(color: accent, fontSize: 13, letterSpacing: 0.6),
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
                              style: AppTextStyles.body(context).copyWith(
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
              ],
            ),
          ),
        ),
      ],
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
            color: _hovered ? AppColors.surfaceTertiary : Colors.transparent,
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
