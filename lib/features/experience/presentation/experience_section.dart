import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../data/experience_data.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  final Map<int, bool> _visibleItems = {};

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionDivider(
          title: 'Experience',
          icon: Icons.work_outlined,
          subtitle: 'Professional journey and education',
        ),
        const SizedBox(height: 24),
        Column(
          children: List.generate(
            ExperienceData.experiences.length,
            (index) {
              final exp = ExperienceData.experiences[index];
              final isLast = index == ExperienceData.experiences.length - 1;
              final showEducationDivider =
                  exp.isEducation &&
                  (index == 0 || !ExperienceData.experiences[index - 1].isEducation);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showEducationDivider) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, bottom: 16),
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined, color: accent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'EDUCATION',
                            style: AppTextStyles.caption(context).copyWith(
                              color: accent,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  VisibilityDetector(
                    key: Key('experience-$index'),
                    onVisibilityChanged: (info) {
                      if (!mounted) return;
                      if (info.visibleFraction > 0.2 && !_visibleItems.containsKey(index)) {
                        setState(() => _visibleItems[index] = true);
                      }
                    },
                    child: TimelineEntry3D(
                      title: exp.company,
                      subtitle: exp.role,
                      period: exp.period,
                      description: exp.highlights.join('\n'),
                      icon: exp.icon,
                      isLast: isLast,
                      accent: accent,
                      animate: _visibleItems[index] ?? false,
                      delay: index * 200,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Enhanced 3D Timeline entry with hover effects and animations.
class TimelineEntry3D extends StatefulWidget {
  const TimelineEntry3D({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    required this.icon,
    required this.isLast,
    required this.accent,
    required this.animate,
    required this.delay,
    super.key,
  });

  final String title;
  final String subtitle;
  final String period;
  final String description;
  final IconData icon;
  final bool isLast;
  final Color accent;
  final bool animate;
  final int delay;

  @override
  State<TimelineEntry3D> createState() => _TimelineEntry3DState();
}

class _TimelineEntry3DState extends State<TimelineEntry3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hovered = false;
  bool _localAnimate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          setState(() => _localAnimate = true);
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(TimelineEntry3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_localAnimate) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          setState(() => _localAnimate = true);
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return _buildReducedMotionCard(context);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildCardBody(context, animateMotion: true),
      ),
    );
  }

  Widget _buildReducedMotionCard(BuildContext context) {
    return _buildCardBody(context, animateMotion: false);
  }

  Widget _buildCardBody(BuildContext context, {required bool animateMotion}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  (animateMotion ? AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _hovered ? 54 : 50,
                        height: _hovered ? 54 : 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.accent,
                              widget.accent.withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.accent.withValues(alpha: _hovered ? 0.5 : 0.3),
                              blurRadius: _hovered ? 20 : 12,
                              spreadRadius: _hovered ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: Colors.white, size: 22),
                      )
                    : Container(
                        width: _hovered ? 54 : 50,
                        height: _hovered ? 54 : 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.accent,
                              widget.accent.withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.accent.withValues(alpha: _hovered ? 0.5 : 0.3),
                              blurRadius: _hovered ? 20 : 12,
                              spreadRadius: _hovered ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: Colors.white, size: 22),
                      )),
                  if (!widget.isLast)
                    SizedBox(
                      height: 120,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.accent.withValues(alpha: 0.5),
                                widget.accent.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: (animateMotion ? AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _hovered
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _hovered
                                ? widget.accent.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.1),
                            width: _hovered ? 1.5 : 1,
                          ),
                          boxShadow: _hovered
                              ? [
                                  BoxShadow(
                                    color: widget.accent.withValues(alpha: 0.15),
                                    blurRadius: 25,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                        ),
                        transform: Matrix4.identity()..translate(_hovered ? -2.0 : 0.0, 0.0, 0.0),
                        child: _buildInnerContent(context),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _hovered
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _hovered
                                ? widget.accent.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.1),
                            width: _hovered ? 1.5 : 1,
                          ),
                          boxShadow: _hovered
                              ? [
                                  BoxShadow(
                                    color: widget.accent.withValues(alpha: 0.15),
                                    blurRadius: 25,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                        ),
                        child: _buildInnerContent(context),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 420;

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.accent.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        widget.period,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.accent.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        widget.period,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.6,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Animated timeline wrapper.
class AnimatedTimeline extends StatelessWidget {
  const AnimatedTimeline({
    required this.children,
    this.delay = const Duration(milliseconds: 200),
    super.key,
  });

  final List<Widget> children;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Column(children: children);
  }
}
