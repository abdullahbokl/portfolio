import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/project_strings.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/tilt_card_wrapper.dart';
import '../../domain/project_model.dart';
import 'project_detail_sheet.dart';

/// Larger, more attractive project card with a featured preview image.
class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.project, super.key});

  final ProjectModel project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final p = widget.project;
    final hasImages = p.imageUrls.isNotEmpty;
    final displayImage = p.thumbnailUrl ?? (hasImages ? p.imageUrls.first : null);

    return TiltCardWrapper(
      maxTilt: 0.04,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => ProjectDetailSheet.show(context, p, accent),
          child: Stack(
            children: [
              // 1. Static/Animated Background Layer
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? AppColors.surfaceTertiary
                        : AppColors.charcoalBlue,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _hovered
                          ? accent.withValues(alpha: 0.8)
                          : AppColors.surfaceQuaternary,
                      width: _hovered ? 2 : 1,
                    ),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.2),
                              blurRadius: 40,
                              spreadRadius: -2,
                            ),
                          ]
                        : [],
                  ),
                ),
              ),

              // 2. Card Content (Column)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- PROJECT IMAGE (INSET MOCKUP) ---
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: AppColors.surfaceQuaternary.withValues(alpha: 0.3),
                        child: displayImage != null
                            ? CachedNetworkImage(
                                imageUrl: displayImage,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: AppColors.surfaceQuaternary,
                                  highlightColor: AppColors.surfaceTertiary,
                                  child: Container(color: Colors.white),
                                ),
                                errorWidget: (context, url, error) => _buildImagePlaceholder(accent),
                              )
                            : _buildImagePlaceholder(accent),
                      ),
                    ),
                  ),

                  // --- FOOTER (Icon + Title/Subtitle + Links) ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
                    child: Row(
                      children: [
                        // Left: Project Icon Box
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(p.icon, color: accent, size: 22),
                        ),
                        const SizedBox(width: 14),
                        // Middle: Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                p.title,
                                style: AppTextStyles.h3(context).copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                p.subtitle,
                                style: AppTextStyles.caption(context).copyWith(
                                  color: AppColors.textTertiary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Right: Floating Link Icons
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (p.githubUrl != null)
                              _buildIconLink(FontAwesomeIcons.github, p.githubUrl!, accent),
                            if (p.liveUrl != null)
                              _buildIconLink(FontAwesomeIcons.googlePlay, p.liveUrl!, accent),
                            if (p.appleStoreUrl != null)
                              _buildIconLink(FontAwesomeIcons.apple, p.appleStoreUrl!, accent),
                            if (p.webUrl != null)
                              _buildIconLink(Icons.language, p.webUrl!, accent),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color accent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceQuaternary,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.1),
            AppColors.surfaceSecondary,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          widget.project.icon,
          color: accent.withValues(alpha: 0.2),
          size: 64,
        ),
      ),
    );
  }

  Widget _buildIconLink(IconData icon, String url, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
        onTap: () => ProjectStrings.openUrl(url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceQuaternary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.surfaceQuaternary,
              ),
            ),
            child: Icon(icon, color: AppColors.silverGray, size: 16),
          ),
        ),
      ),
    );
  }
}
