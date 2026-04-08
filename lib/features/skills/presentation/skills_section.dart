import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_divider.dart';
import '../data/skills_data.dart';
import '../domain/skill_model.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final Map<int, bool> _visibleCategories = {};

  @override
  Widget build(BuildContext context) {
    final columns = context.isDesktop
        ? 3
        : context.isTablet
            ? 2
            : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionDivider(
          title: 'Skills',
          icon: Icons.code_outlined,
          subtitle: 'Technical expertise and proficiency',
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.3,
          ),
          itemCount: SkillsData.categories.length,
          itemBuilder: (context, index) {
            final category = SkillsData.categories[index];
            final categoryAccent = _getCategoryColor(index);
            
            return VisibilityDetector(
              key: Key('skill-category-$index'),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.3 && !_visibleCategories.containsKey(index)) {
                  setState(() => _visibleCategories[index] = true);
                }
              },
              child: SkillCategoryCard(
                title: category.title,
                icon: category.icon,
                skills: category.skills,
                accent: categoryAccent,
                animate: _visibleCategories[index] ?? false,
                delay: index * 150,
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}

/// Animated skill category card with glassmorphism effect.
class SkillCategoryCard extends StatefulWidget {
  const SkillCategoryCard({
    required this.title,
    required this.icon,
    required this.skills,
    required this.accent,
    required this.animate,
    required this.delay,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<Skill> skills;
  final Color accent;
  final bool animate;
  final int delay;

  @override
  State<SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<SkillCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
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
      begin: const Offset(0, 0.2),
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
  void didUpdateWidget(SkillCategoryCard oldWidget) {
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
    final isMobile = context.isMobile;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.accent.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(widget.icon, color: widget.accent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: min(widget.skills.length, 4),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final skill = widget.skills[index];
                      return AnimatedSkillBar(
                        skill: skill.name,
                        proficiency: skill.proficiency,
                        accent: widget.accent,
                        animate: _localAnimate,
                        delay: index * 100,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int min(int a, int b) => a < b ? a : b;
}

/// Individual animated skill bar with percentage.
class AnimatedSkillBar extends StatefulWidget {
  const AnimatedSkillBar({
    required this.skill,
    required this.proficiency,
    required this.accent,
    required this.animate,
    required this.delay,
    super.key,
  });

  final String skill;
  final double proficiency;
  final Color accent;
  final bool animate;
  final int delay;

  @override
  State<AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  bool _localAnimate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimation = Tween<double>(begin: 0, end: widget.proficiency).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

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
  void didUpdateWidget(AnimatedSkillBar oldWidget) {
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
    final percentage = (widget.proficiency * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.skill,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, _) {
                return Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: widget.accent.withValues(alpha: 0.9),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, _) {
                return FractionallySizedBox(
                  widthFactor: _progressAnimation.value,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accent.withValues(alpha: 0.6),
                          widget.accent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}