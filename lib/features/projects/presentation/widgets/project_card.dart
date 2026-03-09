import 'package:flutter/material.dart';
import 'project_card_expanded.dart';
import 'project_card_header.dart';

import '../../../../app/theme/app_colors.dart';
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
            color: _hovered
                ? AppColors.surfaceTertiary
                : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? accent : AppColors.surfaceQuaternary,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.15),
                      blurRadius: 30,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: icon + title
              ProjectCardHeader(
                project: p,
                accent: accent,
                expanded: _expanded,
              ),
              const SizedBox(height: 16),

              // Tech tags
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: p.techTags
                    .map((t) => ArchitectureBadge(label: t))
                    .toList(),
              ),

              // Push expanded content to the bottom of the card
              const Spacer(),

              // Expanded content
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: ProjectCardExpanded(project: p, accent: accent),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
